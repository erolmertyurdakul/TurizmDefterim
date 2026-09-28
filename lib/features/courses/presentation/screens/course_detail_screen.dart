import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/lecture_notes.dart';
import '../../data/models/learning_unit_model.dart';
import '../../providers/course_provider.dart';
import 'lecture_notes_screen_new.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../../../core/utils/fade_page_route.dart';
import '../../../notes/presentation/screens/student_notes_screen.dart';
import '../../../notes/presentation/providers/notes_provider.dart';

String _getCourseId(String title, String grade) {
  if (title == 'Kat Hizmetleri Atölyesi') {
    return '${grade}_kat_hizmetleri_atolyesi';
  }
  switch (title) {
    case 'Ön Büro Hizmetleri Atölyesi': return 'on_buro_hizmetleri_atolyesi';
    case 'Ön Büroda Rezervasyon': return 'on_buro_rezervasyon';
    case 'Konuk Giriş Çıkış İşlemleri': return 'konuk_giris_cikis_islemleri';
    case 'Konaklama İşletmeciliği': return 'konaklama_isletmeciligi';
    case 'Sürdürülebilir Turizm': return 'surdurulebilir_turizm';
    case 'Alternatif Turizm': return 'alternatif_turizm';
    case 'Kuru Temizleme İşlemleri': return 'kuru_temizleme_islemleri';
    case 'Çamaşırhane İşlemleri': return 'camasirhane_islemleri';
    case 'Dünya Seyahat ve Turizm Coğrafyası': return 'dunya_seyahat_ve_turizm_cografyasi';
    case 'Dünya Kültürleri': return 'dunya_kulturleri';
    case 'Kongre ve Etkinlik Turizmi': return 'kongre_ve_etkinlik_turizmi';
    case 'Gastronomi Turizmi': return 'gastronomi_turizmi';
    case 'Tur Operasyonu': return 'tur_operasyonu';
    case 'Transfer Operasyonu': return 'transfer_operasyonu';
    case 'Sosyal Medya': return 'sosyal_medya';
    case 'Mesleki Gelişim Atölyesi': return 'mesleki_gelisim_atolyesi';
    case 'Genel Turizm': return 'genel_turizm';
    case 'Otelcilik ve Seyahat Hizmetleri': return 'otelcilik_ve_seyahat_hizmetleri';
    default:
      return title.toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u')
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g');
  }
}

class CourseDetailScreen extends ConsumerWidget {
  final String grade;
  final String courseTitle;
  final List<Color> gradient;

  const CourseDetailScreen({
    super.key,
    required this.grade,
    required this.courseTitle,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Seçilen sınıfa ait dersleri çek
    final courses = ref.watch(coursesProvider(grade));
    // Başlığa eşleşen dersi bul, bulamazsan ilk dersi al
    final course = courses.firstWhere(
      (c) => c.title == courseTitle,
      orElse: () => courses.first,
    );
    final units = course.learningUnits;
    final isOnboarding = ref.watch(isOnboardingActiveProvider);
    final isWide = MediaQuery.of(context).size.width >= 768;

    return PopScope(
      canPop: !isOnboarding,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Dinamik Header & AppBar ──
            SliverAppBar(
              expandedHeight: isWide ? 220 : 180,
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
                          width: isWide ? 96 : 80,
                          height: isWide ? 96 : 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: isWide ? 96 : 80,
                              height: isWide ? 96 : 80,
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
                              '$grade. Sınıf Dersi',
                              style: GoogleFonts.inter(
                                fontSize: isWide ? 15 : 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            courseTitle,
                            style: GoogleFonts.outfit(
                              fontSize: isWide ? 38 : 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ders Öğrenme Birimleri ve İçerikleri',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 19 : 14,
                              color: Colors.white.withValues(alpha: 0.9),
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

          // ── Hızlı Erişim Butonları: Ders Testleri & Not Defterim (Yan Yana & Sabit Renkler) ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isWide ? 36.0 : AppSizes.screenPadding,
                isWide ? 20.0 : 14.0,
                isWide ? 36.0 : AppSizes.screenPadding,
                0,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  final courseId = _getCourseId(courseTitle, grade);
                  final noteCount = ref.watch(courseNoteCountProvider(courseId));
                  final hasQuiz = allQuizQuestions.any((q) => q.courseId == courseId);

                  // 1. Ders Testleri Kartı (Sabit Kraliyet İndigo / Gece Mavisi Teması)
                  Widget buildQuizCard() {
                    return GestureDetector(
                      key: ShellKeys.generalQuizKey,
                      onTap: () {
                        final courseQuestions = allQuizQuestions
                            .where((q) => q.courseId == courseId)
                            .toList();

                        final Map<int, List<QuizQuestion>> questionsByUnit = {};
                        for (final q in courseQuestions) {
                          questionsByUnit.putIfAbsent(q.unitIndex, () => []).add(q);
                        }

                        for (final unitList in questionsByUnit.values) {
                          unitList.shuffle();
                        }

                        final List<QuizQuestion> selectedQuestions = [];
                        final List<int> sortedUnitIndices = questionsByUnit.keys.toList()..sort();

                        if (sortedUnitIndices.isNotEmpty) {
                          int indexPointer = 0;
                          while (selectedQuestions.length < 8) {
                            bool anyQuestionsLeft = false;
                            for (final list in questionsByUnit.values) {
                              if (list.isNotEmpty) {
                                anyQuestionsLeft = true;
                                break;
                              }
                            }
                            if (!anyQuestionsLeft) break;

                            final currentUnitIndex = sortedUnitIndices[indexPointer % sortedUnitIndices.length];
                            final currentUnitList = questionsByUnit[currentUnitIndex];
                            if (currentUnitList != null && currentUnitList.isNotEmpty) {
                              selectedQuestions.add(currentUnitList.removeAt(0));
                            }
                            indexPointer++;
                          }
                        }

                        if (selectedQuestions.isNotEmpty) {
                          Navigator.push(
                            context,
                            FadePageRoute(
                              child: QuizScreen(
                                title: '$courseTitle - Ders Testi',
                                gradient: gradient,
                                questions: selectedQuestions,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(isWide ? 16 : 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4338CA).withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.18),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.asset(
                                      'assets/images/app_logo.png',
                                      width: isWide ? 26 : 22,
                                      height: isWide ? 26 : 22,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  size: isWide ? 26 : 22,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ders Testleri',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 17.5 : 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '8 Soruluk Test',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 12.5 : 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.88),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 2. Not Defterim Kartı (Sabit Sıcak Kehribar / Amber Teması)
                  Widget buildNotesCard() {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          FadePageRoute(
                            child: StudentNotesScreen(
                              initialGrade: grade,
                              initialCourseId: courseId,
                              initialCourseTitle: courseTitle,
                              gradient: gradient,
                              entrySource: NotesEntrySource.courseDetail,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(isWide ? 16 : 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD97706).withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                    size: isWide ? 22 : 18,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    noteCount > 0 ? '$noteCount Not' : 'Not Al',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 11 : 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Not Defterim',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 17.5 : 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  noteCount > 0 ? 'Notları İncele' : 'Ders Notu Ekle',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 12.5 : 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.88),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (hasQuiz) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: buildQuizCard()),
                          SizedBox(width: isWide ? 16 : 11),
                          Expanded(child: buildNotesCard()),
                        ],
                      ),
                    );
                  } else {
                    return buildNotesCard();
                  }
                },
              ),
            ),
          ),
          if (units.isEmpty)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 24.0 : AppSizes.screenPadding,
                vertical: AppSizes.xl,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1020),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: isWide ? 36 : 24, vertical: isWide ? 48 : 36),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A192F).withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.first.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isWide ? 26 : 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gradient.first.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: gradient.first.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gradient.first.withValues(alpha: 0.2),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  courseTitle == 'Ön Büro Hizmetleri Atölyesi'
                                      ? Icons.menu_book_rounded
                                      : Icons.update_rounded,
                                  color: gradient.first,
                                  size: isWide ? 56 : 44,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                courseTitle == 'Ön Büro Hizmetleri Atölyesi'
                                    ? 'Ders Bilgilendirmesi'
                                    : 'Ders içerikleriniz güncellenmektedir.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: isWide ? 24 : 19,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                courseTitle == 'Ön Büro Hizmetleri Atölyesi'
                                    ? 'Bu derse ilişkin eğitim videoları, ders kitabınızda otel otomasyon programı olarak öğrendiğiniz ElektraWeb uygulamasının resmi web sitesinde hali hazırda bulunmaktadır. Kitabınızdan ya da kitabınızdaki uygulamanın resmi web sitesinden öğrenmeye devam edebilirsiniz.'
                                    : 'Müfredatla uyumlu zengin içerik ve öğrenme birimleri hazırlanmaktadır.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: isWide ? 17 : 13.5,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 36.0 : AppSizes.screenPadding,
                vertical: isWide ? 20.0 : AppSizes.lg,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final unit = units[index];
                    return _buildUnitCard(context, unit, index, isWide);
                  },
                  childCount: units.length,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

  // ══════════════════════════════════════════
  //  ÖĞRENME BİRİMİ KART TASARIMI
  // ══════════════════════════════════════════
  Widget _buildUnitCard(BuildContext context, LearningUnit unit, int index, bool isWide) {
    final notes = allCoursesNotes['$grade-$courseTitle'] ?? allCoursesNotes[courseTitle];
    final unitData = (notes != null && index < notes.length) ? notes[index] : null;

    int noteCount = 0;
    int cardCount = 0;

    if (unitData != null && unitData['cards'] is List) {
      final cardsList = unitData['cards'] as List;
      cardCount = cardsList.length; // Ana açılır kart sayısı (Örn: 9 Kart)
      int totalNotes = 0;
      for (var c in cardsList) {
        if (c is Map) {
          // 1. Mikro Özet
          if (c['microSummary'] != null && c['microSummary'].toString().trim().isNotEmpty) {
            totalNotes += 1;
          }
          // 2. Tanım ve Terim Notları
          if (c['definitions'] is List) {
            totalNotes += (c['definitions'] as List).length;
          }
          // 3. Özel Ek Detay Notları (Yatak Tipleri vb.)
          if (c['extraDetails'] is List) {
            totalNotes += (c['extraDetails'] as List).length;
          }
          // 4. Sektörden Vaka Notu
          if (c['caseStudy'] != null && c['caseStudy'].toString().trim().isNotEmpty) {
            totalNotes += 1;
          }
          // 5. Bilgi Köşesi / Püf Noktası / İpucu Notu
          if (c['tip'] != null && c['tip'].toString().trim().isNotEmpty) {
            totalNotes += 1;
          }
        } else {
          totalNotes += 1;
        }
      }
      noteCount = totalNotes; // Tüm eğitici içerik maddeleri (Örn: 56 Ders Notu)
    } else {
      cardCount = unit.lessonCount;
      noteCount = unit.lessonCount * 5;
    }

    return RepaintBoundary(
      child: Container(
        key: index == 0 ? ShellKeys.unitCardKey : null,
        margin: EdgeInsets.only(bottom: isWide ? 20.0 : AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(isWide ? 22 : AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySeed.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isWide ? 22 : AppSizes.radiusLg),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final notes = allCoursesNotes['$grade-$courseTitle'] ?? allCoursesNotes[courseTitle];
                if (notes != null && index < notes.length) {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      child: LectureNotesScreen(
                        data: notes[index],
                        gradient: gradient,
                        courseId: _getCourseId(courseTitle, grade),
                      ),
                    ),
                  );
                } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${unit.title} ders notları yakında eklenecektir!',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: gradient.first,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.all(isWide ? 24.0 : AppSizes.md),
              child: Row(
                children: [
                  // Sol taraf: Kıvrımlı Öğrenme Birimi Numarası
                  Container(
                    width: isWide ? 70 : 54,
                    height: isWide ? 70 : 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gradient.first.withValues(alpha: 0.15),
                          gradient.last.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isWide ? 20 : 14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '0${index + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 25 : 20,
                        fontWeight: FontWeight.w800,
                        color: gradient.first,
                      ),
                    ),
                  ),
                  SizedBox(width: isWide ? 22 : 16),

                  // Orta: Öğrenme Birimi Başlıkları
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ÖĞRENME BİRİMİ',
                          style: GoogleFonts.inter(
                            fontSize: isWide ? 15 : 11,
                            fontWeight: FontWeight.w700,
                            color: gradient.first,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          unit.title,
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 23 : 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        SizedBox(height: isWide ? 10 : 6),
                        // Kartlar (Solda) ve Ders Notu (Sağda)
                        Row(
                          children: [
                            Icon(
                              Icons.style_rounded,
                              size: isWide ? 18 : 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$cardCount Kart',
                              style: GoogleFonts.inter(
                                fontSize: isWide ? 16 : 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: isWide ? 20 : 12),
                            Icon(
                              Icons.description_outlined,
                              size: isWide ? 18 : 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$noteCount Ders Notu',
                              style: GoogleFonts.inter(
                                fontSize: isWide ? 16 : 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, _) {
                                final cId = _getCourseId(courseTitle, grade);
                                final uNoteCount = ref.watch(unitNoteCountProvider((courseId: cId, unitIndex: index)));
                                if (uNoteCount <= 0) return const SizedBox.shrink();
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: isWide ? 16 : 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: gradient.first.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: gradient.first.withValues(alpha: 0.28),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.edit_note_rounded, size: 13, color: gradient.first),
                                          const SizedBox(width: 3),
                                          Text(
                                            '$uNoteCount Not',
                                            style: GoogleFonts.inter(
                                              fontSize: isWide ? 12 : 10.5,
                                              fontWeight: FontWeight.w700,
                                              color: gradient.first,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sağ taraf: Ok
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: isWide ? 20 : 14,
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
