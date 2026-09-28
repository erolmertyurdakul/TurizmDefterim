import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../../badges/providers/badge_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final List<QuizQuestion> questions;
  final List<Color> gradient;
  final String title;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.gradient,
    required this.title,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  bool _isFinished = false;
  final AudioPlayer _sfxPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _playQuizIntro();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  Future<void> _playQuizIntro() async {
    final isSoundOn = ref.read(soundSettingsProvider);
    if (!isSoundOn) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(BytesSource(SfxSynthesizer.getQuizIntro()));
      await _sfxPlayer.setVolume(0.4);
    } catch (e) {
      debugPrint("Error playing quiz intro: $e");
    }
  }

  Future<void> _playSFX(bool isCorrect) async {
    final isSoundOn = ref.read(soundSettingsProvider);
    if (!isSoundOn) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(0.8);
      if (isCorrect) {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getCorrectAnswer()));
      } else {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getError()));
      }
    } catch (e) {
      debugPrint("Error playing SFX: $e");
    }
  }

  void _onOptionSelected(int index) {
    if (_isAnswered) return;

    final isCorrect = index == widget.questions[_currentIndex].correctOptionIndex;
    _playSFX(isCorrect);

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _correctAnswers++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _isAnswered = false;
        _selectedOptionIndex = null;
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    ref.read(pointsProvider.notifier).addQuizPoints(_correctAnswers);
    
    // Increment quizzes completed for badge progress
    final isPerfect = _correctAnswers == widget.questions.length;
    ref.read(badgeProgressProvider.notifier).incrementQuizzesCompleted(isPerfect: isPerfect);
    ref.read(badgeProgressProvider.notifier).incrementQuestionsSolved(count: widget.questions.length);

    setState(() {
      _isFinished = true;
    });
  }

  Widget _buildQuizContent() {
    final question = widget.questions[_currentIndex];
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 1320 : double.infinity),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // İlerleme göstergesi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soru ${_currentIndex + 1} / ${widget.questions.length}',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 22 : 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryMid,
                    ),
                  ),
                  Text(
                    'Doğru: $_correctAnswers',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 22 : 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.questions.length,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.secondary,
                minHeight: isWide ? 10 : 6,
                borderRadius: BorderRadius.circular(10),
              ),
              SizedBox(height: isWide ? 18 : 8),

              // Soru Kartı (Mesleki Terimler tarzında, Ocean Gradient)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 28 : 14,
                  vertical: isWide ? 24 : 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.oceanGradient,
                  ),
                  borderRadius: BorderRadius.circular(isWide ? 22 : AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primarySeed.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  question.questionText,
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 26 : 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.45,
                  ),
                ),
              ),
              SizedBox(height: isWide ? 18 : 12),

              // Şıklar Listesi
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final optionText = question.options[index];
                    return _buildOptionTile(index, optionText, question, isWide);
                  },
                ),
              ),

              // Erol Hoca İpucu Kutusu (Mesleki Terimler stilinde)
              if (_isAnswered)
                _buildErolHocaTip(question.explanation, isWide),

              SizedBox(height: isWide ? 12 : 6),

              // İleri Butonu
              if (_isAnswered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMid,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: isWide ? 18 : 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isWide ? 18 : 12),
                      ),
                    ),
                    child: Text(
                      _currentIndex == widget.questions.length - 1
                          ? 'Sonuçları Gör 🏆'
                          : 'Sonraki Soru',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: isWide ? 20 : 14,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Şık Tasarımları (Mesleki Terimler testinden aynen alındı)
  Widget _buildOptionTile(int index, String text, QuizQuestion question, bool isWide) {
    Color tileColor = Colors.white;
    Color borderCol = Colors.transparent;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (_isAnswered) {
      if (index == question.correctOptionIndex) {
        tileColor = Colors.green.shade50;
        borderCol = Colors.green.shade400;
        textColor = Colors.green.shade900;
        trailingIcon = Icons.check_circle_rounded;
      } else if (index == _selectedOptionIndex) {
        tileColor = Colors.red.shade50;
        borderCol = Colors.red.shade400;
        textColor = Colors.red.shade900;
        trailingIcon = Icons.cancel_rounded;
      } else {
        tileColor = Colors.white.withValues(alpha: 0.5);
      }
    } else {
      if (_selectedOptionIndex == index) {
        borderCol = AppColors.primaryMid;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 14 : 6),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(isWide ? 20 : AppSizes.radiusMd),
        border: Border.all(
          color: borderCol,
          width: isWide ? 2.5 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primarySeed.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isWide ? 20 : AppSizes.radiusMd),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onOptionSelected(index),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 22 : 12,
                vertical: isWide ? 18 : 10,
              ),
              child: Row(
                children: [
                  Container(
                    width: isWide ? 44 : 28,
                    height: isWide ? 44 : 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isAnswered ? borderCol.withValues(alpha: 0.5) : Colors.grey.shade400,
                        width: isWide ? 2 : 1.5,
                      ),
                      color: _isAnswered ? borderCol.withValues(alpha: 0.1) : Colors.grey.shade100,
                    ),
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: isWide ? 21 : 15,
                        color: _isAnswered ? textColor : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: isWide ? 18 : 12),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 21 : 15.5,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        height: 1.35,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 10),
                    Icon(trailingIcon, color: borderCol, size: isWide ? 30 : 22),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Öğrenme Notu Kutusu (Mesleki Terimler testinden alındı)
  Widget _buildErolHocaTip(String explanation, bool isWide) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isWide ? 12 : 4),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 22 : 12,
        vertical: isWide ? 16 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentLight.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.accent, width: isWide ? 2 : 1.5),
        borderRadius: BorderRadius.circular(isWide ? 20 : AppSizes.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.school_rounded, color: AppColors.accentWarm, size: isWide ? 30 : 18),
          SizedBox(width: isWide ? 16 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Öğrenme Notu:',
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 18.5 : 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentWarm,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  explanation,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: isWide ? 18 : 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sonuç Ekranı (Mesleki Terimler testinden aynen alındı)
  Widget _buildResultScreen() {
    final isWide = MediaQuery.of(context).size.width >= 768;
    String message = 'Harika bir performans!';
    IconData icon = Icons.emoji_events_rounded;
    Color color = AppColors.accent;

    if (_correctAnswers <= widget.questions.length / 2) {
      message = 'Erol Hocan ile dersleri biraz daha tekrar etmelisin!';
      icon = Icons.menu_book_rounded;
      color = AppColors.primaryMid;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.1),
            AppColors.background,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isWide ? 1320 : double.infinity),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 36 : AppSizes.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(isWide ? 28 : AppSizes.xl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: isWide ? 100 : 80,
                      color: color,
                    ),
                  ),
                  SizedBox(height: isWide ? 28 : AppSizes.xxl),
                  Text(
                    'Test Tamamlandı!',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 36 : 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: isWide ? 12 : AppSizes.sm),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 20 : 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: isWide ? 28 : AppSizes.xl),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isWide ? 36 : 24, vertical: isWide ? 22 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildResultStat('${widget.questions.length}', 'Toplam Soru', isWide: isWide),
                        Container(width: 1, height: isWide ? 50 : 40, color: AppColors.divider),
                        _buildResultStat('$_correctAnswers', 'Doğru', valueColor: Colors.green, isWide: isWide),
                        Container(width: 1, height: isWide ? 50 : 40, color: AppColors.divider),
                        _buildResultStat('${widget.questions.length - _correctAnswers}', 'Yanlış', valueColor: Colors.red, isWide: isWide),
                      ],
                    ),
                  ),
                  SizedBox(height: isWide ? 24 : AppSizes.xl),
                  // Puan Göstergesi
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 24, vertical: isWide ? 16 : 12),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(isWide ? 16 : 12),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars_rounded, color: AppColors.accentWarm, size: isWide ? 30 : 24),
                        const SizedBox(width: 10),
                        Text(
                          '+${_correctAnswers * 10} Puan Kazandın',
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 22 : 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentWarm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: isWide ? 20 : 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                        ),
                      ),
                      child: Text(
                        'Kapat',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: isWide ? 20 : 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String value, String label, {Color? valueColor, bool isWide = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 24.0 : 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: isWide ? 32 : 24,
              fontWeight: FontWeight.w900,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isWide ? 15 : 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontSize: isWide ? 22 : 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, size: isWide ? 34 : 24),
          tooltip: 'Kapat',
          splashRadius: isWide ? 28 : 22,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isFinished ? _buildResultScreen() : _buildQuizContent(),
      ),
    );
  }
}
