import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../../core/providers/points_provider.dart';

class BlitzQuizGameState {
  final bool isPlaying;
  final bool isGameOver;
  final int score;
  final int timeLeft;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final int comboCount;
  final int maxCombo;
  final int skipsRemaining;
  final Map<String, int> correctByCourse;
  final Map<String, int> wrongByCourse;

  const BlitzQuizGameState({
    this.isPlaying = false,
    this.isGameOver = false,
    this.score = 0,
    this.timeLeft = 60,
    this.questions = const [],
    this.currentIndex = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    this.comboCount = 0,
    this.maxCombo = 0,
    this.skipsRemaining = 1,
    this.correctByCourse = const {},
    this.wrongByCourse = const {},
  });

  BlitzQuizGameState copyWith({
    bool? isPlaying,
    bool? isGameOver,
    int? score,
    int? timeLeft,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? correctCount,
    int? wrongCount,
    int? selectedOptionIndex,
    bool clearSelectedOption = false,
    bool? isAnswered,
    int? comboCount,
    int? maxCombo,
    int? skipsRemaining,
    Map<String, int>? correctByCourse,
    Map<String, int>? wrongByCourse,
  }) {
    return BlitzQuizGameState(
      isPlaying: isPlaying ?? this.isPlaying,
      isGameOver: isGameOver ?? this.isGameOver,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      selectedOptionIndex: clearSelectedOption ? null : (selectedOptionIndex ?? this.selectedOptionIndex),
      isAnswered: isAnswered ?? this.isAnswered,
      comboCount: comboCount ?? this.comboCount,
      maxCombo: maxCombo ?? this.maxCombo,
      skipsRemaining: skipsRemaining ?? this.skipsRemaining,
      correctByCourse: correctByCourse ?? this.correctByCourse,
      wrongByCourse: wrongByCourse ?? this.wrongByCourse,
    );
  }
}

class BlitzQuizGameNotifier extends StateNotifier<BlitzQuizGameState> {
  final Ref _ref;
  Timer? _timer;
  final Random _random = Random();
  bool _disposed = false;

  BlitzQuizGameNotifier(this._ref) : super(const BlitzQuizGameState());

  void startGame() {
    _timer?.cancel();

    // 4 Sınıfa/Derse ait tüm soruları karıştırarak havuz oluştur
    final shuffledQuestions = List<QuizQuestion>.from(allQuizQuestions)..shuffle(_random);

    state = BlitzQuizGameState(
      isPlaying: true,
      isGameOver: false,
      score: 0,
      timeLeft: 60,
      questions: shuffledQuestions,
      currentIndex: 0,
      correctCount: 0,
      wrongCount: 0,
      selectedOptionIndex: null,
      isAnswered: false,
      comboCount: 0,
      maxCombo: 0,
      skipsRemaining: 1,
      correctByCourse: const {},
      wrongByCourse: const {},
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      _tick();
    });
  }

  void _tick() {
    if (!state.isPlaying || state.isGameOver) return;

    final newTimeLeft = state.timeLeft - 1;
    if (newTimeLeft <= 0) {
      state = state.copyWith(timeLeft: 0);
      endGame();
    } else {
      state = state.copyWith(timeLeft: newTimeLeft);
    }
  }

  void selectOption(int index) {
    if (!state.isPlaying || state.isGameOver || state.isAnswered) return;

    final currentQuestion = state.questions[state.currentIndex];
    final courseId = currentQuestion.courseId;
    final isCorrect = index == currentQuestion.correctOptionIndex;

    int newScore = state.score;
    int newCorrectCount = state.correctCount;
    int newWrongCount = state.wrongCount;
    int newCombo = state.comboCount;
    int newTimeLeft = state.timeLeft;

    final updatedCorrectByCourse = Map<String, int>.from(state.correctByCourse);
    final updatedWrongByCourse = Map<String, int>.from(state.wrongByCourse);

    if (isCorrect) {
      newCorrectCount++;
      newCombo++;
      updatedCorrectByCourse[courseId] = (updatedCorrectByCourse[courseId] ?? 0) + 1;
      
      // Combo çarpanı
      double multiplier = 1.0;
      if (newCombo >= 10) {
        multiplier = 2.5;
      } else if (newCombo >= 5) {
        multiplier = 2.0;
      } else if (newCombo >= 3) {
        multiplier = 1.5;
      }
      
      newScore += (10 * multiplier).round();

      // Combo Ödülü: Her 5 doğru combox'ta +3 saniye ek süre ver
      if (newCombo > 0 && newCombo % 5 == 0) {
        newTimeLeft += 3;
      }
    } else {
      newWrongCount++;
      newCombo = 0;
      newScore = max(0, newScore - 5); // Yanlış cevapta 5 puan düşür
      updatedWrongByCourse[courseId] = (updatedWrongByCourse[courseId] ?? 0) + 1;
    }

    final newMaxCombo = max(state.maxCombo, newCombo);

    state = state.copyWith(
      selectedOptionIndex: index,
      isAnswered: true,
      score: newScore,
      correctCount: newCorrectCount,
      wrongCount: newWrongCount,
      comboCount: newCombo,
      maxCombo: newMaxCombo,
      timeLeft: newTimeLeft,
      correctByCourse: updatedCorrectByCourse,
      wrongByCourse: updatedWrongByCourse,
    );

    // 600 ms sonra otomatik olarak sonraki soruya geç
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_disposed || !state.isPlaying || state.isGameOver) return;
      _nextQuestion();
    });
  }

  void useSkipJoker() {
    if (!state.isPlaying || state.isGameOver || state.isAnswered || state.skipsRemaining <= 0) return;

    state = state.copyWith(
      skipsRemaining: state.skipsRemaining - 1,
      clearSelectedOption: true,
      isAnswered: false,
      currentIndex: state.currentIndex >= state.questions.length - 1 ? 0 : state.currentIndex + 1,
    );

    if (state.currentIndex >= state.questions.length - 1) {
      final newPool = List<QuizQuestion>.from(allQuizQuestions)..shuffle(_random);
      state = state.copyWith(
        questions: newPool,
        currentIndex: 0,
      );
    }
  }

  void _nextQuestion() {
    if (state.currentIndex >= state.questions.length - 1) {
      final newPool = List<QuizQuestion>.from(allQuizQuestions)..shuffle(_random);
      state = state.copyWith(
        questions: newPool,
        currentIndex: 0,
        clearSelectedOption: true,
        isAnswered: false,
      );
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelectedOption: true,
        isAnswered: false,
      );
    }
  }

  void endGame() {
    _timer?.cancel();
    if (!state.isPlaying) return;

    state = state.copyWith(isPlaying: false, isGameOver: true);

    // Toplam kazanılan skoru genel puan sistemine ekle
    if (state.score > 0) {
      _ref.read(pointsProvider.notifier).addPoints(state.score);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}

final blitzQuizProvider = StateNotifierProvider<BlitzQuizGameNotifier, BlitzQuizGameState>((ref) {
  return BlitzQuizGameNotifier(ref);
});
