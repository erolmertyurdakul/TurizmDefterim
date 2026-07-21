import 'dart:async';
import 'dart:io';
import 'js_stub.dart' if (dart.library.js) 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class PodcastService extends ChangeNotifier {
  // Singleton instance
  static final PodcastService _instance = PodcastService._internal();
  factory PodcastService() => _instance;

  AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  // Stream subscriptions to track state
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _sequenceStateSubscription;
  StreamSubscription? _processingStateSubscription;
  StreamSubscription? _positionSubscription;

  // Stream monitoring watchdog for auto-recovery
  Timer? _watchdogTimer;
  DateTime _lastPositionTime = DateTime.now();
  Duration _lastPosition = Duration.zero;

  // Current playing podcast details
  String? _currentUrl;
  String? get currentUrl => _currentUrl;

  String? _currentTitle;
  String? get currentTitle => _currentTitle;

  String? _currentId;
  String? _currentAlbum;
  String? get currentAlbum => _currentAlbum;

  bool _isBuffering = false;
  bool get isBuffering => _isBuffering;

  bool _isNotesScreenActive = false;
  bool get isNotesScreenActive => _isNotesScreenActive;
  set isNotesScreenActive(bool value) {
    if (_isNotesScreenActive != value) {
      _isNotesScreenActive = value;
      notifyListeners();
    }
  }

  bool _isMainShellVisible = false;
  bool get isMainShellVisible => _isMainShellVisible;
  set isMainShellVisible(bool value) {
    if (_isMainShellVisible != value) {
      _isMainShellVisible = value;
      notifyListeners();
    }
  }

  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed.clamp(0.5, 2.0);
    await _player.setSpeed(_playbackSpeed);
    notifyListeners();
  }

  PodcastService._internal() {
    _attachPlayerListeners(_player);
  }

  void _attachPlayerListeners(AudioPlayer player) {
    _playerStateSubscription?.cancel();
    _sequenceStateSubscription?.cancel();
    _processingStateSubscription?.cancel();
    _positionSubscription?.cancel();

    _playerStateSubscription = player.playerStateStream.listen((state) {
      notifyListeners();
    });

    _sequenceStateSubscription = player.sequenceStateStream.listen((state) {
      notifyListeners();
    });

    _processingStateSubscription = player.processingStateStream.listen((processing) {
      final wasBuffering = _isBuffering;

      if (processing == ProcessingState.buffering || processing == ProcessingState.loading) {
        _isBuffering = true;
      } else if (processing == ProcessingState.ready || processing == ProcessingState.idle) {
        _isBuffering = false;
      }

      if (wasBuffering != _isBuffering) {
        notifyListeners();
      }
    });

    // Zaman takibi: Stream'in donup donmadığını anlamak için positionStream dinlenir
    _lastPosition = Duration.zero;
    _lastPositionTime = DateTime.now();

    _positionSubscription = player.positionStream.listen((pos) {
      // Konaklama İşletmeciliği 3. Öğrenme Birimi podcast'indeki 10:57 - 11:02 arasını otomatik atla (5 saniye)
      if (_currentUrl == "https://anchor.fm/s/114a64400/podcast/play/122579689/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fstaging%2F2026-6-8%2Fb244ca28-e2da-8d0d-21d6-3b8fec5a9421.mp3") {
        const cutStart = Duration(minutes: 10, seconds: 57);
        const cutEnd = Duration(minutes: 11, seconds: 2);
        if (pos >= cutStart && pos < cutEnd) {
          player.seek(cutEnd);
          return;
        }
      }

      if (pos != _lastPosition) {
        _lastPosition = pos;
        _lastPositionTime = DateTime.now(); // Pozisyon ilerledikçe zamanı güncelle
      }
      notifyListeners();
    });

    // Akıllı Watchdog: Stream donmasını yakalar ve otomatik kurtarma sağlar.
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      final processingState = player.processingState;
      final isBuffering = processingState == ProcessingState.buffering || 
                          processingState == ProcessingState.loading;

      if (player.playing && _currentUrl != null && !isBuffering) {
        final now = DateTime.now();
        
        // Web'de periyodik setVolume çağrıları tarayıcı ses kanalını anlık kesebildiği için
        // bu işlemi sadece web dışı platformlarda çalıştırıyoruz.
        if (!kIsWeb && now.second % 8 == 0) {
          try {
            await player.setVolume(player.volume);
          } catch (_) {}
        }

        final idleDuration = now.difference(_lastPositionTime);

        // Donma algılama toleransını yavaş internet bağlantıları için 4 saniyeden 12 saniyeye çıkarıyoruz.
        if (idleDuration.inSeconds >= 12) {
          if (kDebugMode) {
            print("PodcastService: Stream freeze detected! Initiating automatic recovery...");
          }

          final currentPos = player.position;
          final recoverPos = currentPos > const Duration(seconds: 2)
              ? currentPos - const Duration(milliseconds: 1000)
              : Duration.zero;

          try {
            await player.seek(recoverPos);
            if (!player.playing) {
              await player.play();
            }
            _lastPositionTime = DateTime.now();
          } catch (e) {
            if (kDebugMode) {
              print("PodcastService: Recovery seek failed. Refreshing source: $e");
            }
            await _refreshSourceOnly();
          }
        }
      }
    });
  }

  /// 8 dinleme barajına ulaşıldığında ses önbelleğini temizler
  Future<void> cleanCacheIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listenCount = prefs.getInt('podcast_listen_count') ?? 0;
      
      if (kDebugMode) {
        print("PodcastService: Current cache listen count: $listenCount");
      }

      if (listenCount >= 8) {
        if (kDebugMode) {
          print("PodcastService: 8-listen threshold reached! Starting cache eviction...");
        }
        
        // 1. Mobil Platform Temizliği (Temporary Directory temizlenir)
        if (!kIsWeb) {
          final tempDir = await getTemporaryDirectory();
          if (tempDir.existsSync()) {
            // Klasörün içeriğini asenkron silerek UI'ı asla dondurmuyoruz
            await tempDir.delete(recursive: true);
            if (kDebugMode) {
              print("PodcastService: Mobile temporary directory cache cleared successfully.");
            }
          }
        } 
        // 2. Web Platform Temizliği (Tarayıcı Cache'leri temizlenir)
        else {
          try {
            // JS Cache API ile tarayıcıdaki tüm ses cache verilerini temizliyoruz
            js.context.callMethod('eval', ["""
              if ('caches' in window) {
                caches.keys().then(names => {
                  for (let name of names) {
                    caches.delete(name);
                  }
                });
              }
            """]);
            if (kDebugMode) {
              print("PodcastService: Web Browser Cache cleared successfully.");
            }
          } catch (e) {
            if (kDebugMode) {
              print("PodcastService: Web Browser Cache clear failed: $e");
            }
          }
        }

        // Sayacı sıfırla
        await prefs.setInt('podcast_listen_count', 0);
      }
    } catch (e) {
      if (kDebugMode) {
        print("PodcastService: cleanCacheIfNeeded failed: $e");
      }
    }
  }

  /// Oynat tuşuna her basıldığında dinleme sayacını artırır
  Future<void> _incrementListenCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('podcast_listen_count') ?? 0;
      await prefs.setInt('podcast_listen_count', currentCount + 1);
      if (kDebugMode) {
        print("PodcastService: Listen count incremented to ${currentCount + 1}");
      }
    } catch (_) {}
  }

  /// Oynatıcıyı dispose etmeden sadece ses kaynağını pürüzsüzce tazeleyen kurtarma metodu
  Future<void> _refreshSourceOnly() async {
    if (_currentUrl == null) return;
    try {
      final position = _player.position;
      final speed = _playbackSpeed;

      final audioSource = AudioSource.uri(
        Uri.parse(_currentUrl!),
        tag: MediaItem(
          id: _currentId ?? _currentUrl!,
          album: _currentAlbum ?? '',
          title: _currentTitle ?? '',
          artUri: null,
        ),
      );

      await _player.setAudioSource(audioSource);
      await _player.seek(position);
      if (speed != 1.0) {
        await _player.setSpeed(speed);
      }
      await _player.play();
      _lastPositionTime = DateTime.now();
    } catch (e) {
      if (kDebugMode) {
        print("PodcastService: Refresh source failed: $e");
      }
    }
  }

  // Play podcast from URL
  Future<void> play(String url, {required String id, required String title, required String album}) async {
    try {
      if (!kIsWeb) {
        try {
          if (await Permission.notification.isDenied) {
            await Permission.notification.request();
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error requesting notification permission: $e");
          }
        }
      }

      if (_currentUrl == url) {
        if (!_player.playing) {
          await _player.play();
        }
        return;
      }

      // Her yeni podcast çalındığında dinleme sayacını artırıyoruz
      await _incrementListenCount();

      _currentUrl = url;
      _currentTitle = title;
      _currentId = id;
      _currentAlbum = album;

      await _player.stop();

      if (!kIsWeb) {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration.speech());
      } else {
        await _player.setWebCrossOrigin(null);
      }

      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: id,
          album: album,
          title: title,
          artUri: null,
        ),
      );

      await _player.setAudioSource(audioSource);
      
      if (_playbackSpeed != 1.0) {
        await _player.setSpeed(_playbackSpeed);
      }
      await _player.play();
      _lastPositionTime = DateTime.now();
    } catch (e) {
      if (kDebugMode) {
        print("Error playing podcast: $e");
      }
    }
  }

  // Pause
  Future<void> pause() async {
    await _player.pause();
  }

  // Resume
  Future<void> resume() async {
    if (_currentUrl != null) {
      await _player.play();
      _lastPositionTime = DateTime.now();
    }
  }

  // Stop
  Future<void> stop() async {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    await _player.stop();
    _currentUrl = null;
    _currentTitle = null;
    _currentId = null;
    _currentAlbum = null;
    _isBuffering = false;
  }

  @override
  void dispose() {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _playerStateSubscription?.cancel();
    _sequenceStateSubscription?.cancel();
    _processingStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }
}
