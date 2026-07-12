class DimensionScores {
  final int guestCentricity;      // -10 to +10
  final int financialDiscipline;  // -10 to +10
  final int riskManagement;       // -10 to +10
  final int professionalHonesty;  // -10 to +10

  const DimensionScores({
    required this.guestCentricity,
    required this.financialDiscipline,
    required this.riskManagement,
    required this.professionalHonesty,
  });

  const DimensionScores.zero()
      : guestCentricity = 0,
        financialDiscipline = 0,
        riskManagement = 0,
        professionalHonesty = 0;

  DimensionScores operator +(DimensionScores other) {
    return DimensionScores(
      guestCentricity: guestCentricity + other.guestCentricity,
      financialDiscipline: financialDiscipline + other.financialDiscipline,
      riskManagement: riskManagement + other.riskManagement,
      professionalHonesty: professionalHonesty + other.professionalHonesty,
    );
  }
}

class ScenarioOption {
  final String text;
  final int satisfactionEffect;
  final int budgetEffect;
  final int reputationEffect;
  final DimensionScores dimensionScores;
  final String feedback;
  final String? nextStepId; // If null, this leads to the end of the scenario

  const ScenarioOption({
    required this.text,
    required this.satisfactionEffect,
    required this.budgetEffect,
    required this.reputationEffect,
    required this.dimensionScores,
    required this.feedback,
    this.nextStepId,
  });
}

class ScenarioStep {
  final String id;
  final String title;
  final String story;
  final String imageUrl;
  final List<ScenarioOption> options;

  const ScenarioStep({
    required this.id,
    required this.title,
    required this.story,
    required this.imageUrl,
    required this.options,
  });
}

class Scenario {
  final String id;
  final String title;
  final String department; // "Ön Büro", "Kat Hizmetleri", "Yiyecek & İçecek"
  final String difficulty; // "Kolay", "Orta", "Zor"
  final String description;
  final String imageUrl;
  final Map<String, ScenarioStep> steps;

  const Scenario({
    required this.id,
    required this.title,
    required this.department,
    required this.difficulty,
    required this.description,
    required this.imageUrl,
    required this.steps,
  });
}
