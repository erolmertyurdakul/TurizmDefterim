import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../shell/main_shell.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../../core/services/podcast_service.dart';

/// Yüzen parçacık veri modeli (Kar tanesi)
class _Particle {
  double x, y, size, speed, opacity;
  _Particle({required this.x, required this.y, required this.size, required this.speed, required this.opacity});
}

class WelcomeScreen extends StatefulWidget {
  final String role;
  final String idCode;

  const WelcomeScreen({super.key, required this.role, required this.idCode});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _particleController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  final List<_Particle> _particles = [];
  final _random = Random();
  late final int _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _playOpeningSound();

    // Kar tanelerini üret
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble() * 1.5 + 0.5,
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.1,
      ));
    }
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Animasyonu başlat ve bitince 1.2 saniye bekleyip anasayfaya geç
    _controller.forward().then((_) {
      // Arka planda 10 dinleme barajına ulaşıldıysa önbelleği sessizce temizle (UI'ı etkilemez)
      PodcastService().cleanCacheIfNeeded();

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
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
    _controller.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── ZEMİN GRADYANI (Derin Lacivert / Siyah Taban) ──
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF070B19),
          ),

          // ── PREMIUM AKICI MESH GRADYAN KÜRELERİ (Fluid Ambient Glow) ──
          // Küre 1 (Sol Üst - Turkuaz / Cyan)
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final double angle = _particleController.value * 2 * pi;
                return Transform.translate(
                  offset: Offset(sin(angle) * 30, cos(angle) * 30),
                  child: child,
                );
              },
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withOpacity(0.25),
                  // Glow blur
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.25),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Küre 2 (Sağ Orta/Alt - Derin Mor / Violet)
          Positioned(
            bottom: size.height * 0.2,
            right: -120,
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final double angle = _particleController.value * 2 * pi;
                return Transform.translate(
                  offset: Offset(cos(angle) * 40, sin(angle) * 40),
                  child: child,
                );
              },
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.22),
                      blurRadius: 120,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Küre 3 (Sol Alt - Mavi / Indigo)
          Positioned(
            bottom: -150,
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          // ── BLUR KATMANI (Mesh gradyanları birleştirir ve cam etkisi oluşturur) ──
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),

          // ── YÜZEN YUMUŞAK PARÇACIKLAR ──
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              final elapsed = (DateTime.now().millisecondsSinceEpoch - _startTime) / 1000.0;
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  timeElapsed: elapsed,
                  fadeIn: _fadeAnimation.value,
                ),
              );
            },
          ),

          // ── ANA İÇERİK KATMANI (Sade, Çerçevesiz, Sofistike Tasarım) ──
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO: Splash ekranındaki gibi dış orbital halka + iç cam çerçeve halkası.
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0), // Dış ince orbital halka
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08), // Cam saydamlığı
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5), // Çerçeve halkası
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.35),
                              blurRadius: 40,
                              spreadRadius: 6,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.08), // İç parıldama halkası
                              blurRadius: 25,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: ClipOval(
                            child: Transform.scale(
                              scale: 1.05,
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // CAM PANEL: Kalın beyaz çerçevesi olmayan, yumuşacık ve premium bir geçişe sahip cam kart.
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0518).withOpacity(0.65), // Mor tabanlı derin koyu cam arka planı
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: const Color(0xFFD8B4FE).withOpacity(0.2), // Lavanta/mor renkli neon sınır çizgisi
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC084FC).withOpacity(0.2), // Yumuşak neon mor aura gölgesi
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Karta özel kristal cam bluru
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Gradyanlı ve Işıltılı Hoş Geldiniz Başlığı
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Colors.white, Color(0xFFE9D5FF), Color(0xFFC084FC)], // Eflatun/mor gradyanı
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: Text(
                                    'Hoş Geldiniz!',
                                    style: GoogleFonts.outfit(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Değerli ${widget.role == 'Öğretmen' ? 'Öğretmenimiz' : 'Öğrencimiz'}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFF3E8FF), // İnci morumsu beyazı
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // HAZIRLANIYOR DURUMU: Minimum seviyede, dikkat dağıtmayan şık yükleniyor göstergesi.
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.04),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent.withOpacity(0.7)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ders defteriniz hazırlanıyor...',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kar taneleri için custom painter sınıfı
/// Renkler önceden hesaplanır — her karede withOpacity() çağrısı yapılmaz.
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double timeElapsed;
  final double fadeIn;

  static final List<Color> _whiteCache = List.generate(
    33,
    (i) => Colors.white.withOpacity(i / 32),
  );

  _ParticlePainter({required this.particles, required this.timeElapsed, required this.fadeIn});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = ((p.y - timeElapsed * p.speed * 0.5) % 1.5) * size.height - size.height * 0.25;
      final x = p.x * size.width;

      final opacity = (p.opacity * fadeIn).clamp(0.0, 1.0);
      final idx = (opacity * 32).round().clamp(0, 32);

      final paint = Paint()
        ..color = _whiteCache[idx]
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.6);
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.timeElapsed != timeElapsed || oldDelegate.fadeIn != fadeIn;
  }
}
