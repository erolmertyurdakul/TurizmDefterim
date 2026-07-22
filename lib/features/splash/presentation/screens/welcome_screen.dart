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

                // ── DYNAMIC FROST GLASS CARD (Sıvı Cıva Başlık Tasarımı) ──
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 44),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.50), // Derin uzay grisi cam taban
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15), // 1px Hairline rim border
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: const Color(0xFF00D2FF).withOpacity(0.06), // Çok hafif gök aurası
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 25, sigmaY: kIsWeb ? 0 : 25), // Ultra derin kristal bluru
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28), // Denge için padding arttırıldı
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Sıvı Cıva / Gümüş Metalik Apple Başlığı
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color(0xFFE2E8F0),
                                    Color(0xFF94A3B8),
                                    Colors.white,
                                  ], // Metalik sıvı gümüş dalgalanması
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [0.0, 0.35, 0.70, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  'Hoş Geldiniz!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 38, // Başlık boyutu dengelendi (34 -> 38)
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Duru gümüş yazılı rol tanımı
                              Text(
                                'Değerli ${widget.role == 'Öğretmen' ? 'Öğretmenimiz' : 'Öğrencimiz'}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 18, // Font boyutu dengelendi (16.5 -> 18)
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Şık, ince, parıldayan neon kılavuz çizgi
                              Container(
                                width: 36,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00E5FF).withOpacity(0.6),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                      color: const Color(0xFF0F172A).withOpacity(0.40),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
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
                            color: Colors.white.withOpacity(0.65),
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
