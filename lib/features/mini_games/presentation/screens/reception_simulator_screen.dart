import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/data/reception_simulator_data.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../providers/reception_simulator_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import 'reception_simulator_tutorial.dart';
import '../../../badges/providers/badge_provider.dart';

/// Premium Resepsiyon Simülatörü Ekranı
/// Ön büro personeli yetiştirmek için tasarlanmış eğitici simülasyon.
class ReceptionSimulatorScreen extends ConsumerStatefulWidget {
  const ReceptionSimulatorScreen({super.key});

  @override
  ConsumerState<ReceptionSimulatorScreen> createState() =>
      _ReceptionSimulatorScreenState();
}

class _ReceptionSimulatorScreenState
    extends ConsumerState<ReceptionSimulatorScreen>
    with TickerProviderStateMixin {
  // ── Animasyonlar ──
  late AnimationController _guestController;
  late Animation<Offset> _guestSlideIn;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackOpacity;
  late AnimationController _pulseController;

  // When true, show the "resume" landing screen instead of the game UI.
  // This is set in initState when the game was already in progress.
  bool _isResuming = false;

  // ── Ses Yönetimi ──
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isBgmPlaying = false;

  @override
  void initState() {
    super.initState();

    // Check if the game was already in progress (user returned after leaving)
    final currentState = ref.read(receptionSimulatorProvider);
    if (currentState.phase == GamePhase.playing) {
      _isResuming = true;
      // Cancel any running timer immediately
      ref.read(receptionSimulatorProvider.notifier).pauseGameTimer();
    }

    _guestController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _guestSlideIn = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _guestController, curve: Curves.easeOutCubic));

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _feedbackOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Lobide çalan rahatlatıcı otel caz/ambiyans müziğini başlat
    _startBGMMusic();
  }

  @override
  void dispose() {
    // Cancel timer safely — pauseGameTimer does NOT modify provider state
    ref.read(receptionSimulatorProvider.notifier).pauseGameTimer();
    _guestController.dispose();
    _shakeController.dispose();
    _feedbackController.dispose();
    _pulseController.dispose();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  // ── Ses Oynatma Yardımcı Metotları ──
  bool get _isMuted => !ref.read(soundSettingsProvider);

  Future<void> _startBGMMusic() async {
    if (_isBgmPlaying) return;
    _isBgmPlaying = true;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(UrlSource('https://freepd.com/music/Lobby%20Time.mp3'));
      await _bgmPlayer.setVolume(_isMuted ? 0.0 : 0.18);
    } catch (e) {
      debugPrint("Error starting Reception BGM: $e");
    }
  }

  Future<void> _playSFX(String url) async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.stop();
      Source source;
      if (url.contains('2019') || url.contains('2018')) {
        source = BytesSource(SfxSynthesizer.getCorrectAnswer());
      } else if (url.contains('911') || url.contains('1435')) {
        source = BytesSource(SfxSynthesizer.getCorrectAnswer());
      } else if (url.contains('2565') || url.contains('950')) {
        source = BytesSource(SfxSynthesizer.getError());
      } else {
        source = UrlSource(url);
      }
      await _sfxPlayer.play(source);
    } catch (e) {
      debugPrint("Error playing Reception SFX: $e");
    }
  }

  IconData _getRoomIcon(RoomType type) {
    switch (type) {
      case RoomType.standart:
        return Icons.king_bed_outlined;
      case RoomType.kose:
        return Icons.border_outer_outlined;
      case RoomType.executive:
        return Icons.business_center_outlined;
      case RoomType.aile:
        return Icons.family_restroom_outlined;
      case RoomType.ozelGereksinim:
        return Icons.accessible_forward_outlined;
      case RoomType.baglantili:
        return Icons.sensor_door_outlined;
      case RoomType.bitisik:
        return Icons.meeting_room_outlined;
      case RoomType.suite:
        return Icons.home_work_outlined;
      case RoomType.kralDairesi:
        return Icons.auto_awesome;
    }
  }

  IconData _getBoardIcon(BoardType type) {
    switch (type) {
      case BoardType.sadeceOda:
        return Icons.no_food_outlined;
      case BoardType.odaKahvalti:
        return Icons.coffee_outlined;
      case BoardType.yarimPansiyon:
        return Icons.restaurant_outlined;
      case BoardType.tamPansiyon:
        return Icons.dining_outlined;
      case BoardType.herSeyDahil:
        return Icons.all_inclusive_outlined;
      case BoardType.ultraHerSeyDahil:
        return Icons.workspace_premium_outlined;
    }
  }

  IconData _getSpecialRequestIcon(SpecialRequest type) {
    switch (type) {
      case SpecialRequest.denizManzarasi:
        return Icons.water_outlined;
      case SpecialRequest.yuksekKat:
        return Icons.corporate_fare_outlined;
      case SpecialRequest.sessizOda:
        return Icons.volume_off_outlined;
      case SpecialRequest.bebekYatagi:
        return Icons.baby_changing_station_outlined;
      case SpecialRequest.gecCheckout:
        return Icons.more_time_outlined;
      case SpecialRequest.havuzManzarasi:
        return Icons.pool_outlined;
      case SpecialRequest.diyetMenu:
        return Icons.restaurant_menu_outlined;
      case SpecialRequest.transfer:
        return Icons.airport_shuttle_outlined;
    }
  }

  IconData _getPowerUpIcon(PowerUpType type) {
    switch (type) {
      case PowerUpType.zamanDondur:
        return Icons.hourglass_bottom_outlined;
      case PowerUpType.ipucu:
        return Icons.lightbulb_outline_rounded;
      case PowerUpType.pasGec:
        return Icons.skip_next_outlined;
    }
  }

  IconData _getGuestIcon(GuestType type) {
    switch (type) {
      case GuestType.normal:
        return Icons.person_outline_rounded;
      case GuestType.turistGrup:
        return Icons.groups_outlined;
      case GuestType.isInsani:
        return Icons.business_center_outlined;
      case GuestType.aile:
        return Icons.people_alt_outlined;
      case GuestType.yasliCift:
        return Icons.nature_people_outlined;
      case GuestType.ozelGereksinim:
        return Icons.accessible_forward_outlined;
      case GuestType.vip:
        return Icons.star_rounded;
      case GuestType.balayi:
        return Icons.favorite_border_rounded;
    }
  }

  IconData _getAchievementIcon(Achievement type) {
    switch (type) {
      case Achievement.ilkCheckIn:
        return Icons.card_membership_outlined;
      case Achievement.comboUstasi:
        return Icons.local_fire_department_outlined;
      case Achievement.mukemmeliyetci:
        return Icons.thumb_up_alt_outlined;
      case Achievement.gelirKrali:
        return Icons.monetization_on_outlined;
      case Achievement.genelMudur:
        return Icons.emoji_events_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionSimulatorProvider);
    final notifier = ref.read(receptionSimulatorProvider.notifier);


    ref.listen<ReceptionSimulatorState>(receptionSimulatorProvider,
        (prev, next) {
      // Yeni misafir geldi
      if (prev?.currentGuest != next.currentGuest && next.currentGuest != null) {
        _guestController.reset();
        _guestController.forward();
        _playSFX('https://assets.mixkit.co/active_storage/sfx/911/911-84.wav'); // Resepsiyon Servis Zili
      }
      // Geri bildirim gösterildi (Doğru / Yanlış / Pas / Ayrıldı)
      if (next.feedbackMessage != null &&
          prev?.feedbackMessage != next.feedbackMessage) {
        _feedbackController.reset();
        _feedbackController.forward();

        if (next.feedbackType == FeedbackType.perfect ||
            next.feedbackType == FeedbackType.correct ||
            next.feedbackType == FeedbackType.partial) {
          _playSFX('https://assets.mixkit.co/active_storage/sfx/1435/1435-84.wav'); // Keyifli Başarı Tınısı
        } else if (next.feedbackType == FeedbackType.wrong) {
          _playSFX('https://assets.mixkit.co/active_storage/sfx/2565/2565-84.wav'); // Rahatsız etmeyen yumuşak hata sesi
        } else if (next.feedbackType == FeedbackType.guestLeft) {
          _playSFX('https://assets.mixkit.co/active_storage/sfx/950/950-84.wav'); // Misafir süresi dolma / ayrılma tınısı
        }
      }
      // Yanlış cevap — sallama
      if ((next.feedbackType == FeedbackType.wrong ||
              next.feedbackType == FeedbackType.guestLeft) &&
          prev?.feedbackType != next.feedbackType) {
        _shakeController.reset();
        _shakeController.forward();
      }
      // Seviye geçişi ve oyun sonu durumları
      if (prev?.phase != next.phase) {
        if (next.phase == GamePhase.levelUp) {
          _playSFX('https://assets.mixkit.co/active_storage/sfx/2019/2019-84.wav'); // Seviye Atlama Sihirli Chime
        } else if (next.phase == GamePhase.gameOver) {
          _playSFX('https://assets.mixkit.co/active_storage/sfx/2018/2018-84.wav'); // Oyun bitişi yumuşak sweep efekti
          ref.read(badgeProgressProvider.notifier).incrementReceptionCompleted();
        }
      }
      // Güç-Up Aktivasyonu
      if (prev?.activePowerUp != next.activePowerUp && next.activePowerUp != null) {
        _playSFX('https://assets.mixkit.co/active_storage/sfx/2019/2019-84.wav'); // Güç-up sihirli geçiş
      }
    });

    // Global ses toggle dinle
    final isSoundOn = ref.watch(soundSettingsProvider);
    if (_isBgmPlaying) {
      _bgmPlayer.setVolume(isSoundOn ? 0.18 : 0.0);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF070F1E),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070F1E), Color(0xFF0F203C), Color(0xFF050A14)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Ambient glow spots for luxury hotel feel
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF17B5B0).withOpacity(0.06),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8AA42).withOpacity(0.04),
                      blurRadius: 100,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: switch (state.phase) {
                GamePhase.intro => _buildIntroScreen(notifier),
                GamePhase.tutorial => ReceptionSimulatorTutorial(
                    onComplete: () => notifier.startGame(),
                  ),
                GamePhase.playing || GamePhase.levelUp => _isResuming 
                    ? _buildResumingScreen(state, notifier)
                    : _buildGameScreen(state, notifier),
                GamePhase.gameOver => _buildGameOverScreen(state, notifier),
              },
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  GİRİŞ EKRANI
  // ══════════════════════════════════════════

  Widget _buildIntroScreen(ReceptionSimulatorNotifier notifier) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + 0.05 * _pulseController.value;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0E918C), Color(0xFF17B5B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E918C).withValues(alpha: 0.5),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_active_outlined,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Başlık
            Text(
              'Resepsiyon\nSimülatörü',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ön Büro Eğitim Simülasyonu',
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF17B5B0),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '8 Seviye • 8 Oda Tipi • 6 Pansiyon',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Butonlar
            _buildIntroButton(
              icon: Icons.play_arrow_rounded,
              label: 'Oyuna Başla',
              gradient: const [Color(0xFF0E918C), Color(0xFF17B5B0)],
              onTap: () => notifier.startGame(),
            ),
            const SizedBox(height: 14),
            _buildIntroButton(
              icon: Icons.menu_book_rounded,
              label: 'Nasıl Oynanır?',
              gradient: const [Color(0xFF205295), Color(0xFF2C74B3)],
              onTap: () => notifier.showTutorial(),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  DEVAM / BAŞTAN BAŞLA EKRANI
  // ══════════════════════════════════════════

  Widget _buildResumingScreen(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final config = LevelConfig.levels[state.currentLevel];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Seviye ikonu
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + 0.05 * _pulseController.value;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8AA42), Color(0xFFF0C36D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8AA42).withValues(alpha: 0.5),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Seviye numarası
            Text(
              'Seviye ${state.currentLevel + 1}',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF17B5B0),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),

            // Seviye başlığı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8AA42), Color(0xFFF0C36D)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                config.title.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Açıklama
            Text(
              'Kaldığınız seviyeden devam edebilir\nveya oyuna baştan başlayabilirsiniz.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            // Mevcut istatistikler
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResumingStat(
                    Icons.emoji_events_outlined,
                    'Skor',
                    _formatNumber(state.score),
                    Colors.cyanAccent,
                  ),
                  _buildResumingStat(
                    Icons.monetization_on_outlined,
                    'Gelir',
                    '₺${_formatNumber(state.totalRevenue)}',
                    const Color(0xFFE8AA42),
                  ),
                  _buildResumingStat(
                    Icons.star_outline_rounded,
                    'İtibar',
                    '${state.reputation}',
                    state.reputation > 60
                        ? const Color(0xFFE8AA42)
                        : Colors.redAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Devam Et butonu
            _buildIntroButton(
              icon: Icons.play_arrow_rounded,
              label: 'Devam Et',
              gradient: const [Color(0xFF0E918C), Color(0xFF17B5B0)],
              onTap: () {
                setState(() {
                  _isResuming = false;
                });
                notifier.resumeCurrentLevel();
              },
            ),
            const SizedBox(height: 14),

            // Baştan Başla butonu
            _buildIntroButton(
              icon: Icons.refresh_rounded,
              label: 'Baştan Başla',
              gradient: const [Color(0xFF8B2252), Color(0xFFCC3366)],
              onTap: () {
                setState(() {
                  _isResuming = false;
                });
                notifier.resetGame();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumingStat(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white38,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIntroButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  OYUN EKRANI
  // ══════════════════════════════════════════

  Widget _buildGameScreen(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final config = LevelConfig.levels[state.currentLevel];

    return Stack(
      children: [
        Column(
          children: [
            _buildTopBar(state),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildGuestCard(state),
                    const SizedBox(height: 18),
                    _buildSectionTitle(Icons.bed_outlined, 'Oda Tipi Seçin'),
                    const SizedBox(height: 10),
                    _buildRoomSelection(state, notifier, config),
                    const SizedBox(height: 18),
                    _buildSectionTitle(Icons.restaurant_outlined, 'Pansiyon Durumu Seçin'),
                    const SizedBox(height: 10),
                    _buildBoardSelection(state, notifier, config),
                    if (state.requestOptions.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _buildSectionTitle(Icons.assignment_turned_in_outlined, 'Özel İstekleri Karşılayın'),
                      const SizedBox(height: 10),
                      _buildSpecialRequests(state, notifier),
                    ],
                    const SizedBox(height: 18),
                    _buildPowerUpBar(state, notifier),
                    const SizedBox(height: 20),
                    _buildCheckInButton(state, notifier),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Feedback overlay
        if (state.feedbackMessage != null) _buildFeedbackOverlay(state, notifier),

        // Seviye geçiş overlay
        if (state.phase == GamePhase.levelUp)
          _buildLevelUpOverlay(state, notifier),
      ],
    );
  }

  // ── Üst İstatistik Barı ──

  Widget _buildTopBar(ReceptionSimulatorState state) {
    final starRating = ReceptionSimulatorData.getStarRating(state.reputation);
    final progress = state.totalGuestsInLevel > 0
        ? (state.totalGuestsInLevel - state.guestsRemainingInLevel) /
            state.totalGuestsInLevel
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Gelir
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monetization_on_outlined, color: Colors.white30, size: 11),
                        const SizedBox(width: 4),
                        Text(
                          'GELİR',
                          style: GoogleFonts.inter(
                            color: Colors.white30,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₺${_formatNumber(state.totalRevenue)}',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFE8AA42),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              // Seviye
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars_outlined, color: const Color(0xFF17B5B0), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'Lv.${state.currentLevel + 1} ${state.levelTitle.toUpperCase()}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.08),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF17B5B0)),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              // Skor ve Ses Toggle
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Premium Speaker Toggle (Puanın solunda)
                    GestureDetector(
                      onTap: () => ref.read(soundSettingsProvider.notifier).toggleMute(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: Icon(
                          ref.watch(soundSettingsProvider) ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                          color: ref.watch(soundSettingsProvider) ? const Color(0xFF17B5B0) : Colors.white38,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'SKOR',
                              style: GoogleFonts.inter(
                                color: Colors.white30,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.emoji_events_outlined, color: Colors.white30, size: 11),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatNumber(state.score),
                          style: GoogleFonts.outfit(
                            color: Colors.cyanAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // İtibar yıldızları
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < starRating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: i < starRating
                        ? const Color(0xFFE8AA42)
                        : Colors.white24,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(width: 6),
              Text(
                '${state.reputation}',
                style: GoogleFonts.inter(
                  color: state.reputation > 60
                      ? const Color(0xFFE8AA42)
                      : Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              // Combo göstergesi
              if (state.comboCount >= 3)
                AnimatedScale(
                  scale: 1.0 + (state.comboCount > 5 ? 0.1 : 0),
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFE8AA42)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.white, size: 13),
                        const SizedBox(width: 2),
                        Text(
                          'x${state.comboMultiplier.toStringAsFixed(1)}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Kalan misafir
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_alt_outlined, color: Colors.white38, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${state.guestsRemainingInLevel}',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Misafir Kartı ──

  Widget _buildGuestCard(ReceptionSimulatorState state) {
    final guest = state.currentGuest;
    if (guest == null) return const SizedBox.shrink();

    final patienceFraction = state.guestPatienceTotal > 0
        ? (state.guestPatienceRemaining / state.guestPatienceTotal).clamp(0.0, 1.0)
        : 0.0;
    final patienceColor = patienceFraction > 0.5
        ? Color.lerp(const Color(0xFFE8AA42), const Color(0xFF2ED573), (patienceFraction - 0.5) * 2)!
        : Color.lerp(const Color(0xFFFF4757), const Color(0xFFE8AA42), patienceFraction * 2)!;

    final isVip = guest.type == GuestType.vip;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset = sin(_shakeAnimation.value * pi * 4) * 10 *
            (1 - _shakeAnimation.value);
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: SlideTransition(
        position: _guestSlideIn,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isVip
                  ? const Color(0xFFE8AA42).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: isVip ? 2 : 1,
            ),
            boxShadow: [
              if (isVip)
                BoxShadow(
                  color: const Color(0xFFE8AA42).withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst: Avatar + İsim + Tip
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isVip
                            ? [const Color(0xFFE8AA42), const Color(0xFFF0C36D)]
                            : [const Color(0xFF0E918C), const Color(0xFF17B5B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (isVip ? const Color(0xFFE8AA42) : const Color(0xFF0E918C))
                              .withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getGuestIcon(guest.type),
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(guest.flag,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                guest.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isVip
                                ? const Color(0xFFE8AA42).withValues(alpha: 0.2)
                                : const Color(0xFF17B5B0).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            guest.type.displayName.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: isVip
                                  ? const Color(0xFFE8AA42)
                                  : const Color(0xFF17B5B0),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isVip)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: 0.6 + 0.4 * _pulseController.value,
                          child: child,
                        );
                      },
                      child: const Icon(
                        Icons.star_rounded,
                        size: 32,
                        color: Color(0xFFE8AA42),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Diyalog balonu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.01),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 16,
                      color: isVip ? const Color(0xFFE8AA42) : const Color(0xFF17B5B0),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        guest.dialogue,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.95),
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Sabır çubuğu
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: patienceColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.linear,
                        child: LinearProgressIndicator(
                          value: patienceFraction,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation(patienceColor),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${state.guestPatienceRemaining.ceil()}s',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: patienceColor,
                    ),
                  ),
                  if (state.activePowerUp == PowerUpType.zamanDondur) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '⏸️ ${state.powerUpRemainingSeconds}s',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bölüm Başlığı ──

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF17B5B0)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  // ── Oda Seçimi ──

  Widget _buildRoomSelection(ReceptionSimulatorState state,
      ReceptionSimulatorNotifier notifier, LevelConfig config) {
    final availableRooms = config.availableRooms;

    final chips = availableRooms.map((room) {
      final isSelected = state.selectedRoom == room;
      return _buildSelectionChip(
        icon: _getRoomIcon(room),
        label: room.displayName,
        isSelected: isSelected,
        accentColor: const Color(0xFF17B5B0),
        onTap: () => notifier.selectRoom(room),
      );
    }).toList();

    return _buildAlignedGrid(chips);
  }

  // ── Pansiyon Seçimi ──

  Widget _buildBoardSelection(ReceptionSimulatorState state,
      ReceptionSimulatorNotifier notifier, LevelConfig config) {
    final availableBoards = config.availableBoards;

    final chips = availableBoards.map((board) {
      final isSelected = state.selectedBoard == board;
      return _buildSelectionChip(
        icon: _getBoardIcon(board),
        label: board.displayName,
        isSelected: isSelected,
        accentColor: const Color(0xFFE8AA42),
        onTap: () => notifier.selectBoard(board),
      );
    }).toList();

    return _buildAlignedGrid(chips);
  }

  // ── Özel İstekler ──

  Widget _buildSpecialRequests(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final chips = state.requestOptions.map((req) {
      final isSelected = state.selectedRequests.contains(req);
      return _buildSelectionChip(
        icon: _getSpecialRequestIcon(req),
        label: req.displayName,
        isSelected: isSelected,
        accentColor: const Color(0xFF8B5CF6),
        onTap: () => notifier.toggleRequest(req),
      );
    }).toList();

    return _buildAlignedGrid(chips);
  }

  // ── Aligned Grid Helper ──

  Widget _buildAlignedGrid(List<Widget> children) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += 2) {
      final hasNext = i + 1 < children.length;
      rows.add(
        Row(
          children: [
            Expanded(child: children[i]),
            const SizedBox(width: 8),
            Expanded(
              child: hasNext ? children[i + 1] : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < children.length) {
        rows.add(const SizedBox(height: 8));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  // ── Seçim Chip'i (Ortak) ──

  Widget _buildSelectionChip({
    IconData? icon,
    String? emoji,
    required String label,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.18)
              : const Color(0xFF0A192F).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? accentColor
                : Colors.white.withValues(alpha: 0.12),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: isSelected ? accentColor : Colors.white60,
                ),
              )
            else if (emoji != null)
              Text(emoji, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(Icons.check_circle_rounded, size: 14, color: accentColor),
            ],
          ],
        ),
      ),
    );
  }

  // ── Güç-Up Barı ──

  Widget _buildPowerUpBar(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    return Row(
      children: PowerUpType.values.map((type) {
        final count = state.availablePowerUps[type] ?? 0;
        final isActive = state.activePowerUp == type;
        final isDisabled = count <= 0 && !isActive;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: isDisabled ? null : () => notifier.activatePowerUp(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.cyanAccent.withValues(alpha: 0.15)
                      : isDisabled
                          ? Colors.white.withValues(alpha: 0.02)
                          : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? Colors.cyanAccent.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getPowerUpIcon(type),
                      size: 24,
                      color: isActive
                          ? Colors.cyanAccent
                          : isDisabled
                              ? Colors.white24
                              : Colors.white70,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      count > 0 ? 'x$count' : isActive ? 'Aktif' : '—',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? Colors.cyanAccent
                            : isDisabled
                                ? Colors.white24
                                : Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Check-in Butonu ──

  Widget _buildCheckInButton(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final isEnabled = state.selectedRoom != null &&
        state.selectedBoard != null &&
        state.feedbackMessage == null;
    
    final accentColor = const Color(0xFF17B5B0);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final glowOpacity = isEnabled
              ? 0.35 + 0.2 * sin(_pulseController.value * pi)
              : 0.0;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEnabled
                    ? accentColor.withOpacity(0.5)
                    : Colors.white.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: glowOpacity),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: child,
          );
        },
        child: ElevatedButton(
          onPressed: isEnabled ? () => notifier.submitCheckIn() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.04),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [Color(0xFF0E918C), Color(0xFF17B5B0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.how_to_reg_rounded,
                    size: 22,
                    color: isEnabled ? Colors.white : Colors.white24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'CHECK-IN',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: isEnabled ? Colors.white : Colors.white24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Feedback Overlay ──

  Widget _buildFeedbackOverlay(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    Color bgColor;
    switch (state.feedbackType) {
      case FeedbackType.perfect:
        bgColor = const Color(0xFF2ED573);
        break;
      case FeedbackType.correct:
        bgColor = const Color(0xFF17B5B0);
        break;
      case FeedbackType.partial:
        bgColor = const Color(0xFFE8AA42);
        break;
      case FeedbackType.wrong:
      case FeedbackType.guestLeft:
        bgColor = const Color(0xFFFF4757);
        break;
      default:
        bgColor = Colors.white;
    }

    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _feedbackOpacity,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.feedbackMessage ?? '',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => notifier.moveToNextGuest(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white30, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sonraki Misafir',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  SEVİYE GEÇİŞ OVERLAY
  // ══════════════════════════════════════════

  Widget _buildLevelUpOverlay(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final nextLevel = state.currentLevel + 1;
    final nextConfig = LevelConfig.levels[nextLevel];

    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8AA42).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE8AA42), width: 1.5),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 44,
                  color: Color(0xFFE8AA42),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Terfi Aldınız!',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF17B5B0),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Seviye ${nextLevel + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8AA42), Color(0xFFF0C36D)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  nextConfig.title.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Yeni açılan özellikler (Tek Panelde Kompakt Liste)
              if (state.newUnlocks.isNotEmpty) ...[
                Text(
                  'YENİ AÇILAN ÖZELLİKLER',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white38,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    children: state.newUnlocks.map((unlock) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        '✔️ $unlock',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF2ED573),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () => notifier.continueAfterLevelUp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E918C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Devam Et',
                        style: GoogleFonts.outfit(
                            fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  OYUN SONU EKRANI
  // ══════════════════════════════════════════

  Widget _buildGameOverScreen(
      ReceptionSimulatorState state, ReceptionSimulatorNotifier notifier) {
    final accuracy = state.guestsServed > 0
        ? ((state.guestsCorrect / state.guestsServed) * 100).round()
        : 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF17B5B0).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.domain_verification_rounded,
                size: 40,
                color: Color(0xFF17B5B0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gün Sonu Raporu',
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lv.${state.currentLevel + 1} ${state.levelTitle.toUpperCase()}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF17B5B0),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 14),

            // İstatistik Kartları (2'li Yan Yana Grid)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.people_outline_rounded,
                    Colors.blueAccent,
                    'Toplam Misafir',
                    '${state.guestsServed}',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    Icons.check_circle_outline_rounded,
                    Colors.greenAccent,
                    'Başarılı Check-in',
                    '${state.guestsCorrect}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.track_changes_rounded,
                    Colors.orangeAccent,
                    'Doğruluk Oranı',
                    '%$accuracy',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    Icons.monetization_on_outlined,
                    Colors.amber,
                    'Toplam Gelir',
                    '₺${_formatNumber(state.totalRevenue)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    Icons.emoji_events_outlined,
                    Colors.yellow,
                    'Toplam Skor',
                    _formatNumber(state.score),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    Icons.local_fire_department_outlined,
                    Colors.redAccent,
                    'En Yüksek Combo',
                    'x${ReceptionSimulatorData.getComboMultiplier(state.maxCombo).toStringAsFixed(1)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStatCard(
              Icons.star_outline_rounded,
              Colors.amber,
              'Final İtibar Derecesi',
              '${state.reputation} / 100',
              isFullWidth: true,
            ),
            const SizedBox(height: 14),

            // Kazanılan rozetler
            if (state.earnedAchievements.isNotEmpty) ...[
              Text(
                'Kazanılan Rozetler',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white54,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.earnedAchievements.map((a) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8AA42), Color(0xFFF0C36D)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8AA42).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAchievementIcon(a),
                          color: Colors.black87,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              a.displayName,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Butonlar
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => notifier.startGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E918C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Tekrar Oyna',
                      style: GoogleFonts.outfit(
                          fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white54,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.exit_to_app_rounded, size: 16, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      'Çıkış',
                      style: GoogleFonts.outfit(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    Color iconColor,
    String label,
    String value, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Yardımcılar ──

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
