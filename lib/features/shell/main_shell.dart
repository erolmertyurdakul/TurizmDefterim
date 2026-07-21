import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/mini_games/presentation/screens/mini_games_screen.dart';
import '../../features/badges/presentation/screens/badges_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../core/services/podcast_service.dart';
import '../../core/providers/shell_tab_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../../app.dart';
import '../../core/presentation/widgets/podcast_speed_control.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> with RouteAware, TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _breathingController;
  late final AnimationController _gradientController;
  final GlobalKey _miniPlayerBoxKey = GlobalKey();

  final List<Widget> _screens = const [
    HomeScreen(),
    MiniGamesScreen(),
    BadgesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: ref.read(shellTabProvider));
    
    // Sürekli canlı nefes alma/süzülme animasyonu için controller
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // Butonların içindeki renk geçişlerinin dalgalanması için yavaş dönen controller
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _pageController.dispose();
    _breathingController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  void didPush() {
    PodcastService().isMainShellVisible = true;
  }

  @override
  void didPushNext() {
    PodcastService().isMainShellVisible = false;
  }

  @override
  void didPopNext() {
    PodcastService().isMainShellVisible = true;
  }

  Widget _buildMiniSeekBar(BuildContext context) {
    final player = PodcastService().player;
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = player.duration ?? Duration.zero;
        
        final currentPos = position.inMilliseconds > duration.inMilliseconds
            ? duration
            : position;

        return Column(
          children: [
            const SizedBox(height: 2),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.cyanAccent,
                inactiveTrackColor: Colors.white24,
                trackHeight: 2.0,
                thumbColor: Colors.cyanAccent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.0),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                min: 0.0,
                max: duration.inMilliseconds.toDouble() > 0.0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0,
                value: currentPos.inMilliseconds.toDouble(),
                onChanged: (value) {
                  player.seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlobalMiniPlayer() {
    final player = PodcastService().player;
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing ?? false;
        
        final currentUrl = PodcastService().currentUrl;
        if (currentUrl == null || processingState == ProcessingState.idle) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 12, sigmaY: kIsWeb ? 0 : 12),
              child: Container(
                key: _miniPlayerBoxKey,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A192F).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.podcasts_rounded,
                            color: Colors.cyanAccent,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                PodcastService().currentTitle ?? "Podcast Dinleniyor",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                PodcastService().currentAlbum ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PodcastSpeedControl(
                          accentColor: Colors.cyanAccent, 
                          opensUpward: true,
                          targetAlignKey: _miniPlayerBoxKey,
                        ),
                        IconButton(
                          icon: Icon(
                            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            if (playing) {
                              PodcastService().pause();
                            } else {
                              PodcastService().resume();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white60,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              PodcastService().stop();
                            });
                          },
                        ),
                      ],
                    ),
                    _buildMiniSeekBar(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(shellTabProvider);

    ref.listen<int>(shellTabProvider, (previous, next) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens.map((screen) => RepaintBoundary(child: screen)).toList(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGlobalMiniPlayer(),
                  
                  // Saran Kavisli Şeffaf Cam Gövde (Glassmorphic Navigation Bar)
                  AnimatedBuilder(
                    animation: _breathingController,
                    builder: (context, child) {
                      final breathingVal = _breathingController.value;
                      
                      // Aktif sekmeye göre gövdenin neon parıltı rengini belirle
                      Color activeColor;
                      switch (currentIndex) {
                        case 0:
                          activeColor = const Color(0xFF00E5FF); // Sınıflar: Neon Mavi
                          break;
                        case 1:
                          activeColor = const Color(0xFFD500F9); // Uygulamalar: Neon Mor
                          break;
                        case 2:
                          activeColor = const Color(0xFFFFAB00); // Rozetler: Neon Altın
                          break;
                        case 3:
                          activeColor = const Color(0xFFFF2D55); // Profil: Neon Pembe
                          break;
                        default:
                          activeColor = const Color(0xFF00FFCC);
                      }

                      return Container(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding > 0 ? bottomPadding + 10 : 20),
                        decoration: BoxDecoration(
                          // Aktif sekmeyle harmanlanmış ultra premium derin lacivert cam rengi
                          color: Color.lerp(const Color(0xFF030914), activeColor, 0.05)!.withOpacity(0.80),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: activeColor.withOpacity(0.18), // Aktif sekmeye göre parıldayan neon sınır çizgisi
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withOpacity(kIsWeb ? 0.16 : (0.14 + breathingVal * 0.06)), // Nefes alan neon gölge (web'de sabit)
                              blurRadius: kIsWeb ? 22 : (20 + (breathingVal * 6)),
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.45),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 18, sigmaY: kIsWeb ? 0 : 18),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildNavItem(index: 0, icon: Icons.school_rounded, label: 'Sınıflar', currentIndex: currentIndex),
                                  _buildNavItem(index: 1, icon: Icons.sports_esports_rounded, label: 'Uygulamalar', currentIndex: currentIndex),
                                  _buildNavItem(index: 2, icon: Icons.emoji_events_rounded, label: 'Rozetler', currentIndex: currentIndex),
                                  _buildNavItem(index: 3, icon: Icons.person_rounded, label: 'Profil', currentIndex: currentIndex),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;
    
    // Her sekme için özel premium neon renkleri (+20 yıllık tasarımcı)
    Color activeColor;
    switch (index) {
      case 0:
        activeColor = const Color(0xFF00E5FF); // Sınıflar: Neon Elektrik Mavisi (Cyan)
        break;
      case 1:
        activeColor = const Color(0xFFD500F9); // Uygulamalar: Neon Canlı Mor / Magenta
        break;
      case 2:
        activeColor = const Color(0xFFFFAB00); // Rozetler: Neon Altın Sarısı
        break;
      case 3:
        activeColor = const Color(0xFFFF2D55); // Profil: Canlı Neon Pembe / Gül Rengi
        break;
      default:
        activeColor = const Color(0xFF00FFCC);
    }
    
    final inactiveColor = Colors.white.withOpacity(0.55);

    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _gradientController]),
      builder: (context, child) {
        final breathingVal = _breathingController.value; // 0.0 -> 1.0 -> 0.0
        final gradientVal = _gradientController.value;   // 0.0 -> 1.0
        
        // Degrade dönme açısı (Dalgalanma hissi yaratır)
        final angle = gradientVal * 2 * 3.14159265;
        
        // Seçiliyse hafif süzülme (-4px)
        final floatY = isSelected ? -4.0 + (breathingVal * -1.5) : 0.0;

        // Seçili butondaki parıltı (glow)
        final List<BoxShadow> shadows = [];
        if (isSelected) {
          shadows.add(
            BoxShadow(
              color: activeColor.withOpacity(0.40 + breathingVal * 0.15),
              blurRadius: 18 + (breathingVal * 6),
              spreadRadius: 1.5,
            ),
          );
        }

        return GestureDetector(
          key: ShellKeys.navKeys[index],
          onTap: () => ref.read(shellTabProvider.notifier).state = index,
          behavior: HitTestBehavior.opaque,
          child: Transform.translate(
            offset: Offset(0, floatY),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isSelected ? 80 : 66,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? activeColor.withOpacity(0.8) // Canlı parıldayan çerçeve
                      : Colors.white.withOpacity(0.08),
                  width: isSelected ? 1.8 : 1.0,
                ),
                boxShadow: shadows,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    // Buton içinde yavaşça dönen/dalgalanan degrade arka plan
                    gradient: LinearGradient(
                      begin: Alignment(cos(angle), sin(angle)),
                      end: Alignment(-cos(angle), -sin(angle)),
                      colors: isSelected
                          ? [
                              activeColor.withOpacity(0.26),
                              activeColor.withOpacity(0.12),
                              activeColor.withOpacity(0.26),
                            ]
                          : [
                              activeColor.withOpacity(0.06),
                              activeColor.withOpacity(0.01),
                              activeColor.withOpacity(0.06),
                            ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: isSelected ? 1.12 : 1.0, // Seçildiğinde ikon büyür
                        child: Icon(
                          icon,
                          size: 20,
                          color: isSelected ? Colors.white : inactiveColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 9.5,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                          color: isSelected ? Colors.white : inactiveColor.withOpacity(0.8),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
