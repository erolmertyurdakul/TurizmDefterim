import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/reception_simulator_data.dart';

// ══════════════════════════════════════════
//  OYUN STATE
// ══════════════════════════════════════════

class ReceptionSimulatorState {
  final GamePhase phase;
  final int currentLevel;
  final GuestProfile? currentGuest;
  final List<GuestProfile> levelGuests;
  final double guestPatienceRemaining;
  final double guestPatienceTotal;
  final RoomType? selectedRoom;
  final BoardType? selectedBoard;
  final Set<SpecialRequest> selectedRequests;
  final List<SpecialRequest> requestOptions;
  final int score;
  final int totalRevenue;
  final int reputation;
  final int comboCount;
  final double comboMultiplier;
  final int guestsServed;
  final int guestsCorrect;
  final int maxCombo;
  final Set<Achievement> earnedAchievements;
  final Map<PowerUpType, int> availablePowerUps;
  final PowerUpType? activePowerUp;
  final int powerUpRemainingSeconds;
  final int guestsRemainingInLevel;
  final int totalGuestsInLevel;
  final String? feedbackMessage;
  final FeedbackType? feedbackType;
  final List<String> newUnlocks;
  final String levelTitle;
  final int vipSuccessCount;

  const ReceptionSimulatorState({
    this.phase = GamePhase.intro,
    this.currentLevel = 0,
    this.currentGuest,
    this.levelGuests = const [],
    this.guestPatienceRemaining = 0,
    this.guestPatienceTotal = 1,
    this.selectedRoom,
    this.selectedBoard,
    this.selectedRequests = const {},
    this.requestOptions = const [],
    this.score = 0,
    this.totalRevenue = 0,
    this.reputation = 100,
    this.comboCount = 0,
    this.comboMultiplier = 1.0,
    this.guestsServed = 0,
    this.guestsCorrect = 0,
    this.maxCombo = 0,
    this.earnedAchievements = const {},
    this.availablePowerUps = const {
      PowerUpType.zamanDondur: 1,
      PowerUpType.ipucu: 1,
      PowerUpType.pasGec: 1,
    },
    this.activePowerUp,
    this.powerUpRemainingSeconds = 0,
    this.guestsRemainingInLevel = 0,
    this.totalGuestsInLevel = 0,
    this.feedbackMessage,
    this.feedbackType,
    this.newUnlocks = const [],
    this.levelTitle = 'Stajyer',
    this.vipSuccessCount = 0,
  });

  ReceptionSimulatorState copyWith({
    GamePhase? phase,
    int? currentLevel,
    GuestProfile? currentGuest,
    bool clearGuest = false,
    List<GuestProfile>? levelGuests,
    double? guestPatienceRemaining,
    double? guestPatienceTotal,
    RoomType? selectedRoom,
    bool clearSelectedRoom = false,
    BoardType? selectedBoard,
    bool clearSelectedBoard = false,
    Set<SpecialRequest>? selectedRequests,
    List<SpecialRequest>? requestOptions,
    int? score,
    int? totalRevenue,
    int? reputation,
    int? comboCount,
    double? comboMultiplier,
    int? guestsServed,
    int? guestsCorrect,
    int? maxCombo,
    Set<Achievement>? earnedAchievements,
    Map<PowerUpType, int>? availablePowerUps,
    PowerUpType? activePowerUp,
    bool clearActivePowerUp = false,
    int? powerUpRemainingSeconds,
    int? guestsRemainingInLevel,
    int? totalGuestsInLevel,
    String? feedbackMessage,
    bool clearFeedback = false,
    FeedbackType? feedbackType,
    List<String>? newUnlocks,
    String? levelTitle,
    int? vipSuccessCount,
  }) {
    return ReceptionSimulatorState(
      phase: phase ?? this.phase,
      currentLevel: currentLevel ?? this.currentLevel,
      currentGuest: clearGuest ? null : (currentGuest ?? this.currentGuest),
      levelGuests: levelGuests ?? this.levelGuests,
      guestPatienceRemaining: guestPatienceRemaining ?? this.guestPatienceRemaining,
      guestPatienceTotal: guestPatienceTotal ?? this.guestPatienceTotal,
      selectedRoom: clearSelectedRoom ? null : (selectedRoom ?? this.selectedRoom),
      selectedBoard: clearSelectedBoard ? null : (selectedBoard ?? this.selectedBoard),
      selectedRequests: selectedRequests ?? this.selectedRequests,
      requestOptions: requestOptions ?? this.requestOptions,
      score: score ?? this.score,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      reputation: reputation ?? this.reputation,
      comboCount: comboCount ?? this.comboCount,
      comboMultiplier: comboMultiplier ?? this.comboMultiplier,
      guestsServed: guestsServed ?? this.guestsServed,
      guestsCorrect: guestsCorrect ?? this.guestsCorrect,
      maxCombo: maxCombo ?? this.maxCombo,
      earnedAchievements: earnedAchievements ?? this.earnedAchievements,
      availablePowerUps: availablePowerUps ?? this.availablePowerUps,
      activePowerUp: clearActivePowerUp ? null : (activePowerUp ?? this.activePowerUp),
      powerUpRemainingSeconds: powerUpRemainingSeconds ?? this.powerUpRemainingSeconds,
      guestsRemainingInLevel: guestsRemainingInLevel ?? this.guestsRemainingInLevel,
      totalGuestsInLevel: totalGuestsInLevel ?? this.totalGuestsInLevel,
      feedbackMessage: clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      feedbackType: clearFeedback ? null : (feedbackType ?? this.feedbackType),
      newUnlocks: newUnlocks ?? this.newUnlocks,
      levelTitle: levelTitle ?? this.levelTitle,
      vipSuccessCount: vipSuccessCount ?? this.vipSuccessCount,
    );
  }
}

// ══════════════════════════════════════════
//  OYUN NOTİFİER
// ══════════════════════════════════════════

class ReceptionSimulatorNotifier extends StateNotifier<ReceptionSimulatorState> {
  Timer? _patienceTimer;
  final Random _random = Random();
  bool _disposed = false;
  // Track if the patience timer is paused when user leaves the screen
  bool _isPaused = false;

  /// Cancel the patience timer (e.g., when the player leaves the screen).
  /// Does NOT modify state — safe to call from widget lifecycle methods.
  void pauseGameTimer() {
    _patienceTimer?.cancel();
    _isPaused = true;
  }

  /// Resume the patience timer after user chooses to continue
  void resumeGameTimer() {
    if (!_isPaused) return;
    _isPaused = false;
    _startPatienceTimer();
  }

  ReceptionSimulatorNotifier() : super(const ReceptionSimulatorState());

  // ── Oyun Akışı ──

  void showTutorial() {
    state = state.copyWith(phase: GamePhase.tutorial);
  }

  void startGame() {
    state = const ReceptionSimulatorState();
    _startLevel(0);
  }

  void _startLevel(int level) {
    _patienceTimer?.cancel();
    final config = LevelConfig.levels[level];

    // Seviye için benzersiz misafir listesini önceden oluştur
    final uniqueGuestsForLevel = ReceptionSimulatorData.generateUniqueGuestsForLevel(
      level,
      config.totalGuests,
      _random,
    );

    state = state.copyWith(
      phase: GamePhase.playing,
      currentLevel: level,
      guestsRemainingInLevel: config.totalGuests,
      totalGuestsInLevel: config.totalGuests,
      levelTitle: config.title,
      clearSelectedRoom: true,
      clearSelectedBoard: true,
      selectedRequests: const {},
      requestOptions: const [],
      clearFeedback: true,
      clearActivePowerUp: true,
      powerUpRemainingSeconds: 0,
      availablePowerUps: level == 0 ? const {
        PowerUpType.zamanDondur: 1,
        PowerUpType.ipucu: 1,
        PowerUpType.pasGec: 1,
      } : state.availablePowerUps,
      levelGuests: uniqueGuestsForLevel,
    );

    _generateAndSetNextGuest();
    _startPatienceTimer();
  }

  void continueAfterLevelUp() {
    _startLevel(state.currentLevel + 1);
  }

  void resetGame() {
    _patienceTimer?.cancel();
    _isPaused = false; // Ensure timer is not considered paused after reset
    state = const ReceptionSimulatorState();
  }

  /// Restart the current level as if the player just entered it.
  /// Resets the timer, generates fresh guests, and begins playing.
  void resumeCurrentLevel() {
    _patienceTimer?.cancel();
    _isPaused = false;
    // _startLevel already sets phase=playing, generates guests, and starts timer
    _startLevel(state.currentLevel);
  }

  /// Legacy method kept for compatibility – simply forwards to resumeCurrentLevel.
  void resumeGameAndContinue() {
    resumeCurrentLevel();
  }

  /// Restart the current level from its beginning, preserving overall progress.
  void restartCurrentLevel() {
    // Use the current level index to start it anew.
    _startLevel(state.currentLevel);
  }




  // ── Misafir Yönetimi ──

  void _generateAndSetNextGuest() {
    if (state.levelGuests.isEmpty) return;

    // Önceden oluşturulmuş benzersiz misafir listesinden sıradaki misafiri çek
    final guest = state.levelGuests.first;
    final remainingGuests = state.levelGuests.sublist(1);

    final config = LevelConfig.levels[state.currentLevel];
    final patienceTotal = config.basePatience * guest.type.patienceMultiplier;

    final requestOptions = guest.specialRequests.isNotEmpty
        ? ReceptionSimulatorData.getRequestOptions(guest.specialRequests, _random)
        : <SpecialRequest>[];

    state = state.copyWith(
      currentGuest: guest,
      levelGuests: remainingGuests,
      guestPatienceRemaining: patienceTotal,
      guestPatienceTotal: patienceTotal,
      clearSelectedRoom: true,
      clearSelectedBoard: true,
      selectedRequests: const {},
      requestOptions: requestOptions,
      clearFeedback: true,
    );
  }

  void _handleGuestLeft() {
    _patienceTimer?.cancel();

    final newReputation = (state.reputation - 20).clamp(0, 100);
    final guestType = state.currentGuest?.type;

    state = state.copyWith(
      score: state.score - 100,
      reputation: newReputation,
      comboCount: 0,
      comboMultiplier: 1.0,
      guestsServed: state.guestsServed + 1,
      guestsRemainingInLevel: state.guestsRemainingInLevel - 1,
      feedbackMessage: '😡 Misafir bekledi! -20 İtibar\n💡 Misafirleri bekletmemek çok önemlidir.',
      feedbackType: FeedbackType.guestLeft,
    );

    if (newReputation <= 0) {
      _calculateAchievements();
      state = state.copyWith(
        phase: GamePhase.gameOver,
        feedbackMessage: '🏨 Otel itibarı sıfırlandı! Otel kapandı.',
        feedbackType: FeedbackType.guestLeft,
      );
      return;
    }

    // Otomatik geçiş kaldırıldı. Kullanıcı butona basarak geçiş yapacak.
  }

  // ── Seçim İşlemleri ──

  void selectRoom(RoomType room) {
    if (state.phase != GamePhase.playing || state.feedbackMessage != null) return;
    state = state.copyWith(
      selectedRoom: state.selectedRoom == room ? null : room,
      clearSelectedRoom: state.selectedRoom == room,
    );
  }

  void selectBoard(BoardType board) {
    if (state.phase != GamePhase.playing || state.feedbackMessage != null) return;
    state = state.copyWith(
      selectedBoard: state.selectedBoard == board ? null : board,
      clearSelectedBoard: state.selectedBoard == board,
    );
  }

  void toggleRequest(SpecialRequest request) {
    if (state.phase != GamePhase.playing || state.feedbackMessage != null) return;
    final updated = Set<SpecialRequest>.from(state.selectedRequests);
    if (updated.contains(request)) {
      updated.remove(request);
    } else {
      updated.add(request);
    }
    state = state.copyWith(selectedRequests: updated);
  }

  // ── Check-in Değerlendirme ──

  void submitCheckIn() {
    if (state.phase != GamePhase.playing) return;
    if (state.currentGuest == null) return;
    if (state.selectedRoom == null || state.selectedBoard == null) return;
    if (state.feedbackMessage != null) return;

    _patienceTimer?.cancel();

    final guest = state.currentGuest!;
    final roomCorrect = state.selectedRoom == guest.correctRoom;
    final boardCorrect = state.selectedBoard == guest.correctBoard;

    // Özel istek kontrolü
    final guestRequests = Set<SpecialRequest>.from(guest.specialRequests);
    final playerRequests = state.selectedRequests;
    final requestsMatch = guestRequests.length == playerRequests.length &&
        guestRequests.containsAll(playerRequests);

    int pointsEarned = 0;
    int reputationChange = 0;
    FeedbackType feedbackType;
    String feedbackMessage;
    int newCombo = state.comboCount;
    int newVipSuccess = state.vipSuccessCount;

    final isFullMatch = roomCorrect && boardCorrect && requestsMatch;
    final isPartialMatch = !isFullMatch && (roomCorrect || boardCorrect || playerRequests.isNotEmpty);

    if (isFullMatch) {
      pointsEarned = 100;
      feedbackType = FeedbackType.correct;
      
      // Özel istek bonusları
      for (final req in guest.specialRequests) {
        pointsEarned += req.bonusPoints;
      }

      // Kombo ve çarpan uygula
      pointsEarned = (pointsEarned * state.comboMultiplier * guest.type.pointMultiplier).round();
      reputationChange = 2;
      newCombo = state.comboCount + 1;

      if (guest.type == GuestType.vip) newVipSuccess++;

      final tip = ReceptionSimulatorData.getRandomTip(_random);
      feedbackMessage = '✅ Mükemmel Eşleşme! +$pointsEarned\n$tip';

    } else if (isPartialMatch) {
      pointsEarned = 30;
      feedbackType = FeedbackType.partial;
      reputationChange = -5;
      newCombo = 0;
      if (guest.type == GuestType.vip) newVipSuccess = 0;

      final msgLines = <String>['⚠️ Kısmi Doğru! (+30 XP)'];

      // Oda bildirimi
      if (roomCorrect) {
        msgLines.add('✅ Oda Doğru: ${guest.correctRoom.displayName}');
      } else {
        msgLines.add('❌ Doğru Oda: ${guest.correctRoom.displayName}');
        msgLines.add('💡 ${guest.correctRoom.tip}');
      }

      // Pansiyon bildirimi
      if (boardCorrect) {
        msgLines.add('✅ Pansiyon Doğru: ${guest.correctBoard.displayName}');
      } else {
        msgLines.add('❌ Doğru Pansiyon: ${guest.correctBoard.displayName}');
        msgLines.add('💡 ${guest.correctBoard.tip}');
      }

      // Özel istekler bildirimi
      if (guest.specialRequests.isNotEmpty) {
        if (requestsMatch) {
          msgLines.add('✅ Özel İstekler Doğru!');
        } else {
          final reqNames = guest.specialRequests.map((r) => '${r.emoji} ${r.displayName}').join(', ');
          msgLines.add('❌ Doğru Özel İstekler: $reqNames');
        }
      }

      feedbackMessage = msgLines.join('\n');

    } else {
      pointsEarned = -50;
      feedbackType = FeedbackType.wrong;
      reputationChange = -10;
      newCombo = 0;
      if (guest.type == GuestType.vip) {
        reputationChange = -25;
        newVipSuccess = 0;
      }
      if (guest.type == GuestType.ozelGereksinim) {
        reputationChange = -20;
      }

      final msgLines = <String>[
        '❌ Yanlış Eşleşme! (-50 Puan)',
        '🏠 Doğru Oda: ${guest.correctRoom.displayName}',
        '💡 ${guest.correctRoom.tip}',
        '☕ Doğru Pansiyon: ${guest.correctBoard.displayName}',
        '💡 ${guest.correctBoard.tip}',
      ];

      if (guest.specialRequests.isNotEmpty) {
        final reqNames = guest.specialRequests.map((r) => '${r.emoji} ${r.displayName}').join(', ');
        msgLines.add('📋 Doğru Özel İstekler: $reqNames');
      }

      feedbackMessage = msgLines.join('\n');
    }

    // Combo çarpanı güncelle
    final newMultiplier = ReceptionSimulatorData.getComboMultiplier(newCombo);

    // Gelir hesapla
    final revenue = (roomCorrect && boardCorrect)
        ? guest.correctRoom.price + guest.correctBoard.price
        : 0;

    final newReputation = (state.reputation + reputationChange).clamp(0, 100);
    final newGuestsCorrect = (roomCorrect && boardCorrect) ? state.guestsCorrect + 1 : state.guestsCorrect;
    final newMaxCombo = newCombo > state.maxCombo ? newCombo : state.maxCombo;

    // Güç-up güncelle (Her 5 doğru serisinde Pas Geç jokeri kazanılır)
    Map<PowerUpType, int> updatedPowerUps = Map.from(state.availablePowerUps);
    if (newCombo > 0 && newCombo % 5 == 0) {
      updatedPowerUps[PowerUpType.pasGec] = (updatedPowerUps[PowerUpType.pasGec] ?? 0) + 1;
      feedbackMessage += '\n🎁 Pas Geçme jokeri kazandın!';
    }

    state = state.copyWith(
      score: state.score + pointsEarned,
      totalRevenue: state.totalRevenue + revenue,
      reputation: newReputation,
      comboCount: newCombo,
      comboMultiplier: newMultiplier,
      guestsServed: state.guestsServed + 1,
      guestsCorrect: newGuestsCorrect,
      maxCombo: newMaxCombo,
      guestsRemainingInLevel: state.guestsRemainingInLevel - 1,
      feedbackMessage: feedbackMessage,
      feedbackType: feedbackType,
      availablePowerUps: updatedPowerUps,
      clearActivePowerUp: true,
      clearSelectedRoom: true,
      clearSelectedBoard: true,
      selectedRequests: const {},
      vipSuccessCount: newVipSuccess,
    );

    // İtibar sıfır kontrolü
    if (newReputation <= 0) {
      _calculateAchievements();
      state = state.copyWith(phase: GamePhase.gameOver);
      return;
    }

    // Otomatik geçiş kaldırıldı. Kullanıcı butona basarak geçiş yapacak.
  }

  void _prepareNextOrLevelUp() {
    if (state.guestsRemainingInLevel <= 0) {
      if (state.currentLevel < 7) {
        final newUnlocks = ReceptionSimulatorData.getNewUnlocks(state.currentLevel + 1);
        state = state.copyWith(
          phase: GamePhase.levelUp,
          newUnlocks: newUnlocks,
        );
      } else {
        _calculateAchievements();
        state = state.copyWith(phase: GamePhase.gameOver);
      }
    } else {
      _generateAndSetNextGuest();
      _startPatienceTimer();
    }
  }

  // ── Güç-Up Sistemi ──

  void activatePowerUp(PowerUpType type) {
    if (state.phase != GamePhase.playing) return;
    if (state.feedbackMessage != null) return;
    final count = state.availablePowerUps[type] ?? 0;
    if (count <= 0) return;

    final newPowerUps = Map<PowerUpType, int>.from(state.availablePowerUps);
    newPowerUps[type] = count - 1;

    switch (type) {
      case PowerUpType.zamanDondur:
        if (state.activePowerUp != null) return;
        state = state.copyWith(
          activePowerUp: PowerUpType.zamanDondur,
          powerUpRemainingSeconds: 5,
          availablePowerUps: newPowerUps,
        );
        break;
      case PowerUpType.ipucu:
        if (state.currentGuest != null) {
          state = state.copyWith(
            selectedRoom: state.currentGuest!.correctRoom,
            availablePowerUps: newPowerUps,
          );
        }
        break;
      case PowerUpType.pasGec:
        _patienceTimer?.cancel();
        state = state.copyWith(
          availablePowerUps: newPowerUps,
          feedbackMessage: '⏭️ Misafir Pas Geçildi!',
          feedbackType: FeedbackType.correct,
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (_disposed) return;
          state = state.copyWith(clearFeedback: true);
          _prepareNextOrLevelUp();
        });
        break;
    }
  }

  // ── Zamanlayıcı ──

  void _startPatienceTimer() {
    _patienceTimer?.cancel();
    _patienceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _tick() {
    if (state.phase != GamePhase.playing) return;
    if (state.currentGuest == null) return;
    if (state.feedbackMessage != null) return;

    // Zaman dondur güç-up aktifse
    if (state.activePowerUp == PowerUpType.zamanDondur) {
      if (state.powerUpRemainingSeconds > 0) {
        state = state.copyWith(
          powerUpRemainingSeconds: state.powerUpRemainingSeconds - 1,
        );
      } else {
        state = state.copyWith(clearActivePowerUp: true);
      }
      return;
    }

    final newPatience = state.guestPatienceRemaining - 1.0;
    if (newPatience <= 0) {
      _handleGuestLeft();
    } else {
      state = state.copyWith(guestPatienceRemaining: newPatience);
    }
  }

  // ── Başarı Hesaplama ──

  void _calculateAchievements() {
    final achievements = <Achievement>{};

    if (state.guestsCorrect >= 1) achievements.add(Achievement.ilkCheckIn);
    if (state.maxCombo >= 10) achievements.add(Achievement.comboUstasi);
    if (state.guestsServed > 0 && state.guestsCorrect == state.guestsServed) {
      achievements.add(Achievement.mukemmeliyetci);
    }
    if (state.totalRevenue >= 30000) achievements.add(Achievement.gelirKrali);
    if (state.currentLevel >= 7) achievements.add(Achievement.genelMudur);
    if (state.vipSuccessCount >= 3) achievements.add(Achievement.vipHizmeti);

    state = state.copyWith(earnedAchievements: achievements);
  }

  void moveToNextGuest() {
    state = state.copyWith(clearFeedback: true);
    _prepareNextOrLevelUp();
  }

  // ── Temizlik ──

  @override
  void dispose() {
    _disposed = true;
    _patienceTimer?.cancel();
    super.dispose();
  }
}

// ══════════════════════════════════════════
//  RİVERPOD PROVİDER
// ══════════════════════════════════════════

final receptionSimulatorProvider =
    StateNotifierProvider<ReceptionSimulatorNotifier, ReceptionSimulatorState>(
  (ref) => ReceptionSimulatorNotifier(),
);
