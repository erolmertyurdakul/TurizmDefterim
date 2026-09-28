import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/models/course_model.dart';
import '../../providers/course_provider.dart';
import 'course_detail_screen.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../../../core/utils/fade_page_route.dart';
import '../../../badges/providers/badge_provider.dart';

class CourseListScreen extends ConsumerWidget {
  final String grade;
  final List<Color> gradient;

  const CourseListScreen({
    super.key,
    required this.grade,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(badgeProgressProvider.notifier).registerGradeOpened(grade);
    });

    final courses = ref.watch(coursesProvider(grade));
    final isOnboarding = ref.watch(isOnboardingActiveProvider);
    final isWide = MediaQuery.of(context).size.width >= 768;

    return PopScope(
      canPop: !isOnboarding,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Dinamik Header ──
            SliverAppBar(
              expandedHeight: isWide ? 200 : 180,
              pinned: true,
              stretch: true,
              leadingWidth: isWide ? 76 : 58,
              leading: isOnboarding
                  ? const SizedBox.shrink()
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(left: isWide ? 16 : 8),
                        width: isWide ? 46 : 40,
                        height: isWide ? 46 : 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: isWide ? 26 : 22,
                          icon: Icon(Icons.arrow_back_rounded, color: gradient.first),
                          tooltip: 'Geri Dön',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.55),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.40),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: const Color(0xFF00D2FF).withValues(alpha: 0.30),
                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: isWide ? 90 : 80,
                          height: isWide ? 90 : 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: isWide ? 90 : 80,
                              height: isWide ? 90 : 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(isWide ? 32.0 : 20.0, 0, 20.0, isWide ? 28.0 : 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 10, vertical: isWide ? 6 : 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Ders İçerikleri',
                              style: GoogleFonts.inter(
                                fontSize: isWide ? 15 : 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$grade. Sınıf',
                            style: GoogleFonts.outfit(
                              fontSize: isWide ? 38 : 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Alana Ait Meslek Dersleri',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 19 : 15,
                              color: Colors.white.withValues(alpha: 0.85),
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

          // ── Dersler Listesi (Ekranı tam kullanan, sola dayalı) ──
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 36.0 : AppSizes.screenPadding,
              vertical: isWide ? 26.0 : AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(context, course, index, isWide);
                },
                childCount: courses.length,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // ══════════════════════════════════════════
  //  DERS KARTI TASARIMI
  // ══════════════════════════════════════════
  Widget _buildCourseCard(BuildContext context, Course course, int index, bool isWide) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        key: index == 0 ? ShellKeys.courseCardKey : null,
        margin: EdgeInsets.only(bottom: isWide ? 22.0 : AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(isWide ? 24 : AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySeed.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWide ? 24 : AppSizes.radiusLg),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  FadePageRoute(
                    child: CourseDetailScreen(
                      grade: grade,
                      courseTitle: course.title,
                      gradient: gradient,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32.0 : AppSizes.md,
                  vertical: isWide ? 26.0 : AppSizes.md,
                ),
                child: Row(
                  children: [
                    // Sol: Ders İkon Kutusu
                    Container(
                      width: isWide ? 76 : 52,
                      height: isWide ? 76 : 52,
                      decoration: BoxDecoration(
                        color: gradient.first.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(isWide ? 20 : 12),
                      ),
                      child: Icon(
                        course.icon,
                        color: gradient.first,
                        size: isWide ? 38 : 26,
                      ),
                    ),
                    SizedBox(width: isWide ? 24 : 16),

                    // Orta: Ders Başlığı ve Detayı
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: GoogleFonts.outfit(
                              fontSize: isWide ? 26 : 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            course.learningUnits.isEmpty
                                ? (course.title == 'Ön Büro Hizmetleri Atölyesi'
                                    ? 'Ders Bilgilendirmesi'
                                    : 'İçerik Güncelleniyor')
                                : '${course.learningUnits.length} Öğrenme Birimi',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 18 : 13.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sağ: İlerleme Oku
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: isWide ? 26 : 16,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
