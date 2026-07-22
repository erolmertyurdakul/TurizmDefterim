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

    return PopScope(
      canPop: !isOnboarding,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Dinamik Header ──
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              stretch: true,
              leading: isOnboarding
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                      right: 12,
                      bottom: 12,
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
                          width: 80,
                          height: 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Ders İçerikleri',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$grade. Sınıf',
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Alana Ait Meslek Dersleri',
                            style: GoogleFonts.inter(
                              fontSize: 14,
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

          // ── Dersler Listesi ──
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final course = courses[index];
                  return _buildCourseCard(context, course, index);
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
  Widget _buildCourseCard(BuildContext context, Course course, int index) {
    return RepaintBoundary(
      child: Container(
        key: index == 0 ? ShellKeys.courseCardKey : null,
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySeed.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  // Sol: Ders İkon Kutusu
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: gradient.first.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      course.icon,
                      color: gradient.first,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Orta: Ders Başlığı ve Detayı
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course.learningUnits.length} Öğrenme Birimi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Sağ: İlerleme Oku
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
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
