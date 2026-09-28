import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'speech_web_helper_stub.dart' if (dart.library.js_interop) 'speech_web_helper_web.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;

  Function(String text, bool isFinal)? _currentOnResult;
  Function(String error)? _currentOnError;
  Function(String status)? _currentOnStatus;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      ensureWebSpeechRegistered();
      _isInitialized = await _speech.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          _currentOnStatus?.call(status);
        },
        onError: (errorNotification) {
          debugPrint('Speech error: ${errorNotification.errorMsg}');
          _currentOnError?.call(errorNotification.errorMsg);
        },
      );
      return _isInitialized;
    } catch (e) {
      debugPrint('Speech initialization error: $e');
      return false;
    }
  }

  Future<bool> startListening({
    required Function(String text, bool isFinal) onResult,
    Function(String error)? onError,
    Function(String status)? onStatusChange,
  }) async {
    _currentOnResult = onResult;
    _currentOnError = onError;
    _currentOnStatus = onStatusChange;

    final available = await initialize();
    if (!available) {
      onError?.call('Ses tanıma bu cihazda veya tarayıcıda kullanılamıyor. Lütfen mikrofon izinlerini kontrol edin.');
      return false;
    }

    try {
      final locales = await _speech.locales();
      String selectedLocaleId = kIsWeb ? 'tr-TR' : 'tr_TR';

      final hasTurkish = locales.any((l) =>
          l.localeId.toLowerCase().startsWith('tr'));
      if (hasTurkish) {
        final trLocale = locales.firstWhere(
          (l) => l.localeId.toLowerCase().startsWith('tr'),
        );
        selectedLocaleId = trLocale.localeId;
        if (kIsWeb) {
          selectedLocaleId = selectedLocaleId.replaceAll('_', '-');
        }
      }

      final options = stt.SpeechListenOptions(
        localeId: selectedLocaleId,
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        partialResults: !kIsWeb,
        autoPunctuation: true,
        enableHapticFeedback: !kIsWeb,
        listenFor: const Duration(minutes: 30),
        pauseFor: const Duration(seconds: 10),
      );

      await _speech.listen(
        onResult: (result) {
          _currentOnResult?.call(result.recognizedWords, result.finalResult);
        },
        listenOptions: options,
      );
      return true;
    } catch (e) {
      debugPrint('Speech listen error: $e');
      onError?.call('Ses algılama başlatılamadı: $e');
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (e) {
      debugPrint('Speech stop error: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
    } catch (e) {
      debugPrint('Speech cancel error: $e');
    }
  }
}
