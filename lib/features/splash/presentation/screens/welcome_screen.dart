import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../shell/main_shell.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../../core/services/podcast_service.dart';

class WelcomeScreen extends StatefulWidget {
  final String role;
  final String idCode;

  const WelcomeScreen({super.key, required this.role, required this.idCode});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _fluidController;
  
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardSlide;
  late final Animation<double> _cardOpacity;
  late final Animation<double> _statusOpacity;

  @override
  void initState() {
    super.initState();
    _playOpeningSound();

    // Staggered Entrance Animation (Sırayla Ekrana Giriş Animasyonu)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Yavaş ve akıcı sıvı mesh gradyan hareketi için controller
    _fluidController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // 1. Logo Animasyonları (0ms - 800ms)
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // 2. Cam Panel Animasyonları (300ms - 1200ms)
    _cardScale = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.65, curve: Curves.easeOutCubic),
      ),
    );
    _cardSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
      ),
    );
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOut),
      ),
    );

    // 3. Durum Çubuğu Animasyonu (800ms - 1600ms)
    _statusOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward().then((_) {
      PodcastService().cleanCacheIfNeeded();

      // Anasayfaya asil geçiş
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 900),
              pageBuilder: (context, animation, secondaryAnimation) => const MainShell(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        }
      });
    });
  }

  void _playOpeningSound() async {
    try {
      final player = AudioPlayer();
      await player.play(BytesSource(SfxSynthesizer.getChime()));
      player.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed || state == PlayerState.stopped) {
          player.dispose();
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _fluidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Apple Pro Koyu Gece Mavisi / Siyah
      body: Stack(
        children: [
          // ── 1. KATMAN: DİNAMİK MESH GRADYAN SIVI HAREKETLERİ (Apple Siri / macOS Style) ──
          
          // Küre A (Sol Üst - Okyanus Mavisi)
          Positioned(
            top: -120,
            left: -120,
            child: AnimatedBuilder(
              animation: _fluidController,
              builder: (context, child) {
                final double angle = _fluidController.value * 2 * pi;
                final double dx = sin(angle) * 45;
                final double dy = cos(angle) * 35;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: child,
                );
              },
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D2FF).withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D2FF).withOpacity(0.12),
                      blurRadius: 120,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Küre B (Sağ Orta/Alt - Derin Lavanta / Mor)
          Positioned(
            bottom: size.height * 0.18,
            right: -130,
            child: AnimatedBuilder(
              animation: _fluidController,
              builder: (context, child) {
                final double angle = _fluidController.value * 2 * pi;
                final double dx = cos(angle + pi) * 50;
                final double dy = sin(angle + pi) * 40;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: child,
                );
              },
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7C3AED).withOpacity(0.09),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.09),
                      blurRadius: 130,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Küre C (Orta Sol - Derin Zümrüt / Teal)
          Positioned(
            top: size.height * 0.35,
            left: -140,
            child: AnimatedBuilder(
              animation: _fluidController,
              builder: (context, child) {
                final double angle = _fluidController.value * 2 * pi;
                final double dx = sin(angle + pi/2) * 35;
                final double dy = cos(angle - pi/2) * 45;
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: child,
                );
              },
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0D9488).withOpacity(0.07),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.07),
                      blurRadius: 110,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── 2. KATMAN: ULTRA PREMIUM BULANIKLAŞTIRMA (Akışkan Zemin Maskesi) ──
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 90, sigmaY: kIsWeb ? 0 : 90),
              child: Container(
                color: Colors.black.withOpacity(0.15),
              ),
            ),
          ),

          // ── 3. KATMAN: SUNUM VE YÖNLENDİRME (Staggered UI) ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── LOGO ECLIPSE GLOW (Güneş Tutulması / Rim Light Efekti) ──
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 35,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: const Color(0xFF00D2FF).withOpacity(0.35),
                          blurRadius: 45,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 145,
                      height: 145,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/app_logo.png',
                          width: 145,
                          height: 145,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ── DYNAMIC APPLE LEAD DESIGNER ARTWORK (Sadece Orijinal Yazılar + Soft Çizgiler) ──
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _cardOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _cardSlide.value),
                        child: Transform.scale(
                          scale: _cardScale.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // 1. Ana Başlık: Hoş Geldiniz!
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Colors.white,
                            Color(0xFFF1F5F9),
                            Color(0xFFCBD5E1),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.35, 0.70, 1.0],
                        ).createShader(bounds),
                        child: Text(
                          'Hoş Geldiniz!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2. Yazıları Birbirine Bağlayan Zarif Dal Kavis Çizgisi (Organic Soft Vine Divider)
                      SizedBox(
                        width: 260,
                        height: 28,
                        child: CustomPaint(
                          painter: _VineDividerPainter(),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3. Rol Tanımı Yazısı: Değerli Öğretmenimiz / Öğrencimiz
                      Text(
                        'Değerli ${widget.role == 'Öğretmen' ? 'Öğretmenimiz' : 'Öğrencimiz'}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.92),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // ── YAZILIM HAZIRLAMA DURUMU (Apple Siri Style Loading Indicator) ──
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _statusOpacity.value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.40),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sistem arayüzü kuruluyor...',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.65),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── YAZILARI BİRBİRİNE BAĞLAYAN ZARİF DAL KAVİS ÇİZGİSİ (Soft Organic Vine Divider) ──
class _VineDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 1. Sol Dal Path (S-Curve Vine Branch)
    final leftPath = Path();
    leftPath.moveTo(centerX - 6, centerY);
    leftPath.cubicTo(
      centerX - 35, centerY - 8,
      centerX - 70, centerY + 8,
      centerX - 115, centerY,
    );

    // Sol zarif filiz/yaprak kıvrımları
    leftPath.moveTo(centerX - 42, centerY - 4);
    leftPath.quadraticBezierTo(centerX - 48, centerY - 13, centerX - 58, centerY - 9);

    leftPath.moveTo(centerX - 72, centerY + 4);
    leftPath.quadraticBezierTo(centerX - 78, centerY + 13, centerX - 88, centerY + 8);

    // 2. Sağ Dal Path (S-Curve Vine Branch)
    final rightPath = Path();
    rightPath.moveTo(centerX + 6, centerY);
    rightPath.cubicTo(
      centerX + 35, centerY - 8,
      centerX + 70, centerY + 8,
      centerX + 115, centerY,
    );

    // Sağ zarif filiz/yaprak kıvrımları
    rightPath.moveTo(centerX + 42, centerY - 4);
    rightPath.quadraticBezierTo(centerX + 48, centerY - 13, centerX + 58, centerY - 9);

    rightPath.moveTo(centerX + 72, centerY + 4);
    rightPath.quadraticBezierTo(centerX + 78, centerY + 13, centerX + 88, centerY + 8);

    // Boya & Işıltılı Neon Gradient Ayarları
    final vinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x6000E5FF),
          Color(0xFF00E5FF),
          Color(0xFF38BDF8),
          Color(0xFF00E5FF),
          Color(0x6000E5FF),
          Colors.transparent,
        ],
        stops: [0.0, 0.15, 0.35, 0.5, 0.65, 0.85, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x3000E5FF),
          Color(0x8000E5FF),
          Color(0x3000E5FF),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(leftPath, glowPaint);
    canvas.drawPath(leftPath, vinePaint);

    canvas.drawPath(rightPath, glowPaint);
    canvas.drawPath(rightPath, vinePaint);

    // Merkez Tomurcuk / Elmas Düğümü
    final nodePath = Path();
    nodePath.moveTo(centerX, centerY - 4.5);
    nodePath.lineTo(centerX + 4.5, centerY);
    nodePath.lineTo(centerX, centerY + 4.5);
    nodePath.lineTo(centerX - 4.5, centerY);
    nodePath.close();

    final nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF00E5FF);

    final nodeGlow = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(nodePath, nodeGlow);
    canvas.drawPath(nodePath, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
