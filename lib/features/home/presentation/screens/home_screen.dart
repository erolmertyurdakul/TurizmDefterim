import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/daily_facts.dart';
import '../../../courses/presentation/screens/coming_soon_screen.dart';
import '../../../courses/presentation/screens/course_list_screen.dart';
import '../../../scenarios/presentation/screens/scenario_list_screen.dart';
import '../../../terminology/presentation/screens/terminology_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/data/terminology_data.dart';
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
        final now = DateTime.now();
        final startOfYear = DateTime(now.year, 1, 1);
        final dayOfYearIndex = now.difference(startOfYear).inDays;
        final factIndex = dayOfYearIndex % 365;
        final fact = dailyFacts[factIndex];
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
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.sm),

                // ── Hoşgeldin Banner ──
                _buildWelcomeBanner(context),

                const SizedBox(height: AppSizes.lg),

                // ── Bölüm Başlığı: Sınıflar ──
                _buildSectionTitle(
                  context,
                  icon: Icons.school_rounded,
                  title: 'Sınıfını Seç',
                  subtitle: 'Öğrenim planına uygun içeriklere eriş',
                ),

                const SizedBox(height: AppSizes.md),

                // ── 4 Sınıf Kartı (2x2 Grid) ──
                _buildGradeGrid(context),

                const SizedBox(height: AppSizes.xl),

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

                    const SizedBox(height: AppSizes.md),

                    // ── İnteraktif Vaka Analizi Kartı ──
                    _buildModuleCard(
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
                    ),

                    const SizedBox(height: AppSizes.md),

                    // ── Terimler Sözlüğü & Quiz Kartı ──
                    _buildModuleCard(
                      context,
                      title: 'Turizm Terimler Sözlüğü',
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
                    ),

                    const SizedBox(height: AppSizes.md),

                    // ── Günün Bilgisi Kartı ──
                    _buildModuleCard(
                      context,
                      title: 'Günün Bilgisi',
                      subtitle: 'Her gün yeni bir bilgi öğren',
                      icon: Icons.lightbulb_rounded,
                      gradient: AppColors.oceanGradient,
                      iconBg: const Color(0xFF0F52BA),
                      onTap: () {
                        _showDailyFactDialog(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 100),
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
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // İlgili Yerin Fotoğrafı
                    Padding(
                      padding: const EdgeInsets.only(top: AppSizes.lg, left: AppSizes.lg, right: AppSizes.lg),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imageAsset,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: AppColors.surface,
                              child: const Center(
                                child: Icon(Icons.image_not_supported_rounded, color: AppColors.textHint, size: 40),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        children: [
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
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.oceanGradient,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2), // Premium outline!
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
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 0.8), // Dış ince orbital halka
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.0), // Çerçeve halkası
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: AppColors.primarySeed.withValues(alpha: 0.25),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.05),
                                blurRadius: 6,
                                spreadRadius: -1,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: ClipOval(
                              child: Transform.scale(
                                scale: 1.09,
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Turizm Defterim',
                        style: GoogleFonts.outfit(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFCFCFD),
                        ),
                      ),
                    ],
                  ),
                  // Puan Gösterimi
                  Consumer(
                    builder: (context, ref, child) {
                      final points = ref.watch(pointsProvider);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primarySeed.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$points',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Text.rich(
                textScaler: TextScaler.noScaling,
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)], // Giriş ekranıyla birebir aynı Neon Cyan ➔ Mavi geçişi
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Konaklama ve Seyahat Akademisi ',
                          style: GoogleFonts.outfit(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white, // Maskeleme için beyaz
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
            const SizedBox(height: AppSizes.sm),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF9D4EDD), Colors.white], // Koyu mor ve beyaz gradyanı
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        '“',
                        style: GoogleFonts.inter(
                          fontSize: 22.0,
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
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500, // Okunabilirlik için w400'den w500'e (Medium) yükseltildi
                      color: const Color(0xFFF3E8FF), // Soluk beyaz yerine hafif morumsu tatlı bir inci beyazı
                      height: 1.6,
                      letterSpacing: 0.2,
                      shadows: const [
                        Shadow(
                          color: Colors.black38, // Beyaz gölge yerine siyah gölgeyle netlik ve kontrast artırıldı
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
                        colors: [Color(0xFF9D4EDD), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        '”',
                        style: GoogleFonts.inter(
                          fontSize: 22.0,
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
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryMid.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryMid, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
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
      _GradeData('9', 'Sınıf', Icons.explore_rounded, AppColors.grade9Gradient, '6 Öğrenme Birimi'),
      _GradeData('10', 'Sınıf', Icons.room_service_rounded, AppColors.grade10Gradient, '13 Öğrenme Birimi'),
      _GradeData('11', 'Sınıf', Icons.public_rounded, AppColors.grade11Gradient, '14 Öğrenme Birimi'),
      _GradeData('12', 'Sınıf', Icons.airport_shuttle_rounded, AppColors.grade12Gradient, '37 Öğrenme Birimi'),
    ];

    return Container(
      key: _gradeGridKey,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.05,
        ),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          return _buildGradeCard(context, grades[index], index);
        },
      ),
    );
  }

  Widget _buildGradeCard(BuildContext context, _GradeData data, int index) {
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
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2), // Premium glassmorphic border!
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26, // Smoother, uniform premium shadow
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // İkon Satırı: Sol tarafta branş ikonu, sağ tarafta cam efektli gitme oku
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 2.0),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          data.icon,
                          color: Colors.white,
                          size: 19.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
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
                      children: [
                        // Sınıf numarası
                        Text(
                          '${data.grade}.',
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          data.label,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Ünite bilgisi
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.unitInfo,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
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
  //  MODÜL KARTI (Büyük, şık)
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
    return RepaintBoundary(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
        )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.2),
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
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: iconBg.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  
                  // Orta: Başlık & Alt Başlık
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.outfit(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle.replaceAll('\n', ' '),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // Sağ: Ok butonu
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 13,
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

    // 1. Parıltı (Sol Üst) - Döngünün 0.0 - 0.45 aralığında aktif
    _sparkle1Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45)));
    
    _sparkle1Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45)));

    // 2. Parıltı (Sağ Üst) - Döngünün 0.25 - 0.70 aralığında aktif
    _sparkle2Scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.7)));

    _sparkle2Opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.7)));

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
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_translationAnimation.value, 0),
          child: const Icon(
            Icons.chevron_right_rounded, // Kalın yuvarlatılmış chevron
            color: Colors.white,
            size: 23.5, // Boyut ve çizgi kalınlığı %30 oranında artırıldı (18 -> 23.5)
          ),
        );
      },
    );
  }
}
