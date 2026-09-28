import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/daily_facts.dart';
import '../../../courses/presentation/screens/course_list_screen.dart';
import '../../../scenarios/presentation/screens/scenario_list_screen.dart';
import '../../../terminology/presentation/screens/terminology_screen.dart';
import '../../../../core/utils/fade_page_route.dart';
import '../../../notes/presentation/screens/student_notes_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/points_provider.dart';
import 'onboarding_tour_screen.dart';
import '../../../../core/providers/shell_tab_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;

  final GlobalKey _gradeGridKey = GlobalKey();
  final GlobalKey _modulesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowOnboarding();
    });
  }

  Future<void> _checkAndShowOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeen = prefs.getBool('has_seen_onboarding_guide') ?? false;
      if (!hasSeen) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          OnboardingTourScreen.show(context, _gradeGridKey, _modulesKey);
        }
      }
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the daily fact image after the first layout frame to eliminate startup frame drop!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        precacheImage(const AssetImage('assets/images/Daily_Info_Image.jpeg'), context);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktop = screenWidth >= 1050;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 28.0 : AppSizes.screenPadding,
              vertical: isWide ? 14.0 : AppSizes.screenPadding,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isWide ? 4.0 : AppSizes.sm),

                // ── Hoşgeldin Banner ──
                _buildWelcomeBanner(context),

                SizedBox(height: isWide ? (isDesktop ? 26.0 : 22.0) : AppSizes.lg),

                // ── Bölüm Başlığı: Sınıflar ──
                _buildSectionTitle(
                  context,
                  icon: Icons.school_rounded,
                  title: 'Sınıfını Seç',
                  subtitle: 'Öğrenim planına uygun içeriklere eriş',
                ),

                SizedBox(height: isWide ? (isDesktop ? 16.0 : 14.0) : AppSizes.md),

                // ── 4 Sınıf Kartı (2x2 Grid mobilde, 4 sütun geniş ekranda) ──
                _buildGradeGrid(context),

                SizedBox(height: isWide ? (isDesktop ? 28.0 : 24.0) : AppSizes.xl),

                Column(
                  key: _modulesKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Bölüm Başlığı: Gelişim Atölyesi ──
                    _buildSectionTitle(
                      context,
                      icon: Icons.insights_rounded,
                      title: 'Gelişim Atölyesi',
                      subtitle: 'Bilgini pekiştir, pratik yap',
                    ),

                    SizedBox(height: isWide ? (isDesktop ? 16.0 : 14.0) : AppSizes.md),

                    // ── Gelişim Atölyesi Modülleri (Geniş ekranda 4 modül tek satır, tablette 2x2, mobilde alt alta) ──
                    _buildWorkshopModules(context),
                  ],
                ),

                SizedBox(height: isWide ? (isDesktop ? 120.0 : 110.0) : 100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  GÜNÜN BİLGİSİ DIALOG
  // ══════════════════════════════════════════
  void _showDailyFactDialog(BuildContext context) {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYearIndex = now.difference(startOfYear).inDays;
    
    int factIndex = dayOfYearIndex % 365;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final fact = dailyFacts[factIndex];
            final dayDisplay = factIndex + 1;
            // Sabit resim — tüm 365 gün için aynı görsel
            const imageAsset = 'assets/images/Daily_Info_Image.jpeg';

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                side: BorderSide(color: AppColors.divider.withValues(alpha: 0.6), width: 1.2), // Premium dialog border!
              ),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: 340, // Perfect premium dialog width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.oceanGradient,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppSizes.radiusXl - 1.2), // Perfect alignment
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            'GÜNÜN TURİZM BİLGİSİ',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'Yılın $dayDisplay. Gününe Özel',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        children: [
                          // Sabit Bilgi Görseli (Container boyutu sabit)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                            child: Image.asset(
                              imageAsset,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                ),
                                child: const Center(
                                  child: Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary, size: 40),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            fact,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: AppSizes.xl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (factIndex > 0) {
                                      factIndex--;
                                    } else {
                                      factIndex = 364; // Wrap to end
                                    }
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryMid),
                              ),
                              Text(
                                '${factIndex + 1} / 365',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryMid,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (factIndex < 364) {
                                      factIndex++;
                                    } else {
                                      factIndex = 0; // Wrap to start
                                    }
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryMid),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ══════════════════════════════════════════
  //  HOŞGELDİN BANNER
  // ══════════════════════════════════════════
  Widget _buildWelcomeBanner(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;

    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 30 : AppSizes.lg,
            vertical: isWide ? 16 : AppSizes.lg,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.oceanGradient,
            ),
            borderRadius: BorderRadius.circular(isWide ? 28 : 24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.2), // Premium outline!
            boxShadow: const [
              BoxShadow(
                color: Colors.black26, // Premium floating shadow
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst satır: Logo & bildirim
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sol: Dalga ikonu ve uygulama adı
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: const Color(0xFF00D2FF).withValues(alpha: 0.35),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: isWide ? 44 : 32,
                          height: isWide ? 44 : 32,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: isWide ? 44 : 32,
                              height: isWide ? 44 : 32,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isWide ? 14 : 12),
                      Text(
                        'Turizm Defterim',
                        style: GoogleFonts.outfit(
                          fontSize: isWide ? 28 : 21,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFCFCFD),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  // Puan Gösterimi
                  Consumer(
                    builder: (context, ref, child) {
                      final points = ref.watch(pointsProvider);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: isWide ? 18 : 12, vertical: isWide ? 8 : 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primarySeed.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stars_rounded, color: const Color(0xFFF59E0B), size: isWide ? 24 : 18),
                            SizedBox(width: isWide ? 6 : 4),
                            Text(
                              '$points',
                              style: GoogleFonts.outfit(
                                fontSize: isWide ? 18 : 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: isWide ? 12 : AppSizes.md),
              Text.rich(
                textScaler: TextScaler.noScaling,
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF38BDF8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Konaklama ve Seyahat Akademisi ',
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 19.0 : 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.3,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: _PremiumGlowingStar(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isWide ? 8 : AppSizes.sm),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFFE0F2FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          '“',
                          style: GoogleFonts.inter(
                            fontSize: isWide ? 28.0 : 22.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 0.8,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: " Turizm alanında binlerce bilgiye ulaşabileceğin içerikler (ders notları, podcastler, testler, terimler sözlüğü, vaka analizleri ve simülatörler) seninle! ",
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 16.5 : 12.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF8FAFC),
                        height: 1.5,
                        letterSpacing: 0.2,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(0, 1.5),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF38BDF8), Color(0xFFE0F2FE)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          '”',
                          style: GoogleFonts.inter(
                            fontSize: isWide ? 28.0 : 22.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  BÖLÜM BAŞLIĞI
  // ══════════════════════════════════════════
  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktop = screenWidth >= 1050;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isWide ? (isDesktop ? 14 : 12) : 8),
          decoration: BoxDecoration(
            color: AppColors.primaryMid.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primaryMid, size: isWide ? (isDesktop ? 30 : 28) : 20),
        ),
        SizedBox(width: isWide ? (isDesktop ? 16 : 14) : 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: isWide ? (isDesktop ? 26 : 24) : 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: isWide ? (isDesktop ? 15.5 : 15.0) : 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  SINIF GRID (2x2)
  // ══════════════════════════════════════════
  Widget _buildGradeGrid(BuildContext context) {
    final grades = [
      _GradeData('9', 'Sınıf', Icons.explore_rounded, AppColors.grade9Gradient, '20 Öğrenme Birimi'),
      _GradeData('10', 'Sınıf', Icons.room_service_rounded, AppColors.grade10Gradient, '13 Öğrenme Birimi'),
      _GradeData('11', 'Sınıf', Icons.public_rounded, AppColors.grade11Gradient, '25 Öğrenme Birimi'),
      _GradeData('12', 'Sınıf', Icons.airport_shuttle_rounded, AppColors.grade12Gradient, '37 Öğrenme Birimi'),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktop = screenWidth >= 1050;

    return Container(
      key: _gradeGridKey,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWide ? (screenWidth >= 900 ? 4 : 2) : 2,
          crossAxisSpacing: isWide ? (isDesktop ? 18 : 20) : 14,
          mainAxisSpacing: isWide ? (isDesktop ? 18 : 20) : 14,
          mainAxisExtent: isWide ? (isDesktop ? 305 : 225) : null,
          childAspectRatio: isWide ? 1.0 : 0.96,
        ),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          return _buildGradeCard(context, grades[index], index);
        },
      ),
    );
  }

  // ══════════════════════════════════════════
  //  GELİŞİM ATÖLYESİ MODÜLLERİ (PC'de 4 modül yan yana, tablette 2x2, mobilde alt alta)
  // ══════════════════════════════════════════
  Widget _buildWorkshopModules(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktopRow = screenWidth >= 1050;

    final moduleNotes = _buildModuleCard(
      context,
      title: 'Not Defterim',
      subtitle: 'Dersler için kaydetmek istediğin notları al',
      icon: Icons.menu_book_rounded,
      gradient: const [
        Color(0xFF1E3A8A),
        Color(0xFF2563EB),
        Color(0xFF3B82F6),
      ],
      iconBg: const Color(0xFF1D4ED8),
      onTap: () {
        Navigator.push(
          context,
          FadePageRoute(
            child: const StudentNotesScreen(
              entrySource: NotesEntrySource.mainMenu,
            ),
          ),
        );
      },
    );

    final module2 = _buildModuleCard(
      context,
      title: 'Turizm Sözlüğü',
      subtitle: 'Mesleki terminolojini geliştir ve sına',
      icon: Icons.quiz_rounded,
      gradient: AppColors.sunsetGradient,
      iconBg: const Color(0xFFC46420),
      onTap: () {
        Navigator.push(
          context,
          FadePageRoute(
            child: const TerminologyScreen(),
          ),
        );
      },
    );

    final module1 = _buildModuleCard(
      context,
      title: 'İnteraktif Vaka Analizi',
      subtitle: 'Turizm senaryoları üzerinde düşün',
      icon: Icons.cases_rounded,
      gradient: AppColors.turquoiseGradient,
      iconBg: const Color(0xFF0B7A76),
      onTap: () {
        Navigator.push(
          context,
          FadePageRoute(
            child: const ScenarioListScreen(),
          ),
        );
      },
    );

    final module3 = _buildModuleCard(
      context,
      title: 'Günün Bilgisi',
      subtitle: 'Her gün yeni bir bilgi öğren',
      icon: Icons.lightbulb_rounded,
      gradient: AppColors.oceanGradient,
      iconBg: const Color(0xFF0F52BA),
      onTap: () {
        _showDailyFactDialog(context);
      },
    );

    // Geniş masaüstü ekranda 4 modül tek bir satırda yer alarak taşmayı önler
    if (isDesktopRow) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: moduleNotes),
            const SizedBox(width: 14),
            Expanded(child: module2),
            const SizedBox(width: 14),
            Expanded(child: module1),
            const SizedBox(width: 14),
            Expanded(child: module3),
          ],
        ),
      );
    }

    if (isWide) {
      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: moduleNotes),
                SizedBox(width: isWide ? 16 : AppSizes.md),
                Expanded(child: module2),
              ],
            ),
          ),
          SizedBox(height: isWide ? 14 : AppSizes.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: module1),
                SizedBox(width: isWide ? 16 : AppSizes.md),
                Expanded(child: module3),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        moduleNotes,
        const SizedBox(height: AppSizes.md),
        module2,
        const SizedBox(height: AppSizes.md),
        module1,
        const SizedBox(height: AppSizes.md),
        module3,
      ],
    );
  }

  // ══════════════════════════════════════════
  //  SINIF KARTI
  // ══════════════════════════════════════════
  Widget _buildGradeCard(BuildContext context, _GradeData data, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktop = screenWidth >= 1050;

    final iconSize = isWide ? (isDesktop ? 34.0 : 28.0) : 19.5;
    final gradeNumSize = isWide ? (isDesktop ? 60.0 : 44.0) : 36.0;
    final labelSize = isWide ? (isDesktop ? 28.0 : 22.0) : 18.0;
    final unitFontSize = isWide ? (isDesktop ? 15.5 : 13.5) : 11.0;
    final unitPaddingH = isWide ? (isDesktop ? 20.0 : 14.0) : 10.0;
    final unitPaddingV = isWide ? (isDesktop ? 8.0 : 5.5) : 4.0;

    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(index.isEven ? -0.4 : 0.4, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Interval(
            0.2 + (index * 0.1),
            0.7 + (index * 0.08),
            curve: Curves.easeOutCubic,
          ),
        )),
        child: _InteractiveGradeCard(
          key: ShellKeys.gradeCardKeys[index],
          borderRadius: BorderRadius.circular(isWide ? 26 : AppSizes.radiusLg),
          onTap: () {
            Navigator.push(
              context,
              FadePageRoute(
                child: CourseListScreen(
                  grade: data.grade,
                  gradient: data.gradient,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: data.gradient,
              ),
              borderRadius: BorderRadius.circular(isWide ? 26 : AppSizes.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(isWide ? (isDesktop ? 24.0 : 20.0) : AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İkon Satırı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 2.0),
                        padding: EdgeInsets.all(isWide ? (isDesktop ? 15 : 11) : 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          data.icon,
                          color: Colors.white,
                          size: iconSize,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(isWide ? (isDesktop ? 11 : 9) : 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const _AnimatedChevron(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isWide) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${data.grade}.',
                                style: GoogleFonts.outfit(
                                  fontSize: gradeNumSize,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data.label,
                                style: GoogleFonts.outfit(
                                  fontSize: labelSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.95),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            '${data.grade}.',
                            style: GoogleFonts.outfit(
                              fontSize: gradeNumSize,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            data.label,
                            style: GoogleFonts.outfit(
                              fontSize: labelSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                        SizedBox(height: isWide ? (isDesktop ? 14 : 8) : 6),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: unitPaddingH, vertical: unitPaddingV),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.unitInfo,
                            style: GoogleFonts.inter(
                              fontSize: unitFontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                      ],
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

  // ══════════════════════════════════════════
  //  GELİŞİM ATÖLYESİ KARTI
  // ══════════════════════════════════════════
  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isDesktop = screenWidth >= 1050;

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isWide ? 22 : AppSizes.radiusLg),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? (isDesktop ? 20 : 20) : 16,
              vertical: isWide ? (isDesktop ? 28 : 18) : 14,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(isWide ? 22 : AppSizes.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Sol: İkon Kutusu
                Container(
                  padding: EdgeInsets.all(isWide ? (isDesktop ? 16 : 14) : 11),
                  decoration: BoxDecoration(
                    color: iconBg.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: 1.0),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isWide ? (isDesktop ? 30 : 26) : 22,
                  ),
                ),
                SizedBox(width: isWide ? (isDesktop ? 16 : 16) : 14),
                
                // Orta: Başlık & Alt Başlık
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: isWide ? (isDesktop ? 20.5 : 19.5) : 16.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: isWide ? 4 : 3),
                      Text(
                        subtitle.replaceAll('\n', ' '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: isWide ? (isDesktop ? 14.0 : 13.5) : 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Sağ: Ok butonu
                Container(
                  padding: EdgeInsets.all(isWide ? (isDesktop ? 11 : 9) : 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: isWide ? (isDesktop ? 22 : 20) : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sınıf Veri Modeli ──
class _GradeData {
  final String grade;
  final String label;
  final IconData icon;
  final List<Color> gradient;
  final String unitInfo;

  const _GradeData(this.grade, this.label, this.icon, this.gradient, this.unitInfo);
}

// ── Premium Animasyonlu ve Parıldayan Yıldız İkonu ──
class _PremiumGlowingStar extends StatefulWidget {
  const _PremiumGlowingStar();

  @override
  State<_PremiumGlowingStar> createState() => _PremiumGlowingStarState();
}

class _PremiumGlowingStarState extends State<_PremiumGlowingStar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  // Parıltı animasyonları
  late final Animation<double> _sparkle1Scale;
  late final Animation<double> _sparkle1Opacity;
  late final Animation<double> _sparkle2Scale;
  late final Animation<double> _sparkle2Opacity;
  late final Animation<double> _sparkle3Scale;
  late final Animation<double> _sparkle3Opacity;

  @override
  void initState() {
    super.initState();
    // 2.2 saniyelik sürekli döngü
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // 1. Parıltı (Sol Üst) - Döngünün 0.05 - 0.45 aralığında aktif
    _sparkle1Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.05, 0.45)));

    _sparkle1Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.05, 0.45)));

    // 2. Parıltı (Sağ Üst) - Döngünün 0.35 - 0.75 aralığında aktif
    _sparkle2Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.75)));

    _sparkle2Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.75)));

    // 3. Parıltı (Alt Sağ) - Döngünün 0.55 - 0.95 aralığında aktif
    _sparkle3Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.95)));

    _sparkle3Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.95)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Ana Sabit Yıldız (Gold/White Degradeli) ──
          ShaderMask(
            shaderCallback: (bounds) {
              return const RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [
                  Color(0xFFFFFBEB),
                  Color(0xFFFBBF24),
                ],
                stops: [0.3, 1.0],
              ).createShader(bounds);
            },
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          // ── Parıldayan Küçük Yıldızlar (Sparkles) ──

          // 1. Parıltı: Sol Üst
          Positioned(
            left: 1,
            top: 2,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sparkle1Scale.value,
                  child: Opacity(
                    opacity: _sparkle1Opacity.value,
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFFFBEB),
                      size: 8,
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Parıltı: Sağ Üst
          Positioned(
            right: 1,
            top: 3,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sparkle2Scale.value,
                  child: Opacity(
                    opacity: _sparkle2Opacity.value,
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFFFDF0),
                      size: 7,
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Parıltı: Sağ Alt
          Positioned(
            right: 2,
            bottom: 3,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sparkle3Scale.value,
                  child: Opacity(
                    opacity: _sparkle3Opacity.value,
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFFBBF24),
                      size: 9,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dokunulduğunda İçe Çöken Dinamik Kart Kapsayıcısı ──
class _InteractiveGradeCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  const _InteractiveGradeCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  State<_InteractiveGradeCard> createState() => _InteractiveGradeCardState();
}

class _InteractiveGradeCardState extends State<_InteractiveGradeCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

// ── Sürekli Hafifçe İleri-Geri Hareket Eden Kalın Yönlendirme İkonu ──
class _AnimatedChevron extends StatefulWidget {
  const _AnimatedChevron();

  @override
  State<_AnimatedChevron> createState() => _AnimatedChevronState();
}

class _AnimatedChevronState extends State<_AnimatedChevron> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();
    // Sürekli salınım süresi %10 yavaşlatıldı (1200ms -> 1320ms)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1320),
    )..repeat(reverse: true);

    // Kayma mesafesi mevcut halinden %20 daha kısaltıldı (toplam 2.2px -> 1.76px)
    _translationAnimation = Tween<double>(begin: -0.5, end: 1.26).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _translationAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_translationAnimation.value, 0),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 13,
          ),
        );
      },
    );
  }
}
