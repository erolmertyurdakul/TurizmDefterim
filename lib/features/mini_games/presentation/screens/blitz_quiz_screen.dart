import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../providers/blitz_quiz_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../badges/providers/badge_provider.dart';

class BlitzQuizScreen extends ConsumerStatefulWidget {
  const BlitzQuizScreen({super.key});

  @override
  ConsumerState<BlitzQuizScreen> createState() => _BlitzQuizScreenState();
}

class _BlitzQuizScreenState extends ConsumerState<BlitzQuizScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isBgmPlaying = false;

  // Combo alev animasyonu — artık _FlameParticles widget'ı kendi yönetiyor

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.9,
      upperBound: 1.1,
    );

    // Giriş ekranı pedagojik zil/melodi sesi
    _playIntroSound();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  void _triggerPulse() {
    _pulseController.forward(from: 0.9).then((_) => _pulseController.reverse());
  }

  // ── Müzik & SFX Oynatma Metotları ──
  bool get _isMuted => !ref.read(soundSettingsProvider);

  Future<void> _startBGMMusic() async {
    if (_isBgmPlaying) return;
    _isBgmPlaying = true;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(UrlSource('https://freepd.com/music/Mega%20Hyper%20Drive.mp3'));
      await _bgmPlayer.setVolume(_isMuted ? 0.0 : 0.22);
    } catch (e) {
      debugPrint("Error starting BGM: $e");
    }
  }

  Future<void> _stopBGMMusic() async {
    if (!_isBgmPlaying) return;
    _isBgmPlaying = false;
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint("Error stopping BGM: $e");
    }
  }

  Future<void> _playSFX(bool isCorrect) async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.stop();
      if (isCorrect) {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getCorrectAnswer()));
      } else {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getError()));
      }
    } catch (e) {
      debugPrint("Error playing SFX: $e");
    }
  }

  Future<void> _playIntroSound() async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(BytesSource(SfxSynthesizer.getQuizIntro()));
      await _sfxPlayer.setVolume(0.4);
    } catch (e) {
      debugPrint("Error playing Intro Sound: $e");
    }
  }

  Future<void> _playTransitionSound() async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(BytesSource(SfxSynthesizer.getQuizIntro()));
      await _sfxPlayer.setVolume(0.4);
    } catch (e) {
      debugPrint("Error playing Transition Sound: $e");
    }
  }

  void _startGameWithSound(BlitzQuizGameNotifier notifier) {
    _playTransitionSound();
    notifier.startGame();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(blitzQuizProvider);
    final notifier = ref.read(blitzQuizProvider.notifier);

    // Riverpod State dinleyicisi: Doğru/Yanlış cevap ses efekti tetikleme ve oyun sonu
    ref.listen<BlitzQuizGameState>(blitzQuizProvider, (previous, next) {
      if (previous != null && !previous.isAnswered && next.isAnswered) {
        if (next.selectedOptionIndex != null) {
          final isCorrect = next.selectedOptionIndex == next.questions[next.currentIndex].correctOptionIndex;
          _playSFX(isCorrect);
        }
      }
      if (previous != null && previous.isPlaying && !next.isPlaying) {
        ref.read(badgeProgressProvider.notifier).incrementBlitzQuizCompleted();
      }
    });

    // Global ses toggle dinle — mute değiştiğinde BGM volume güncelle
    final isSoundOn = ref.watch(soundSettingsProvider);
    if (_isBgmPlaying) {
      _bgmPlayer.setVolume(isSoundOn ? 0.22 : 0.0);
    }

    // Oyun durumuna göre müzik kontrolü
    if (state.isPlaying) {
      _startBGMMusic();
    } else {
      _stopBGMMusic();
    }

    // Süre azaldığında (10 saniye ve altı) nabız animasyonunu başlat
    if (state.isPlaying && state.timeLeft <= 10 && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if ((!state.isPlaying || state.timeLeft > 10) && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 1.0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C091C), 
      appBar: AppBar(
        title: Text(
          'Blitz Test ⚡',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            notifier.endGame();
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => ref.read(soundSettingsProvider.notifier).toggleMute(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Icon(
                      isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      color: isSoundOn ? const Color(0xFF00FFCC) : Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: state.isPlaying
            ? PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: state.timeLeft / 60.0,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      state.timeLeft <= 10
                          ? const Color(0xFFFF5252) // Kırmızı tehlike
                          : state.timeLeft <= 25
                              ? const Color(0xFFFF9F43) // Turuncu uyarı
                              : const Color(0xFF00FFCC), // Canlı camgöbeği (güvenli)
                    ),
                    minHeight: 4,
                  ),
                ),
              )
            : null,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090616), Color(0xFF1E1035), Color(0xFF0C091C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Ambient neon light circles (spots) for premium gaming feel
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5252).withOpacity(0.07),
                      blurRadius: 120,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFCC).withOpacity(0.07),
                      blurRadius: 120,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: state.isPlaying
                  ? _buildGamePlay(state, notifier)
                  : state.isGameOver
                      ? _buildGameOver(state, notifier)
                      : _buildIntro(state, notifier),
            ),
            // Yüksek Kombo Alev Parçacık Animasyonları (bağımsız widget — tüm ekranı yeniden çizmez)
            if (state.isPlaying && state.comboCount >= 3)
              _FlameParticles(comboCount: state.comboCount),
          ],
        ),
      ),
    );
  }

  // ── Giriş Ekranı (Intro Screen) ──
  Widget _buildIntro(BlitzQuizGameState state, BlitzQuizGameNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFFF7A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5252).withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.flash_on_rounded, size: 80, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            'Blitz Test',
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Zamana karşı yarış! 4 sınıfın tüm konularından karışık sorular karşına çıkacak. 60 saniyede ne kadar çok soru çözebilirsin?',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Kurallar Kutusu
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                _buildRuleRow('⏱️', 'Süre sınırı 60 saniyedir.'),
                const SizedBox(height: 12),
                _buildRuleRow('🔥', 'Doğru cevap serileri (Kombo) puan çarpanını artırır ve alev efekti açar!'),
                const SizedBox(height: 12),
                _buildRuleRow('🎁', 'Her 5 doğru komboda +3 saniye bonus süre kazanırsın.'),
                const SizedBox(height: 12),
                _buildRuleRow('⏩', 'Zorlandığında "Pas Geç" jokerini kullanabilirsin.'),
                const SizedBox(height: 12),
                _buildRuleRow('❌', 'Her yanlış cevap -5 puan götürür.'),
              ],
            ),
          ),
          const Spacer(flex: 2),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startGameWithSound(notifier),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                shadowColor: const Color(0xFFFF5252).withValues(alpha: 0.5),
              ),
              child: Text(
                'BAŞLA 🚀',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRuleRow(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.90),
            ),
          ),
        ),
      ],
    );
  }

  // ── Oyun Oynanış Ekranı (Gameplay Screen) ──
  Widget _buildGamePlay(BlitzQuizGameState state, BlitzQuizGameNotifier notifier) {
    if (state.questions.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF5252)));
    }

    final question = state.questions[state.currentIndex];
    final isTimeLow = state.timeLeft <= 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Timer, Score & Combo HUD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skor
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKOR',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${state.score}',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFFD000),
                    ),
                  ),
                ],
              ),
              // Sayaç
              ScaleTransition(
                scale: _pulseController,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isTimeLow
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isTimeLow ? Colors.redAccent : Colors.white24,
                      width: 2,
                    ),
                    boxShadow: isTimeLow
                        ? [
                            BoxShadow(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_rounded,
                        color: isTimeLow ? Colors.redAccent : Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${state.timeLeft}s',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isTimeLow ? Colors.redAccent : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Combo / Seri Göstergesi
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SERİ',
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54),
                  ),
                  const SizedBox(height: 2),
                  _buildFlameComboHUD(state.comboCount),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Soru Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF261D4C), Color(0xFF161033)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Ders Kategorisi Etiketi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCourseDisplayName(question.courseId),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.purpleAccent.shade100,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      'Soru ${state.currentIndex + 1}',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  question.questionText,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pas Geç Joker Butonu (Siberpunk camgöbeği parıltılı tasarımı)
          if (!state.isAnswered)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: state.skipsRemaining > 0
                          ? [Colors.cyanAccent.withOpacity(0.12), Colors.blueAccent.withOpacity(0.04)]
                          : [Colors.white.withOpacity(0.02), Colors.transparent],
                    ),
                    border: Border.all(
                      color: state.skipsRemaining > 0
                          ? Colors.cyanAccent.withOpacity(0.35)
                          : Colors.white10,
                      width: 1.2,
                    ),
                    boxShadow: state.skipsRemaining > 0
                        ? [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.08),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: TextButton.icon(
                    onPressed: state.skipsRemaining > 0
                        ? () {
                            notifier.useSkipJoker();
                          }
                        : null,
                    icon: Icon(
                      Icons.fast_forward_rounded, 
                      color: state.skipsRemaining > 0 ? Colors.cyanAccent : Colors.white24, 
                      size: 18,
                    ),
                    label: Text(
                      'Pas Geç (${state.skipsRemaining} Joker)',
                      style: GoogleFonts.inter(
                        color: state.skipsRemaining > 0 ? Colors.cyanAccent : Colors.white30,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),

          // Şıklar Listesi
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                final option = question.options[index];
                return _buildOptionButton(index, option, question, state, notifier);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlameComboHUD(int comboCount) {
    final isFlameActive = comboCount >= 3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: isFlameActive
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isFlameActive
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4B2B).withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFlameActive) ...[
            const Icon(Icons.local_fire_department_rounded, color: Colors.yellowAccent, size: 24),
            const SizedBox(width: 4),
          ],
          Text(
            'x$comboCount',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: isFlameActive ? Colors.yellowAccent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    int index,
    String text,
    dynamic question,
    BlitzQuizGameState state,
    BlitzQuizGameNotifier notifier,
  ) {
    Color cardColor = Colors.white.withValues(alpha: 0.05);
    Color borderColor = Colors.white.withValues(alpha: 0.1);
    Color textColor = Colors.white70;
    IconData? icon;
    List<BoxShadow>? shadows;

    if (state.isAnswered) {
      if (index == question.correctOptionIndex) {
        cardColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.greenAccent;
        textColor = Colors.greenAccent;
        icon = Icons.check_circle_rounded;
        shadows = [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ];
      } else if (index == state.selectedOptionIndex) {
        cardColor = Colors.red.withValues(alpha: 0.2);
        borderColor = Colors.redAccent;
        textColor = Colors.redAccent;
        icon = Icons.cancel_rounded;
        shadows = [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ];
      } else {
        cardColor = Colors.white.withValues(alpha: 0.02);
        borderColor = Colors.transparent;
        textColor = Colors.white30;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (!state.isAnswered) {
                _triggerPulse();
                notifier.selectOption(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: borderColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, color: borderColor),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Oyun Sonu Ekranı (GameOver Screen) ──
  Widget _buildGameOver(BlitzQuizGameState state, BlitzQuizGameNotifier notifier) {
    String rankTitle = 'Amatör Hızcı';
    IconData badgeIcon = Icons.stars_rounded;
    Color color = const Color(0xFFFF5252);

    if (state.score >= 200) {
      rankTitle = 'Fırtına Çözücü ⚡';
      badgeIcon = Icons.bolt_rounded;
      color = const Color(0xFFFFD000);
    } else if (state.score >= 100) {
      rankTitle = 'Hızlı Sorucu ⭐';
      badgeIcon = Icons.workspace_premium_rounded;
      color = Colors.cyanAccent;
    }

    return Center(
      child: Transform.scale(
        scale: 0.95,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withValues(alpha: 0.3), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(badgeIcon, size: 64, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                'Süre Doldu!',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rankTitle,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 14),

              // Genel İstatistikler Kutusu
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Toplam Skor', '${state.score} Puan', const Color(0xFFFFD000)),
                    const Divider(color: Colors.white10, height: 12),
                    _buildStatRow('Toplam Doğru', '${state.correctCount}', Colors.greenAccent),
                    const Divider(color: Colors.white10, height: 12),
                    _buildStatRow('Toplam Yanlış', '${state.wrongCount}', Colors.redAccent),
                    const Divider(color: Colors.white10, height: 12),
                    _buildStatRow('En Yüksek Seri (Kombo)', '${state.maxCombo}', Colors.orangeAccent),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Ders Bazlı Doğru-Yanlış Analiz Tablosu
              _buildCourseStatsTable(state),
              const SizedBox(height: 14),

              // Puan Ekleme Bildirimi
              if (state.score > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded, color: Colors.greenAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '+${state.score} Genel Puan Hesabına Eklendi!',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 18),
              // Butonlar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white30),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Kapat',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _startGameWithSound(notifier),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Tekrar Dene 🔄',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  // Ders bazlı doğru/yanlış tablosunu çizer
  Widget _buildCourseStatsTable(BlitzQuizGameState state) {
    final courseIds = [
      'on_buro_rezervasyon',
      'surdurulebilir_turizm',
      'mesleki_yabanci_dil',
      'seyahat_acenteciligi',
    ];

    final hasAnyStats = courseIds.any((id) =>
        (state.correctByCourse[id] ?? 0) > 0 || (state.wrongByCourse[id] ?? 0) > 0);

    if (!hasAnyStats) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Colors.purpleAccent, size: 18),
              const SizedBox(width: 6),
              Text(
                'Ders Bazlı Soru Analizi',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...courseIds.map((courseId) {
            final correct = state.correctByCourse[courseId] ?? 0;
            final wrong = state.wrongByCourse[courseId] ?? 0;
            final total = correct + wrong;
            if (total == 0) return const SizedBox.shrink();

            final courseName = _getCourseDisplayName(courseId);

            return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          '$correct Doğru',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          '$wrong Yanlış',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Ders İsmini Dönüştürme Helper'ı ──
  String _getCourseDisplayName(String courseId) {
    switch (courseId) {
      case 'on_buro_rezervasyon':
        return 'Ön Büro Rezervasyon';
      case 'surdurulebilir_turizm':
        return 'Sürdürülebilir Turizm';
      case 'mesleki_yabanci_dil':
        return 'Mesleki Yabancı Dil';
      case 'seyahat_acenteciligi':
        return 'Seyahat Acenteciliği';
      default:
        return 'Genel Konular';
    }
  }
}

/// Alev parçacık animasyonu — kendi AnimationController'ı ile bağımsız çalışır,
/// ebeveyn ekranı yeniden çizmez.
class _FlameParticles extends StatefulWidget {
  final int comboCount;
  const _FlameParticles({required this.comboCount});

  @override
  State<_FlameParticles> createState() => _FlameParticlesState();
}

class _FlameParticlesState extends State<_FlameParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final List<Offset> _offsets = [];
  final List<double> _opacities = [];
  final List<double> _scales = [];
  final List<double> _speeds = [];
  final Random _rng = Random();

  // Color cache — withOpacity her karede yeni Color nesnesi yaratmaz
  static final List<Color> _coreColors = List.generate(
    20,
    (i) => Colors.white.withOpacity((i / 20).clamp(0.05, 1.0)),
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(_tick);
    _ctrl.repeat();
  }

  @override
  void didUpdateWidget(_FlameParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comboCount < 3 && _offsets.isNotEmpty) {
      _offsets.clear();
      _opacities.clear();
      _scales.clear();
      _speeds.clear();
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_tick);
    _ctrl.dispose();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    // Mevcut alevleri yukarı taşı
    for (int i = 0; i < _offsets.length; i++) {
      final newY = _offsets[i].dy - _speeds[i];
      final newX = _offsets[i].dx + sin(newY / 15) * 0.8;
      _offsets[i] = Offset(newX, newY);
      _opacities[i] -= 0.035;
    }
    // Sönenleri sil
    for (int i = _offsets.length - 1; i >= 0; i--) {
      if (_opacities[i] <= 0 || _offsets[i].dy < 0) {
        _offsets.removeAt(i);
        _opacities.removeAt(i);
        _scales.removeAt(i);
        _speeds.removeAt(i);
      }
    }
    // Yeni parçacık doğur
    if (_offsets.length < 18 && _rng.nextDouble() < 0.5) {
      final screenWidth = MediaQuery.of(context).size.width;
      _offsets.add(Offset(
        screenWidth - 75 + (_rng.nextDouble() * 50 - 25),
        85.0 + _rng.nextDouble() * 20,
      ));
      _opacities.add(0.8 + _rng.nextDouble() * 0.2);
      _scales.add(0.5 + _rng.nextDouble() * 0.7);
      _speeds.add(2.0 + _rng.nextDouble() * 2.5);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            if (_offsets.isEmpty) return const SizedBox.shrink();
            return CustomPaint(
              painter: _FlameParticlePainter(
                offsets: _offsets,
                opacities: _opacities,
                scales: _scales,
                coreColors: _coreColors,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Alev parçacıklarını canvas ile çizer — Text emoji yerine gradient daire kullanır.
/// withOpacity() renkleri önceden hesaplanmıştır.
class _FlameParticlePainter extends CustomPainter {
  final List<Offset> offsets;
  final List<double> opacities;
  final List<double> scales;
  final List<Color> coreColors;

  _FlameParticlePainter({
    required this.offsets,
    required this.opacities,
    required this.scales,
    required this.coreColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < offsets.length; i++) {
      final op = opacities[i].clamp(0.0, 1.0);
      final colorIdx = (op * (coreColors.length - 1)).round().clamp(0, coreColors.length - 1);
      final color = coreColors[colorIdx];
      final radius = 8.0 * scales[i];

      // Dış halo
      final glowPaint = Paint()
        ..color = color.withOpacity(op * 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.2);
      canvas.drawCircle(offsets[i], radius * 1.5, glowPaint);

      // İç çekirdek
      final corePaint = Paint()..color = color;
      canvas.drawCircle(offsets[i], radius * 0.5, corePaint);
    }
  }

  @override
  bool shouldRepaint(_FlameParticlePainter old) => true;
}
