import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/data/terminology_data.dart';
import '../../../../core/providers/points_provider.dart';

class BadgeProgress {
  final int cardsRead;
  final int quizzesCompleted;
  final int questionsSolved;
  final int podcastMinutesListened;
  final int wheelSpins;
  final int totalPoints;
  final int termsLearned;
  final int scenariosCompleted;
  final int receptionSimulationsCompleted;
  final int wordSearchCompleted;
  final int blitzQuizCompleted;
  final int tourGuideCompleted;
  final int perfectQuizzes;
  final int notesCreated;
  final Set<String> openedGrades;

  BadgeProgress({
    this.cardsRead = 0,
    this.quizzesCompleted = 0,
    this.questionsSolved = 0,
    this.podcastMinutesListened = 0,
    this.wheelSpins = 0,
    this.totalPoints = 0,
    this.termsLearned = 0,
    this.scenariosCompleted = 0,
    this.receptionSimulationsCompleted = 0,
    this.wordSearchCompleted = 0,
    this.blitzQuizCompleted = 0,
    this.tourGuideCompleted = 0,
    this.perfectQuizzes = 0,
    this.notesCreated = 0,
    this.openedGrades = const {},
  });

  BadgeProgress copyWith({
    int? cardsRead,
    int? quizzesCompleted,
    int? questionsSolved,
    int? podcastMinutesListened,
    int? wheelSpins,
    int? totalPoints,
    int? termsLearned,
    int? scenariosCompleted,
    int? receptionSimulationsCompleted,
    int? wordSearchCompleted,
    int? blitzQuizCompleted,
    int? tourGuideCompleted,
    int? perfectQuizzes,
    int? notesCreated,
    Set<String>? openedGrades,
  }) {
    return BadgeProgress(
      cardsRead: cardsRead ?? this.cardsRead,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      questionsSolved: questionsSolved ?? this.questionsSolved,
      podcastMinutesListened:
          podcastMinutesListened ?? this.podcastMinutesListened,
      wheelSpins: wheelSpins ?? this.wheelSpins,
      totalPoints: totalPoints ?? this.totalPoints,
      termsLearned: termsLearned ?? this.termsLearned,
      scenariosCompleted: scenariosCompleted ?? this.scenariosCompleted,
      receptionSimulationsCompleted:
          receptionSimulationsCompleted ?? this.receptionSimulationsCompleted,
      wordSearchCompleted: wordSearchCompleted ?? this.wordSearchCompleted,
      blitzQuizCompleted: blitzQuizCompleted ?? this.blitzQuizCompleted,
      tourGuideCompleted: tourGuideCompleted ?? this.tourGuideCompleted,
      perfectQuizzes: perfectQuizzes ?? this.perfectQuizzes,
      notesCreated: notesCreated ?? this.notesCreated,
      openedGrades: openedGrades ?? this.openedGrades,
    );
  }

  /// Her rozet için açılmış seviyeyi (0-5) hesaplar.
  int getBadgeLevel(int badgeId) {
    switch (badgeId) {
      case 1: // Kitap Kurdu: 5, 15, 40, 100, 200
        if (cardsRead >= 200) return 5;
        if (cardsRead >= 100) return 4;
        if (cardsRead >= 40) return 3;
        if (cardsRead >= 15) return 2;
        if (cardsRead >= 5) return 1;
        return 0;
      case 50: // Not Ustası (Ders Notu Ekleme): 10, 20, 50, 100, 200
        if (notesCreated >= 200) return 5;
        if (notesCreated >= 100) return 4;
        if (notesCreated >= 50) return 3;
        if (notesCreated >= 20) return 2;
        if (notesCreated >= 10) return 1;
        return 0;
      case 51: // Soru Bükücü: 10, 50, 200, 500, 1000
        if (questionsSolved >= 1000) return 5;
        if (questionsSolved >= 500) return 4;
        if (questionsSolved >= 200) return 3;
        if (questionsSolved >= 50) return 2;
        if (questionsSolved >= 10) return 1;
        return 0;
      case 52: // Turizm Frekansı: 10, 50, 200, 500, 1000 dakika
        if (podcastMinutesListened >= 1000) return 5;
        if (podcastMinutesListened >= 500) return 4;
        if (podcastMinutesListened >= 200) return 3;
        if (podcastMinutesListened >= 50) return 2;
        if (podcastMinutesListened >= 10) return 1;
        return 0;
      case 53: // Terim Çarkı Ustası: 10, 30, 80, 200, 500 çevirme
        if (wheelSpins >= 500) return 5;
        if (wheelSpins >= 200) return 4;
        if (wheelSpins >= 80) return 3;
        if (wheelSpins >= 30) return 2;
        if (wheelSpins >= 10) return 1;
        return 0;
      case 54: // 5 Yıldızlı Turizmci: 100, 500, 2000, 10000, 25000 puan
        if (totalPoints >= 25000) return 5;
        if (totalPoints >= 10000) return 4;
        if (totalPoints >= 2000) return 3;
        if (totalPoints >= 500) return 2;
        if (totalPoints >= 100) return 1;
        return 0;
      case 2: // Bilgi Avcısı: 2, 5, 15, 30, 50
        if (quizzesCompleted >= 50) return 5;
        if (quizzesCompleted >= 30) return 4;
        if (quizzesCompleted >= 15) return 3;
        if (quizzesCompleted >= 5) return 2;
        if (quizzesCompleted >= 2) return 1;
        return 0;
      case 3: // Terim Ustası: 5, 20, 50, 100, 200
        if (termsLearned >= 200) return 5;
        if (termsLearned >= 100) return 4;
        if (termsLearned >= 50) return 3;
        if (termsLearned >= 20) return 2;
        if (termsLearned >= 5) return 1;
        return 0;
      case 4: // Mükemmeliyetçi: 1, 3, 10, 20, 40
        if (perfectQuizzes >= 40) return 5;
        if (perfectQuizzes >= 20) return 4;
        if (perfectQuizzes >= 10) return 3;
        if (perfectQuizzes >= 3) return 2;
        if (perfectQuizzes >= 1) return 1;
        return 0;
      case 5: // Kelime Kaşifi: 1, 3, 7, 12, 20
        if (wordSearchCompleted >= 20) return 5;
        if (wordSearchCompleted >= 12) return 4;
        if (wordSearchCompleted >= 7) return 3;
        if (wordSearchCompleted >= 3) return 2;
        if (wordSearchCompleted >= 1) return 1;
        return 0;
      case 9: // Ön Büro Stajyeri (Resepsiyon): 1, 3, 7, 12, 20
        if (receptionSimulationsCompleted >= 20) return 5;
        if (receptionSimulationsCompleted >= 12) return 4;
        if (receptionSimulationsCompleted >= 7) return 3;
        if (receptionSimulationsCompleted >= 3) return 2;
        if (receptionSimulationsCompleted >= 1) return 1;
        return 0;
      case 22: // Sorun Çözücü (Senaryolar): 1, 3, 6, 10, 15
        if (scenariosCompleted >= 15) return 5;
        if (scenariosCompleted >= 10) return 4;
        if (scenariosCompleted >= 6) return 3;
        if (scenariosCompleted >= 3) return 2;
        if (scenariosCompleted >= 1) return 1;
        return 0;
      case 23: // Karar Verici (Blitz): 1, 3, 8, 15, 25
        if (blitzQuizCompleted >= 25) return 5;
        if (blitzQuizCompleted >= 15) return 4;
        if (blitzQuizCompleted >= 8) return 3;
        if (blitzQuizCompleted >= 3) return 2;
        if (blitzQuizCompleted >= 1) return 1;
        return 0;
      case 38: // İlk Adım
        if (cardsRead >= 5 && termsLearned >= 5 && quizzesCompleted >= 5 && receptionSimulationsCompleted >= 2 && scenariosCompleted >= 1) return 5;
        if (cardsRead >= 1 && termsLearned >= 1 && quizzesCompleted >= 1 && receptionSimulationsCompleted >= 1) return 4;
        if (quizzesCompleted >= 1) return 3;
        if (termsLearned >= 1) return 2;
        if (cardsRead >= 1) return 1;
        return 0;
      case 39: // Keşifçi: Sınıf açma
        if (openedGrades.length >= 4) return 5;
        if (openedGrades.length >= 4) return 4;
        if (openedGrades.length >= 3) return 3;
        if (openedGrades.length >= 2) return 2;
        if (openedGrades.length >= 1) return 1;
        return 0;
      case 40: // Altın Pasaport (Diğer tüm rozetlerin toplam seviyesi)
        int totalLevels = 0;
        for (final id in [1, 50, 51, 52, 53, 54, 2, 3, 4, 5, 9, 22, 23, 38, 39]) {
          totalLevels += getBadgeLevel(id);
        }
        if (totalLevels >= 45) return 5;
        if (totalLevels >= 35) return 4;
        if (totalLevels >= 22) return 3;
        if (totalLevels >= 12) return 2;
        if (totalLevels >= 5) return 1;
        return 0;
      default:
        return 0;
    }
  }
}

final badgeProgressProvider =
    StateNotifierProvider<BadgeProgressNotifier, BadgeProgress>((ref) {
  final notifier = BadgeProgressNotifier();
  final currentPoints = ref.watch(pointsProvider);
  notifier.syncTotalPoints(currentPoints);
  return notifier;
});

class BadgeProgressNotifier extends StateNotifier<BadgeProgress> {
  BadgeProgressNotifier() : super(BadgeProgress()) {
    _loadProgress();
  }

  static const _keyPrefix = 'badge_progress_';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    state = BadgeProgress(
      cardsRead: prefs.getInt('${_keyPrefix}cards_read') ?? 0,
      quizzesCompleted: prefs.getInt('${_keyPrefix}quizzes_completed') ?? 0,
      questionsSolved: prefs.getInt('${_keyPrefix}questions_solved') ?? 0,
      podcastMinutesListened: prefs.getInt('${_keyPrefix}podcast_minutes') ?? 0,
      wheelSpins: prefs.getInt('${_keyPrefix}wheel_spins') ?? 0,
      totalPoints: prefs.getInt('user_total_points') ?? 0,
      termsLearned: prefs.getInt('${_keyPrefix}terms_learned') ?? 0,
      scenariosCompleted: prefs.getInt('${_keyPrefix}scenarios_completed') ?? 0,
      receptionSimulationsCompleted:
          prefs.getInt('${_keyPrefix}reception_completed') ?? 0,
      wordSearchCompleted: prefs.getInt('${_keyPrefix}word_search_completed') ?? 0,
      blitzQuizCompleted: prefs.getInt('${_keyPrefix}blitz_quiz_completed') ?? 0,
      tourGuideCompleted: prefs.getInt('${_keyPrefix}tour_guide_completed') ?? 0,
      perfectQuizzes: prefs.getInt('${_keyPrefix}perfect_quizzes') ?? 0,
      notesCreated: prefs.getInt('${_keyPrefix}notes_created') ?? 0,
      openedGrades: (prefs.getStringList('${_keyPrefix}opened_grades') ?? []).toSet(),
    );
  }

  Future<void> _saveInt(String subKey, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_keyPrefix$subKey', value);
  }

  void syncTotalPoints(int points) {
    if (points != state.totalPoints) {
      state = state.copyWith(totalPoints: points);
    }
  }

  void incrementWheelSpins() {
    final newValue = state.wheelSpins + 1;
    state = state.copyWith(wheelSpins: newValue);
    _saveInt('wheel_spins', newValue);
  }

  void syncPodcastMinutes(int totalMinutes) {
    if (totalMinutes > state.podcastMinutesListened) {
      state = state.copyWith(podcastMinutesListened: totalMinutes);
    }
  }

  void incrementPodcastMinutes({int minutes = 1}) {
    if (minutes <= 0) return;
    final newValue = state.podcastMinutesListened + minutes;
    state = state.copyWith(podcastMinutesListened: newValue);
    _saveInt('podcast_minutes', newValue);
  }

  void incrementQuestionsSolved({int count = 1}) {
    if (count <= 0) return;
    final newValue = state.questionsSolved + count;
    state = state.copyWith(questionsSolved: newValue);
    _saveInt('questions_solved', newValue);
  }

  void incrementNotesCreated() {
    final newValue = state.notesCreated + 1;
    state = state.copyWith(notesCreated: newValue);
    _saveInt('notes_created', newValue);
  }

  void syncNotesCount(int count) {
    if (count > state.notesCreated) {
      state = state.copyWith(notesCreated: count);
      _saveInt('notes_created', count);
    }
  }

  void incrementCardsRead() {
    final newValue = state.cardsRead + 1;
    state = state.copyWith(cardsRead: newValue);
    _saveInt('cards_read', newValue);
  }

  void incrementQuizzesCompleted({bool isPerfect = false}) {
    final newQuizzes = state.quizzesCompleted + 1;
    final newPerfect = isPerfect ? state.perfectQuizzes + 1 : state.perfectQuizzes;
    state = state.copyWith(
      quizzesCompleted: newQuizzes,
      perfectQuizzes: newPerfect,
    );
    _saveInt('quizzes_completed', newQuizzes);
    if (isPerfect) {
      _saveInt('perfect_quizzes', newPerfect);
    }
  }

  void incrementTermsLearned() {
    final newValue = state.termsLearned + 1;
    state = state.copyWith(termsLearned: newValue);
    _saveInt('terms_learned', newValue);
  }

  void incrementScenariosCompleted() {
    final newValue = state.scenariosCompleted + 1;
    state = state.copyWith(scenariosCompleted: newValue);
    _saveInt('scenarios_completed', newValue);
  }

  void incrementReceptionCompleted() {
    final newValue = state.receptionSimulationsCompleted + 1;
    state = state.copyWith(receptionSimulationsCompleted: newValue);
    _saveInt('reception_completed', newValue);
  }

  void incrementWordSearchCompleted() {
    final newValue = state.wordSearchCompleted + 1;
    state = state.copyWith(wordSearchCompleted: newValue);
    _saveInt('word_search_completed', newValue);
  }

  void incrementBlitzQuizCompleted() {
    final newValue = state.blitzQuizCompleted + 1;
    state = state.copyWith(blitzQuizCompleted: newValue);
    _saveInt('blitz_quiz_completed', newValue);
  }

  void incrementTourGuideCompleted() {
    final newValue = state.tourGuideCompleted + 1;
    state = state.copyWith(tourGuideCompleted: newValue);
    _saveInt('tour_guide_completed', newValue);
  }

  void registerGradeOpened(String grade) {
    if (state.openedGrades.contains(grade)) return;
    final newGrades = Set<String>.from(state.openedGrades)..add(grade);
    state = state.copyWith(openedGrades: newGrades);
    
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('${_keyPrefix}opened_grades', newGrades.toList());
    });
  }
}
