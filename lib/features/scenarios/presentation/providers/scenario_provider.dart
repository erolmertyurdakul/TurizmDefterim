import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/scenario_models.dart';

class ScenarioState {
  final Scenario? currentScenario;
  final ScenarioStep? currentStep;
  final int satisfaction; // 0 - 100
  final int budget;       // e.g., 500$ starting budget
  final int reputation;   // 0 - 100
  final DimensionScores dimensionScores;
  final List<ScenarioOption> selectedOptions;
  final String? lastOptionFeedback;
  final bool isFinished;

  const ScenarioState({
    this.currentScenario,
    this.currentStep,
    required this.satisfaction,
    required this.budget,
    required this.reputation,
    required this.dimensionScores,
    required this.selectedOptions,
    this.lastOptionFeedback,
    required this.isFinished,
  });

  ScenarioState copyWith({
    Scenario? currentScenario,
    ScenarioStep? currentStep,
    int? satisfaction,
    int? budget,
    int? reputation,
    DimensionScores? dimensionScores,
    List<ScenarioOption>? selectedOptions,
    String? lastOptionFeedback,
    bool? isFinished,
  }) {
    return ScenarioState(
      currentScenario: currentScenario ?? this.currentScenario,
      currentStep: currentStep ?? this.currentStep,
      satisfaction: satisfaction ?? this.satisfaction,
      budget: budget ?? this.budget,
      reputation: reputation ?? this.reputation,
      dimensionScores: dimensionScores ?? this.dimensionScores,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      lastOptionFeedback: lastOptionFeedback ?? this.lastOptionFeedback,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  // Helper method to compute final offline profiling persona
  String get professionalTitle {
    final ds = dimensionScores;
    
    // Evaluate based on key strengths
    if (ds.guestCentricity >= 15 && ds.financialDiscipline <= -5) {
      return 'Misafir Dostu Diplomat';
    } else if (ds.financialDiscipline >= 15 && ds.guestCentricity <= -5) {
      return 'Mali Muhafazakar Yönetici';
    } else if (ds.riskManagement <= -15) {
      return 'Risk Sever Kumarbaz';
    } else if (ds.professionalHonesty >= 15 && ds.riskManagement >= 5) {
      return 'Şeffaf ve Etik Kriz Lideri';
    } else if (ds.guestCentricity >= 8 && ds.financialDiscipline >= 5) {
      return 'Dengeli Operasyon Stratejisti';
    }
    return 'Gelişmekte Olan Turizm Profesyoneli';
  }

  // Calculate Badge (Altın, Gümüş, Bronz/Stajyer)
  String get badgeName {
    final score = (satisfaction + (budget ~/ 5) + reputation) ~/ 3;
    if (score >= 85) return 'Altın Hizmet Nişanı';
    if (score >= 60) return 'Gümüş Kriz Yöneticisi';
    return 'Stajyer Rozeti';
  }

  String get badgeAsset {
    final score = (satisfaction + (budget ~/ 5) + reputation) ~/ 3;
    if (score >= 85) return '🏆';
    if (score >= 60) return '🥈';
    return '🎖️';
  }
}

class ScenarioNotifier extends StateNotifier<ScenarioState> {
  ScenarioNotifier()
      : super(const ScenarioState(
          satisfaction: 70,
          budget: 500,
          reputation: 75,
          dimensionScores: DimensionScores.zero(),
          selectedOptions: [],
          isFinished: false,
        ));

  void startScenario(Scenario scenario) {
    state = ScenarioState(
      currentScenario: scenario,
      currentStep: scenario.steps['step_1'],
      satisfaction: 70,
      budget: 500,
      reputation: 75,
      dimensionScores: const DimensionScores.zero(),
      selectedOptions: [],
      lastOptionFeedback: null,
      isFinished: false,
    );
  }

  void selectOption(ScenarioOption option) {
    if (state.currentScenario == null) return;

    final nextSatisfaction = (state.satisfaction + option.satisfactionEffect).clamp(0, 100).toInt();
    final nextBudget = (state.budget + option.budgetEffect).clamp(0, 1000).toInt();
    final nextReputation = (state.reputation + option.reputationEffect).clamp(0, 100).toInt();
    final nextDimensions = state.dimensionScores + option.dimensionScores;
    final nextOptions = [...state.selectedOptions, option];

    final isFinished = option.nextStepId == null;
    final nextStep = isFinished ? null : state.currentScenario!.steps[option.nextStepId];

    state = state.copyWith(
      satisfaction: nextSatisfaction,
      budget: nextBudget,
      reputation: nextReputation,
      dimensionScores: nextDimensions,
      selectedOptions: nextOptions,
      lastOptionFeedback: option.feedback,
      currentStep: nextStep,
      isFinished: isFinished,
    );
  }

  void reset() {
    state = const ScenarioState(
      satisfaction: 70,
      budget: 500,
      reputation: 75,
      dimensionScores: DimensionScores.zero(),
      selectedOptions: [],
      lastOptionFeedback: null,
      isFinished: false,
    );
  }
}

final scenarioProvider = StateNotifierProvider<ScenarioNotifier, ScenarioState>((ref) {
  return ScenarioNotifier();
});
