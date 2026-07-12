import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının toplam puanını yöneten provider
final pointsProvider = StateNotifierProvider<PointsNotifier, int>((ref) {
  return PointsNotifier();
});

class PointsNotifier extends StateNotifier<int> {
  PointsNotifier() : super(0) {
    _loadPoints();
  }

  static const _key = 'user_total_points';

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 0;
  }

  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, state);
  }

  /// Puan ekle (ders notu okurken dakikalık, quiz doğru cevap vb.)
  void addPoints(int amount) {
    state = state + amount;
    _savePoints();
  }

  /// Quiz tamamlandığında: her doğru cevap = 10 puan
  void addQuizPoints(int correctAnswers) {
    state = state + (correctAnswers * 10);
    _savePoints();
  }

  /// Ders notu okurken: dakika başına 2 puan
  void addReadingPoints() {
    state = state + 2;
    _savePoints();
  }
}
