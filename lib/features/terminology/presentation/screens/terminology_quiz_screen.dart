import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../data/models/term_model.dart';
import '../../providers/terminology_provider.dart';
import '../../../badges/providers/badge_provider.dart';
import '../../../../core/providers/points_provider.dart';

class TerminologyQuizScreen extends ConsumerStatefulWidget {
  const TerminologyQuizScreen({super.key});

  @override
  ConsumerState<TerminologyQuizScreen> createState() => _TerminologyQuizScreenState();
}

class _TerminologyQuizScreenState extends ConsumerState<TerminologyQuizScreen> {
  late final List<_Question> _questions;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _score = 0;
  bool _quizCompleted = false;
  final AudioPlayer _sfxPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _prepareQuestions();
    _playQuizIntro();
  }

  @override
  void dispose() {
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

  void _prepareQuestions() {
    final allTerms = ref.read(terminologyProvider);
    final random = Random();
    final List<Term> shuffledTerms = List.from(allTerms)..shuffle(random);
    final List<Term> quizTerms = shuffledTerms.take(5).toList();

    _questions = quizTerms.map((correctTerm) {
      // Doğru terim dışındakileri karıştırıp 3 yanlış şık seçelim
      final wrongOptions = allTerms
          .where((t) => t.word != correctTerm.word)
          .map((t) => t.definition)
          .toList()
        ..shuffle(random);

      final List<String> options = [
        correctTerm.definition,
        wrongOptions[0],
        wrongOptions[1],
        wrongOptions[2],
      ]..shuffle(random);

      return _Question(
        term: correctTerm,
        options: options,
        correctAnswerIndex: options.indexOf(correctTerm.definition),
      );
    }).toList();
  }

  void _onAnswerSelected(int index) {
    if (_isAnswered) return;

    final isCorrect = index == _questions[_currentQuestionIndex].correctAnswerIndex;
    _playSFX(isCorrect);

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        ref.read(badgeProgressProvider.notifier).incrementTermsLearned();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      // Increment quizzes completed for badge progress
      final isPerfect = _score == _questions.length;
      ref.read(badgeProgressProvider.notifier).incrementQuizzesCompleted(isPerfect: isPerfect);
      ref.read(pointsProvider.notifier).addQuizPoints(_score);

      setState(() {
        _quizCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesleki Terim Testi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.md),
              // İlerleme göstergesi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soru ${_currentQuestionIndex + 1} / ${_questions.length}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryMid,
                    ),
                  ),
                  Text(
                    'Doğru: $_score',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xs),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: AppColors.surfaceVariant,
                color: AppColors.secondary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 8),

              // Soru Kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.oceanGradient,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primarySeed.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        question.term.category.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Hangi açıklama aşağıdaki terimi tanımlar?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '"${question.term.word}"',
                      style: GoogleFonts.outfit(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Şıklar Listesi
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final optionText = question.options[index];
                    return _buildOptionTile(index, optionText, question);
                  },
                ),
              ),

              // Erol Hoca İpucu Kutusu (Yanlış Cevap Seçildiğinde)
              if (_isAnswered && _selectedAnswerIndex != question.correctAnswerIndex)
                _buildErolHocaTip(question.term.example),

              const SizedBox(height: 6),

              // İleri Butonu
              if (_isAnswered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMid,
                    ),
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? 'Sonuçları Gör 🏆'
                          : 'Sonraki Soru',
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

  // ══════════════════════════════════════════
  //  ŞIK TASARIMLARI
  // ══════════════════════════════════════════
  Widget _buildOptionTile(int index, String text, _Question question) {
    Color tileColor = Colors.white;
    Color borderCol = Colors.transparent;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (_isAnswered) {
      if (index == question.correctAnswerIndex) {
        tileColor = Colors.green.shade50;
        borderCol = Colors.green.shade400;
        textColor = Colors.green.shade900;
        trailingIcon = Icons.check_circle_rounded;
      } else if (index == _selectedAnswerIndex) {
        tileColor = Colors.red.shade50;
        borderCol = Colors.red.shade400;
        textColor = Colors.red.shade900;
        trailingIcon = Icons.cancel_rounded;
      } else {
        tileColor = Colors.white.withValues(alpha: 0.5);
      }
    } else {
      if (_selectedAnswerIndex == index) {
        borderCol = AppColors.primaryMid;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: borderCol,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primarySeed.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onAnswerSelected(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isAnswered ? borderCol.withValues(alpha: 0.5) : Colors.grey.shade400,
                        width: 1.5,
                      ),
                      color: _isAnswered ? borderCol.withValues(alpha: 0.1) : Colors.grey.shade100,
                    ),
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: _isAnswered ? textColor : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(trailingIcon, color: borderCol),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  EROL HOCANIN İPUCU
  // ══════════════════════════════════════════
  Widget _buildErolHocaTip(String example) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentLight.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.accent, width: 1.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: AppColors.accentWarm, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Erol Hocanızdan İpucu:',
                  style: GoogleFonts.outfit(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentWarm,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Bu kelime cümle içinde tam olarak şöyle kullanılır:\n"$example"',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  SONUÇ EKRANI
  // ══════════════════════════════════════════
  Widget _buildResultScreen() {
    String message = 'Harika bir performans!';
    IconData icon = Icons.emoji_events_rounded;
    Color color = AppColors.accent;

    if (_score <= 2) {
      message = 'Erol Hocan ile terimleri biraz daha çalışmalısın!';
      icon = Icons.menu_book_rounded;
      color = AppColors.primaryMid;
    }

    return Scaffold(
      body: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(AppSizes.xl),
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
                    size: 80,
                    color: color,
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                Text(
                  'Test Tamamlandı!',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildResultStat('${_questions.length}', 'Toplam Soru'),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      _buildResultStat('$_score', 'Doğru', valueColor: Colors.green),
                      Container(width: 1, height: 40, color: AppColors.divider),
                      _buildResultStat('${_questions.length - _score}', 'Yanlış', valueColor: Colors.red),
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
                    ),
                    child: const Text('Kapat'),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String value, String label, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Question {
  final Term term;
  final List<String> options;
  final int correctAnswerIndex;

  const _Question({
    required this.term,
    required this.options,
    required this.correctAnswerIndex,
  });
}
