class LearningUnit {
  final String title;
  final int lessonCount;
  final int quizCount;
  final String? podcastUrl;

  const LearningUnit({
    required this.title,
    this.lessonCount = 5,
    this.quizCount = 2,
    this.podcastUrl,
  });
}
