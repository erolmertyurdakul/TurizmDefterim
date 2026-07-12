class Term {
  final String word;
  final String definition;
  final String example;
  final String category;
  final bool isEnglish;

  const Term({
    required this.word,
    required this.definition,
    required this.example,
    required this.category,
    this.isEnglish = true,
  });
}
