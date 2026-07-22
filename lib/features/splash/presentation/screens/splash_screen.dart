import 'dart:ui';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../shell/main_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import 'welcome_screen.dart';
import '../../../../core/presentation/widgets/glowing_border_card.dart';

/// Floating particle data for the splash background
class _Particle {
  double x, y, size, speed, opacity;
  _Particle({required this.x, required this.y, required this.size, required this.speed, required this.opacity});
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _shineAnimation;
  late final Animation<double> _logoRotationAnimation;

  final List<_Particle> _particles = [];
  final _random = Random();
  AudioPlayer? _splashSfxPlayer;
  bool _soundPlayed = false;
  bool _isPressed = false; // Apple butona basma hissi için state takibi
  late final int _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;

    // Generate particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble() * 1.5 + 0.5, // Start below or in lower half
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.1,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2 saniye: Daha sakin ve asil nefes alma
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate( // Maksimum 1.03: Mikro süzülme
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine, // Organik dalga
      ),
    );

    _shineAnimation = Tween<double>(begin: -0.3, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Pusula dönüş animasyonu: Kuzeye otururken yaylanarak salınım yapar (Magnetic Oscillation)
    _logoRotationAnimation = Tween<double>(begin: -2.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Play splash sound effect
    _playSplashSound();

    // Sayfa geçişinin (600ms) tamamlanmasını bekleyip animasyonu başlatıyoruz
    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) {
        _controller.forward().then((_) {
          _pulseController.repeat(reverse: true);
        });
      }
    });
  }

  Uint8List _generateSplashSoundBytes() {
    final sampleRate = 44100;
    final duration = 4.0;
    final numSamples = (sampleRate * duration).toInt();

    // Frequencies for a Cmaj9 chord (C4, E4, G4, B4, D5)
    final notes = [261.63, 329.63, 392.00, 493.88, 587.33];
    final delays = [0.0, 0.08, 0.16, 0.24, 0.32];

    final samples = Float32List(numSamples);

    for (var i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      var sample = 0.0;

      for (var j = 0; j < notes.length; j++) {
        final note = notes[j];
        final delay = delays[j];

        if (t > delay) {
          final tt = t - delay;
          // Envelope: fast attack, exponential decay
          final attack = 0.05;
          var env = 0.0;
          if (tt < attack) {
            env = tt / attack;
          } else {
            env = exp(-(tt - attack) * 2.0);
          }

          // Sine wave with harmonics for a bell/vibraphone tone
          final freq = note;
          var val = sin(2 * pi * freq * tt);
          val += 0.4 * sin(2 * pi * freq * 2.0 * tt) * exp(-tt * 4.0);
          val += 0.2 * sin(2 * pi * freq * 3.0 * tt) * exp(-tt * 6.0);
          val += 0.1 * sin(2 * pi * freq * 4.0 * tt) * exp(-tt * 8.0);

          // Tremolo/Vibrato effect
          final lfo = 1.0 + 0.1 * sin(2 * pi * 5.0 * tt);

          sample += val * env * lfo;
        }
      }

      // Normalize
      sample = sample / (notes.length * 1.5);

      // Soft clipping
      if (sample > 1.0) sample = 1.0;
      if (sample < -1.0) sample = -1.0;

      samples[i] = sample;
    }

    // Create WAV bytes
    final subchunk2Size = numSamples * 2; // 16-bit samples
    final wavData = ByteData(44 + subchunk2Size);

    // RIFF Header
    wavData.setUint8(0, 0x52); // R
    wavData.setUint8(1, 0x49); // I
    wavData.setUint8(2, 0x46); // F
    wavData.setUint8(3, 0x46); // F
    wavData.setUint32(4, 36 + subchunk2Size, Endian.little);
    wavData.setUint8(8, 0x57); // W
    wavData.setUint8(9, 0x41); // A
    wavData.setUint8(10, 0x56); // V
    wavData.setUint8(11, 0x45); // E

    // Subchunk 1 (fmt)
    wavData.setUint8(12, 0x66); // f
    wavData.setUint8(13, 0x6D); // m
    wavData.setUint8(14, 0x74); // t
    wavData.setUint8(15, 0x20); // 
    wavData.setUint32(16, 16, Endian.little); // Subchunk1Size
    wavData.setUint16(20, 1, Endian.little); // AudioFormat (1 = PCM)
    wavData.setUint16(22, 1, Endian.little); // NumChannels (1 = Mono)
    wavData.setUint32(24, sampleRate, Endian.little); // SampleRate
    wavData.setUint32(28, sampleRate * 2, Endian.little); // ByteRate (SampleRate * NumChannels * BitsPerSample/8)
    wavData.setUint16(32, 2, Endian.little); // BlockAlign (NumChannels * BitsPerSample/8)
    wavData.setUint16(34, 16, Endian.little); // BitsPerSample

    // Subchunk 2 (data)
    wavData.setUint8(36, 0x64); // d
    wavData.setUint8(37, 0x61); // a
    wavData.setUint8(38, 0x74); // t
    wavData.setUint8(39, 0x61); // a
    wavData.setUint32(40, subchunk2Size, Endian.little);

    // Write samples
    for (var i = 0; i < numSamples; i++) {
      final sampleInt = (samples[i] * 32767.0).toInt();
      wavData.setInt16(44 + i * 2, sampleInt, Endian.little);
    }

    return wavData.buffer.asUint8List();
  }

  Future<void> _playSplashSound() async {
    if (_soundPlayed) return;
    try {
      _splashSfxPlayer ??= AudioPlayer();
      await _splashSfxPlayer!.setVolume(0.5);
      final soundBytes = _generateSplashSoundBytes();
      await _splashSfxPlayer!.play(
        BytesSource(soundBytes),
      );
      _soundPlayed = true;
    } catch (e) {
      debugPrint('Error playing splash sound: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    
    // Web platformunda AudioPlayer has been disposed hatasını önlemek için güvenli durdurma ve imha
    final player = _splashSfxPlayer;
    if (player != null) {
      player.stop().then((_) => player.dispose()).catchError((_) {});
    }
    
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    // Play splash sound on user interaction to bypass browser autoplay restrictions
    await _playSplashSound();
    
    await ref.read(profileProvider.notifier).loadProfile();
    final profileState = ref.read(profileProvider);

    if (!mounted) return;

    if (profileState.role == null || profileState.role!.isEmpty) {
      _showRoleSelectorDialog();
    } else {
      _goToWelcomeScreen(profileState.role!, profileState.idCode ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF030F26), Color(0xFF0A192F)],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // ── Dynamic Fluid Mesh Gradient Spheres (Apple Siri / Samsung Style) ──
                // Küre A (Sol Üst - Cyan)
                Positioned(
                  top: -120,
                  left: -120,
                  child: AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      final double angle = _particleController.value * 2 * pi;
                      return Transform.translate(
                        offset: Offset(sin(angle) * 35, cos(angle) * 25),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 360,
                      height: 360,
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

                // Küre B (Sağ Alt - Mor)
                Positioned(
                  bottom: -100,
                  right: -100,
                  child: AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, child) {
                      final double angle = _particleController.value * 2 * pi;
                      return Transform.translate(
                        offset: Offset(cos(angle) * 40, sin(angle) * 30),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF7C3AED).withOpacity(0.09),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withOpacity(0.09),
                            blurRadius: 130,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Blur Katmanı (Mesh auraları süzgeçten geçirir) ──
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 80, sigmaY: kIsWeb ? 0 : 80),
                    child: Container(color: Colors.black.withOpacity(0.15)),
                  ),
                ),

                // ── Ana İçerik ──
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60), // Butona yer açmak için biraz aşağı kaydırdık
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
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
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.0),
                                            Colors.white.withOpacity(0.0),
                                            Colors.white.withOpacity(0.65),
                                            Colors.white.withOpacity(0.0),
                                            Colors.white.withOpacity(0.0),
                                          ],
                                          stops: [
                                            0.0,
                                            (_shineAnimation.value - 0.15).clamp(0.0, 1.0),
                                            _shineAnimation.value.clamp(0.0, 1.0),
                                            (_shineAnimation.value + 0.15).clamp(0.0, 1.0),
                                            1.0,
                                          ],
                                        ).createShader(rect);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Transform.rotate(
                                        angle: _logoRotationAnimation.value,
                                        child: child,
                                      ),
                                    );
                                  },
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
                        ),
                      ),
                      const SizedBox(height: 40), // Dikey ritim dengelendi: 32 -> 40
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
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
                                   'Turizm Defterim',
                                   style: GoogleFonts.outfit(
                                     fontSize: 40,
                                     fontWeight: FontWeight.w900,
                                     color: Colors.white, // ShaderMask maskesi için beyaz kalmalı
                                     letterSpacing: 1.5,
                                   ),
                                 ),
                               ),
                              const SizedBox(height: 12), // Dikey ritim dengelendi: 8 -> 12
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A).withOpacity(0.50), // Derin uzay camı
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15), // 1.2px hairline border
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
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Turizm Mesleki ve Teknik Anadolu Lisesi',
                                            textAlign: TextAlign.center,
                                            textScaler: TextScaler.noScaling,
                                            style: GoogleFonts.outfit(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600, // Daha kibar
                                              color: Colors.white.withOpacity(0.82), // Hiyerarşik gümüş beyazı
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          ShaderMask(
                                            shaderCallback: (bounds) => const LinearGradient(
                                              colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)], // Sınıflar ekranı uyumlu Neon Cyan'dan Maviye geçiş
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                            child: Text(
                                              'Konaklama ve Seyahat Hizmetleri Uygulaması',
                                              textAlign: TextAlign.center,
                                              textScaler: TextScaler.noScaling,
                                              style: GoogleFonts.outfit(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white, // ShaderMask maskesi için beyaz kalmalı
                                                letterSpacing: 0.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60), // Dikey ritim dengelendi: 80 -> 60 // Yazar ile buton arasına boşluk
                      
                      // ── Animasyonlu Giriş Butonu ──
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _pulseAnimation,
                          child: GestureDetector(
                            onTapDown: (_) => setState(() => _isPressed = true),
                            onTapCancel: () => setState(() => _isPressed = false),
                            onTapUp: (_) {
                              setState(() => _isPressed = false);
                              // Apple klavye tuşu tıklama tepki süresi (80ms) sonrası navigasyon
                              Future.delayed(const Duration(milliseconds: 80), () {
                                if (mounted) {
                                  _navigateToHome();
                                }
                              });
                            },
                            child: AnimatedScale(
                              scale: _isPressed ? 0.96 : 1.0, // Apple standardı: Sadece %4 mikro-basış payı
                              duration: _isPressed 
                                  ? const Duration(milliseconds: 60)   // Basılırken ultra hızlı tepki (60ms)
                                  : const Duration(milliseconds: 150),  // Bırakılırken pürüzsüz ve tok geri büyüme (150ms)
                              curve: _isPressed 
                                  ? Curves.easeOutQuad 
                                  : Curves.easeOutCubic, // Kararlı ve profesyonel sönümlenme
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5), // Premium ince kenar aydınlatması (Rim Light)
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0.95),
                                    ],
                                  ),
                                  boxShadow: [
                                    // 1. Derinlik gölgesi (Depth Shadow)
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 15,
                                      offset: const Offset(0, 10),
                                    ),
                                    // 2. Işık yayılımı (Sky Blue Aura Glow)
                                    BoxShadow(
                                      color: const Color(0xFF7DD3FC).withValues(alpha: 0.45),
                                      blurRadius: 25,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'GİRİŞ',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryMid,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: AppColors.primaryMid,
                                      size: 20, // İkon boyutu 24'ten 20'ye çekilerek dengelendi
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Alt Kısım (Yazar Bilgisi) ──
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'TASARIM & GELİŞTİRME',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Erol Mert YURDAKUL',
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF1F5F9),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRoleSelectorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlowingBorderCard(
                borderRadius: 28,
                glowColors: const [
                  Color(0xFF06B6D4),
                  Color(0xFF0891B2),
                  Color(0xFFFF6B6B),
                  Color(0xFFEE5253),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0F172A).withOpacity(0.85),
                            const Color(0xFF1E293B).withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF06B6D4).withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF06B6D4).withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: Color(0xFF06B6D4),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFE2E8F0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              'Kullanıcı Türü Seçimi',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Öğrenci Butonu
                          _buildRoleButton(
                            title: 'Öğrenciyim',
                            icon: Icons.school_rounded,
                            gradient: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
                            onTap: () => _selectRole('Öğrenci'),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Öğretmen Butonu
                          _buildRoleButton(
                            title: 'Öğretmenim',
                            icon: Icons.co_present_rounded,
                            gradient: const [Color(0xFFFF6B6B), Color(0xFFEE5253)],
                            onTap: () => _selectRole('Öğretmen'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleButton({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradient[0].withOpacity(0.95),
                      gradient[1].withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectRole(String role) {
    Navigator.pop(context); // Close role selector dialog
    _showGradeSelectorDialog(role);
  }

  void _showGradeSelectorDialog(String role) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlowingBorderCard(
                borderRadius: 28,
                glowColors: const [
                  Color(0xFFE8AA42),
                  Color(0xFF06B6D4),
                  Color(0xFFFF6B6B),
                  Color(0xFF10B981),
                ],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0F172A).withOpacity(0.85),
                            const Color(0xFF1E293B).withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8AA42).withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE8AA42).withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_stories_rounded,
                              color: Color(0xFFE8AA42),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFE2E8F0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              'Sınıfını Seç',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sınıf seçiminize göre uygulama kullanımı konusunda sizin için hazırlanan rehber özelleştirilecektir.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 28),
                          
                          // 9. Sınıf
                          _buildGradeSelectButton(
                            title: '9. Sınıf',
                            icon: Icons.explore_rounded,
                            gradient: AppColors.grade9Gradient,
                            onTap: () => _selectGrade(role, '9. Sınıf'),
                          ),
                          const SizedBox(height: 12),
                          // 10. Sınıf
                          _buildGradeSelectButton(
                            title: '10. Sınıf',
                            icon: Icons.room_service_rounded,
                            gradient: AppColors.grade10Gradient,
                            onTap: () => _selectGrade(role, '10. Sınıf'),
                          ),
                          const SizedBox(height: 12),
                          // 11. Sınıf
                          _buildGradeSelectButton(
                            title: '11. Sınıf',
                            icon: Icons.public_rounded,
                            gradient: AppColors.grade11Gradient,
                            onTap: () => _selectGrade(role, '11. Sınıf'),
                          ),
                          const SizedBox(height: 12),
                          // 12. Sınıf
                          _buildGradeSelectButton(
                            title: '12. Sınıf',
                            icon: Icons.airport_shuttle_rounded,
                            gradient: AppColors.grade12Gradient,
                            onTap: () => _selectGrade(role, '12. Sınıf'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradeSelectButton({
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradient[0].withOpacity(0.95),
                      gradient[1].withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.0),
                      ),
                      child: Icon(icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectGrade(String role, String grade) async {
    Navigator.pop(context); // Close grade selector dialog
    await ref.read(profileProvider.notifier).saveRole(role);
    await ref.read(profileProvider.notifier).saveGrade(grade);
    
    final profileState = ref.read(profileProvider);
    _goToWelcomeScreen(role, profileState.idCode ?? '');
  }

  void _goToWelcomeScreen(String role, String idCode) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => WelcomeScreen(
          role: role,
          idCode: idCode,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

/// Custom painter for floating sparkle particles
/// Renkler önceden hesaplanır — her karede withOpacity() çağrısı yapılmaz.
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double timeElapsed;
  final double fadeIn;

  // 32 kademeli renk tablosu —opacity 0..1 aralığını karşılar
  static final List<Color> _whiteCache = List.generate(
    33,
    (i) => Colors.white.withOpacity(i / 32),
  );
  static final List<Color> _whiteCoreCache = List.generate(
    33,
    (i) => Colors.white.withOpacity((i / 32) * 0.8),
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

      // Inner bright core
      final corePaint = Paint()..color = _whiteCoreCache[idx];
      canvas.drawCircle(Offset(x, y), p.size * 0.4, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
