import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mini oyunlarda global ses açma/kapama durumunu yöneten provider.
/// Podcast, ders notları ve diğer eğitim içeriklerini ETKİLEMEZ.
final soundSettingsProvider =
    StateNotifierProvider<SoundSettingsNotifier, bool>((ref) {
  return SoundSettingsNotifier();
});

class SoundSettingsNotifier extends StateNotifier<bool> {
  // state = true → sesler açık, false → sesler kapalı
  SoundSettingsNotifier() : super(true) {
    _loadPreference();
  }

  static const _key = 'mini_game_sound_enabled';

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? true;
  }

  Future<void> _savePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, state);
  }

  /// Ses açma/kapama toggle.
  void toggleMute() {
    state = !state;
    _savePreference();
  }

  /// Sesin açık olup olmadığını döner.
  bool get isSoundEnabled => state;
}
