import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/scenario_models.dart';

class ScenarioState {
  final Scenario? currentScenario;
  final ScenarioStep? currentStep;
  final List<ScenarioOption> selectedOptions;
  final String? lastOptionFeedback;
  final bool isFinished;

  const ScenarioState({
    this.currentScenario,
    this.currentStep,
    required this.selectedOptions,
    this.lastOptionFeedback,
    required this.isFinished,
  });

  ScenarioState copyWith({
    Scenario? currentScenario,
    ScenarioStep? currentStep,
    List<ScenarioOption>? selectedOptions,
    String? lastOptionFeedback,
    bool? isFinished,
  }) {
    return ScenarioState(
      currentScenario: currentScenario ?? this.currentScenario,
      currentStep: currentStep ?? this.currentStep,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      lastOptionFeedback: lastOptionFeedback ?? this.lastOptionFeedback,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  /// Oynanan yolu (path) belirlemek için seçilen seçeneklerin indekslerini döndürür.
  /// Her adımda Seçenek 1 = 0, Seçenek 2 = 1 olarak kaydedilmiştir.
  String get pathKey {
    // Seçilen seçeneklerin adım içindeki pozisyonlarını birleştirerek benzersiz
    // bir yol anahtarı oluşturur. Değerlendirme raporunu bu anahtara göre seç.
    return selectedOptions.map((o) => o.text.substring(0, 10)).join('|');
  }
}

class ScenarioNotifier extends StateNotifier<ScenarioState> {
  ScenarioNotifier()
      : super(const ScenarioState(
          selectedOptions: [],
          isFinished: false,
        ));

  void startScenario(Scenario scenario) {
    state = ScenarioState(
      currentScenario: scenario,
      currentStep: scenario.steps['step_1'],
      selectedOptions: [],
      lastOptionFeedback: null,
      isFinished: false,
    );
  }

  void selectOption(ScenarioOption option) {
    if (state.currentScenario == null) return;

    final nextOptions = [...state.selectedOptions, option];
    final isFinished = option.nextStepId == null;
    final nextStep = isFinished ? null : state.currentScenario!.steps[option.nextStepId];

    state = state.copyWith(
      selectedOptions: nextOptions,
      lastOptionFeedback: option.feedback,
      currentStep: nextStep,
      isFinished: isFinished,
    );
  }

  void reset() {
    state = const ScenarioState(
      selectedOptions: [],
      lastOptionFeedback: null,
      isFinished: false,
    );
  }
}

final scenarioProvider = StateNotifierProvider<ScenarioNotifier, ScenarioState>((ref) {
  return ScenarioNotifier();
});
