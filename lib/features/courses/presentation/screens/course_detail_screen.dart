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

String _getCourseId(String title, String grade) {
  if (title == 'Kat Hizmetleri Atölyesi') {
    return '${grade}_kat_hizmetleri_atolyesi';
  }
  switch (title) {
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

    return PopScope(
      canPop: !isOnboarding,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Dinamik Header & AppBar ──
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
                              '$grade. Sınıf Dersi',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            courseTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ders Öğrenme Birimleri ve İçerikleri',
                            style: GoogleFonts.inter(
                              fontSize: 13,
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

          // ── Genel Ders Sınavı Kartı ──
          if (allQuizQuestions.any((q) => q.courseId == _getCourseId(courseTitle, grade)))
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.screenPadding, AppSizes.lg, AppSizes.screenPadding, 0),
                child: GestureDetector(
                  onTap: () {
                    final courseQuestions = allQuizQuestions
                        .where((q) => q.courseId == _getCourseId(courseTitle, grade))
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
                  key: ShellKeys.generalQuizKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gradient.first, gradient.last],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                width: 28,
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ders Testlerini Çöz',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '8 soruluk testlerle ders bilgini sınamaya hazır mısın?',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 36),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
              vertical: AppSizes.lg,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final unit = units[index];
                  return _buildUnitCard(context, unit, index);
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
  Widget _buildUnitCard(BuildContext context, LearningUnit unit, int index) {
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
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primarySeed.withValues(alpha: 0.05),
              blurRadius: 10,
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
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  // Sol taraf: Kıvrımlı Öğrenme Birimi Numarası
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gradient.first.withValues(alpha: 0.15),
                          gradient.last.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '0${index + 1}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: gradient.first,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Orta: Öğrenme Birimi Başlıkları
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ÖĞRENME BİRİMİ',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: gradient.first,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          unit.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                        ),
                        const SizedBox(height: 6),
                        // Ders Notu ve Kart Sayısı
                        Row(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$noteCount Ders Notu',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.style_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$cardCount Kart',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sağ taraf: Ok
                  const SizedBox(width: 8),
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
