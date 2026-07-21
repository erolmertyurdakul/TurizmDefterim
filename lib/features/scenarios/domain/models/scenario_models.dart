class ScenarioOption {
  final String text;
  final String feedback;
  final String? nextStepId; // If null, this leads to the end of the scenario

  const ScenarioOption({
    required this.text,
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
  final String description;
  final String imageUrl;
  final Map<String, ScenarioStep> steps;

  const Scenario({
    required this.id,
    required this.title,
    required this.department,
    required this.description,
    required this.imageUrl,
    required this.steps,
  });
}

