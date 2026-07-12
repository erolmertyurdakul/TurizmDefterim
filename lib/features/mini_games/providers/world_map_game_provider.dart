import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/world_map_data.dart';

class WorldMapGameState {
  final List<MapDestination> remainingQuestions;
  final MapDestination? currentQuestion;
  final int score;
  final int streak;
  final double comboMultiplier;
  final int timeLeft;
  final bool isGameOver;
  final int lifeline5050Count;
  final int lifelineHintCount;
  final int lifelineTimeCount;
  final String? currentHint;
  final List<MapDestination> activeOptions; // 4 options displayed on the map

  const WorldMapGameState({
    this.remainingQuestions = const [],
    this.currentQuestion,
    this.score = 0,
    this.streak = 0,
    this.comboMultiplier = 1.0,
    this.timeLeft = 60,
    this.isGameOver = false,
    this.lifeline5050Count = 1,
    this.lifelineHintCount = 1,
    this.lifelineTimeCount = 1,
    this.currentHint,
    this.activeOptions = const [],
  });

  WorldMapGameState copyWith({
    List<MapDestination>? remainingQuestions,
    MapDestination? currentQuestion,
    int? score,
    int? streak,
    double? comboMultiplier,
    int? timeLeft,
    bool? isGameOver,
    int? lifeline5050Count,
    int? lifelineHintCount,
    int? lifelineTimeCount,
    String? currentHint,
    List<MapDestination>? activeOptions,
  }) {
    return WorldMapGameState(
      remainingQuestions: remainingQuestions ?? this.remainingQuestions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      comboMultiplier: comboMultiplier ?? this.comboMultiplier,
      timeLeft: timeLeft ?? this.timeLeft,
      isGameOver: isGameOver ?? this.isGameOver,
      lifeline5050Count: lifeline5050Count ?? this.lifeline5050Count,
      lifelineHintCount: lifelineHintCount ?? this.lifelineHintCount,
      lifelineTimeCount: lifelineTimeCount ?? this.lifelineTimeCount,
      currentHint: currentHint, // Deliberately overriding to allow nulling
      activeOptions: activeOptions ?? this.activeOptions,
    );
  }
}

class WorldMapGameNotifier extends StateNotifier<WorldMapGameState> {
  Timer? _timer;
  final Random _random = Random();

  WorldMapGameNotifier() : super(const WorldMapGameState()) {
    startGame();
  }

  void startGame() {
    _timer?.cancel();
    final questions = List<MapDestination>.from(worldMapDestinations)..shuffle();
    
    state = const WorldMapGameState(
      score: 0,
      streak: 0,
      comboMultiplier: 1.0,
      timeLeft: 60,
      isGameOver: false,
      lifeline5050Count: 1,
      lifelineHintCount: 1,
      lifelineTimeCount: 1,
    ).copyWith(remainingQuestions: questions);

    _nextQuestion();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0 && !state.isGameOver) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else if (state.timeLeft <= 0) {
        endGame();
      }
    });
  }

  void _nextQuestion() {
    if (state.remainingQuestions.isEmpty) {
      endGame();
      return;
    }

    final questions = List<MapDestination>.from(state.remainingQuestions);
    final currentQ = questions.removeAt(0);

    // Generate 3 wrong options
    List<MapDestination> allOthers = List.from(worldMapDestinations)..removeWhere((d) => d.id == currentQ.id);
    allOthers.shuffle();
    
    final options = [currentQ];
    options.addAll(allOthers.take(3));
    options.shuffle();

    state = state.copyWith(
      remainingQuestions: questions,
      currentQuestion: currentQ,
      activeOptions: options,
      currentHint: null, // Clear hint on new question
    );
  }

  void answerQuestion(MapDestination selected) {
    if (state.isGameOver) return;

    if (selected.id == state.currentQuestion?.id) {
      // Correct!
      final newStreak = state.streak + 1;
      final newCombo = min(2.5, 1.0 + (newStreak * 0.1)); // Max 2.5x
      
      // Speed bonus based on time left vs max? No, just base score + combo
      final pointsEarned = (100 * newCombo).round();

      state = state.copyWith(
        score: state.score + pointsEarned,
        streak: newStreak,
        comboMultiplier: newCombo,
      );
    } else {
      // Wrong!
      state = state.copyWith(
        streak: 0,
        comboMultiplier: 1.0,
        // Optional penalty
      );
    }

    _nextQuestion();
  }

  void use5050() {
    if (state.lifeline5050Count > 0 && state.currentQuestion != null) {
      final options = List<MapDestination>.from(state.activeOptions);
      final wrongOptions = options.where((o) => o.id != state.currentQuestion!.id).toList();
      wrongOptions.shuffle();
      
      // Remove 2 wrong options
      options.remove(wrongOptions[0]);
      options.remove(wrongOptions[1]);

      state = state.copyWith(
        lifeline5050Count: state.lifeline5050Count - 1,
        activeOptions: options,
      );
    }
  }

  void useHint() {
    if (state.lifelineHintCount > 0 && state.currentQuestion != null) {
      state = state.copyWith(
        lifelineHintCount: state.lifelineHintCount - 1,
        currentHint: state.currentQuestion!.hint,
      );
    }
  }

  void useExtraTime() {
    if (state.lifelineTimeCount > 0) {
      state = state.copyWith(
        lifelineTimeCount: state.lifelineTimeCount - 1,
        timeLeft: state.timeLeft + 15,
      );
    }
  }

  void endGame() {
    _timer?.cancel();
    state = state.copyWith(isGameOver: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final worldMapGameProvider = StateNotifierProvider<WorldMapGameNotifier, WorldMapGameState>((ref) {
  return WorldMapGameNotifier();
});
