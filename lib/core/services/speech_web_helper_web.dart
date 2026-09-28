import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text_platform_interface/speech_to_text_platform_interface.dart';

@JS('webkitSpeechRecognition')
extension type _WebkitSpeechRecognition._(web.SpeechRecognition _)
    implements web.SpeechRecognition {
  external factory _WebkitSpeechRecognition();
}

@JS('SpeechRecognition')
extension type _StandardSpeechRecognition._(web.SpeechRecognition _)
    implements web.SpeechRecognition {
  external factory _StandardSpeechRecognition();
}

/// Web platformu için optimize edilmiş, akıcı Web Speech Tanıma Sağlayıcısı.
///
/// Android deneyiminin aynısını sunar:
/// - Kullanıcı konuştuğu sürece kesintisiz (continuous) dinler.
/// - Chrome'un kümülatif sonuç dizisinden o oturumda söylenen tam metni çıkarır.
/// - Sürekli auto-restart döngüsüne girip arka planda durdurma/başlatma bildirim sesleri ÇIKARMAZ.
/// - Konuşma bittiğinde veya kullanıcı durdurduğunda oturumu temiz bir şekilde sonlandırır.
class TurizmWebSpeechPlatform extends SpeechToTextPlatform {
  web.SpeechRecognition? _webSpeech;
  bool _isListening = false;
  bool get isListening => _isListening;
  String _targetLocale = 'tr-TR';

  /// O anki dinleme seansında tanınan toplam metin
  String _currentSessionText = '';
  Timer? _silenceTimer;

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    if (!_isListening) return;
    _silenceTimer = Timer(const Duration(seconds: 10), () {
      debugPrint('WebSpeech: 10 saniye boyunca konuşulmadı, kayıt tamamlanıyor...');
      stop();
    });
  }

  void _cancelSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
  }

  static bool get supported =>
      web.window.hasProperty('SpeechRecognition'.toJS).toDart ||
      web.window.hasProperty('webkitSpeechRecognition'.toJS).toDart;

  web.SpeechRecognition? _createRecognition() {
    if (web.window.hasProperty('webkitSpeechRecognition'.toJS).toDart) {
      return _WebkitSpeechRecognition();
    } else if (web.window.hasProperty('SpeechRecognition'.toJS).toDart) {
      return _StandardSpeechRecognition();
    }
    return null;
  }

  @override
  Future<bool> hasPermission() async => supported;

  @override
  Future<bool> hasOnDeviceSupport({String? localeId}) async => false;

  @override
  Future<bool> initialize({
    debugLogging = false,
    List<SpeechConfigOption>? options,
  }) async {
    if (!supported) {
      final error = SpeechRecognitionError(
        'Bu tarayıcıda Web Ses Tanıma desteklenmiyor. Google Chrome veya Microsoft Edge kullanın.',
        true,
      );
      onError?.call(jsonEncode(error.toJson()));
      return false;
    }
    return true;
  }

  void _setupRecognition() {
    _webSpeech = _createRecognition();
    if (_webSpeech == null) return;
    _webSpeech!.onerror = _handleError.toJS;
    _webSpeech!.onstart = _handleStart.toJS;
    _webSpeech!.onspeechstart = _handleSpeechStart.toJS;
    _webSpeech!.onspeechend = _handleSpeechEnd.toJS;
    _webSpeech!.onend = _handleEnd.toJS;
    _webSpeech!.onresult = _handleResult.toJS;
    _webSpeech!.lang = _targetLocale;
    _webSpeech!.continuous = true;
    _webSpeech!.interimResults = false; // Web'de ara akış kapatıldı; susunca tek seferde toplu aktarılır
    _webSpeech!.maxAlternatives = 1;
  }

  @override
  Future<bool> listen({
    String? localeId,
    partialResults = true,
    onDevice = false,
    int listenMode = 0,
    sampleRate = 0,
    SpeechListenOptions? options,
  }) async {
    try {
      _currentSessionText = '';

      // BCP-47 dil kodu normalizasyonu (tr-TR)
      final rawLocale = options?.localeId ?? localeId;
      if (rawLocale != null && rawLocale.trim().isNotEmpty) {
        final normalized = rawLocale.trim().replaceAll('_', '-');
        _targetLocale = normalized.toLowerCase().startsWith('tr')
            ? 'tr-TR'
            : normalized;
      } else {
        _targetLocale = 'tr-TR';
      }

      // Varsa eski oturumu kapat
      if (_webSpeech != null) {
        try {
          _webSpeech!.abort();
        } catch (_) {}
      }

      _setupRecognition();
      if (_webSpeech == null) return false;

      _isListening = true;
      _webSpeech!.start();
      return true;
    } catch (e) {
      debugPrint('TurizmWebSpeechPlatform listen error: $e');
      _isListening = false;
      return false;
    }
  }

  @override
  Future<void> stop() async {
    _cancelSilenceTimer();
    _isListening = false;
    try {
      _webSpeech?.stop();
    } catch (e) {
      debugPrint('TurizmWebSpeechPlatform stop error: $e');
    }
  }

  @override
  Future<void> cancel() async {
    _cancelSilenceTimer();
    _isListening = false;
    try {
      _webSpeech?.abort();
    } catch (e) {
      debugPrint('TurizmWebSpeechPlatform cancel error: $e');
    }
    _currentSessionText = '';
    onStatus?.call('notListening');
    onStatus?.call('done');
  }

  @override
  Future<List<dynamic>> locales() async {
    return [
      'tr-TR:Türkçe (Türkiye)',
      'tr:Türkçe',
      'en-US:English (United States)',
    ];
  }

  // ─── Event Handlers ───

  void _handleStart(web.Event event) {
    _isListening = true;
    onStatus?.call('listening');
  }

  void _handleSpeechStart(web.Event event) {
    onStatus?.call('listening');
    // Kullanıcı konuşurken zamanlayıcıyı tamamen iptal et (asla konuşurken kesilmez)
    _cancelSilenceTimer();
  }

  void _handleSpeechEnd(web.Event event) {
    // Kullanıcı sustuğunda (konuşmayı bıraktığında) 3 saniyelik geri sayımı başlat
    _startSilenceTimer();
  }

  void _handleEnd(web.Event event) {
    _cancelSilenceTimer();
    _isListening = false;
    final text = _currentSessionText.trim();
    if (text.isNotEmpty) {
      final words = [SpeechRecognitionWords(text, null, 0.95)];
      final result = SpeechRecognitionResult.init(words, ResultType.finalResult);
      onTextRecognition?.call(jsonEncode(result.toJson()));
    }
    _currentSessionText = '';
    onStatus?.call('notListening');
    onStatus?.call('done');
  }

  void _handleError(web.SpeechRecognitionErrorEvent event) {
    final errorStr = event.error;
    debugPrint('Web speech error: $errorStr');

    if (errorStr == 'no-speech' || errorStr == 'aborted') return;

    bool isPermanent = false;
    String msg = errorStr;
    if (errorStr == 'not-allowed') {
      isPermanent = true;
      msg = 'Mikrofon izni engellendi. Tarayıcı adres çubuğundaki kilit simgesine tıklayıp mikrofona izin verin.';
    } else if (errorStr == 'audio-capture') {
      isPermanent = true;
      msg = 'Mikrofon algılanamadı. Mikrofonunuzun bağlı olduğundan emin olun.';
    } else if (errorStr == 'network') {
      msg = 'Ağ sorunu nedeniyle ses tanıma servisine ulaşılamadı.';
    }

    final error = SpeechRecognitionError(msg, isPermanent);
    onError?.call(jsonEncode(error.toJson()));
  }

  static String _normalizeForComparison(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^\w\sğüşıöçĞÜŞİÖÇ]'), '').trim();
  }

  static int _findWordOverlap(String s1, String s2) {
    final w1 = s1.trim().split(RegExp(r'\s+'));
    final w2 = s2.trim().split(RegExp(r'\s+'));
    if (w1.isEmpty || w2.isEmpty) return 0;
    final maxOverlap = w1.length < w2.length ? w1.length : w2.length;
    for (int k = maxOverlap; k > 0; k--) {
      bool match = true;
      for (int i = 0; i < k; i++) {
        if (w1[w1.length - k + i].toLowerCase() != w2[i].toLowerCase()) {
          match = false;
          break;
        }
      }
      if (match) return k;
    }
    return 0;
  }

  static bool _isExtensionOrRefinement(String last, String current) {
    final normLast = _normalizeForComparison(last);
    final normCurr = _normalizeForComparison(current);
    if (normCurr.isEmpty || normLast.isEmpty) return false;
    if (normCurr == normLast) return true;
    if (normCurr.startsWith(normLast)) return true;

    // Kelime kökü veya ekleme bazlı karşılaştırma
    final wLast = normLast.split(RegExp(r'\s+'));
    final wCurr = normCurr.split(RegExp(r'\s+'));
    if (wCurr.length >= wLast.length && wLast.isNotEmpty) {
      int matches = 0;
      for (int i = 0; i < wLast.length; i++) {
        if (wCurr[i] == wLast[i] ||
            wCurr[i].startsWith(wLast[i]) ||
            wLast[i].startsWith(wCurr[i])) {
          matches++;
        } else {
          break;
        }
      }
      if (matches >= wLast.length - 1 && matches > 0) {
        return true;
      }
    }
    return false;
  }

  /// Mobile Chrome (Android Web) ve Desktop Chrome arasındaki Web Speech API
  /// sonuç dizisi format farklarını uzlaştırarak tekrarsız akıcı metin üretir.
  static String collapseTranscripts(List<String> segments) {
    if (segments.isEmpty) return '';
    final clean = <String>[];

    for (final seg in segments) {
      final trimmed = seg.trim();
      if (trimmed.isEmpty) continue;
      if (clean.isEmpty) {
        clean.add(trimmed);
        continue;
      }

      final last = clean.last;
      final normLast = _normalizeForComparison(last);
      final normCurr = _normalizeForComparison(trimmed);
      if (normCurr.isEmpty) continue;

      if (normCurr == normLast) continue;

      if (_isExtensionOrRefinement(last, trimmed)) {
        clean[clean.length - 1] = trimmed;
        continue;
      }

      if (normLast.startsWith(normCurr)) continue;

      final overlap = _findWordOverlap(last, trimmed);
      if (overlap > 0) {
        final words = trimmed.split(RegExp(r'\s+'));
        final nonOverlap = words.skip(overlap).join(' ');
        if (nonOverlap.isNotEmpty) {
          clean[clean.length - 1] = '$last $nonOverlap';
        }
        continue;
      }

      clean.add(trimmed);
    }

    return clean.join(' ');
  }

  void _handleResult(web.SpeechRecognitionEvent event) {
    final results = event.results;
    if (results.length == 0) return;

    final rawSegments = <String>[];
    for (int i = 0; i < results.length; i++) {
      final res = results.item(i);
      if (res.length > 0) {
        final transcript = res.item(0).transcript.trim();
        if (transcript.isNotEmpty) {
          rawSegments.add(transcript);
        }
      }
    }

    final fullText = collapseTranscripts(rawSegments).trim();
    if (fullText.isEmpty) return;

    _startSilenceTimer();
    _currentSessionText = fullText;

    final words = [SpeechRecognitionWords(fullText, null, 0.95)];
    final speechResult = SpeechRecognitionResult.init(words, ResultType.partial);
    onTextRecognition?.call(jsonEncode(speechResult.toJson()));
  }
}

void ensureWebSpeechRegistered() {
  if (kIsWeb) {
    try {
      if (TurizmWebSpeechPlatform.supported) {
        SpeechToTextPlatform.instance = TurizmWebSpeechPlatform();
        debugPrint('SpeechService: TurizmWebSpeechPlatform registered.');
      } else {
        debugPrint('SpeechService: SpeechRecognition API not supported.');
      }
    } catch (e) {
      debugPrint('SpeechService: Web speech registration error: $e');
    }
  }
}
