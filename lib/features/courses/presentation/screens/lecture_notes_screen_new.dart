import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../../../../core/services/podcast_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../../badges/providers/badge_provider.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/presentation/widgets/podcast_speed_control.dart';
import '../../../../core/utils/fade_page_route.dart';
import '../../../notes/presentation/screens/student_notes_screen.dart';
import '../../../notes/presentation/providers/notes_provider.dart';

class LectureNotesScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final List<Color> gradient;
  final String courseId;

  const LectureNotesScreen({
    super.key,
    required this.data,
    required this.gradient,
    required this.courseId,
  });

  @override
  ConsumerState<LectureNotesScreen> createState() => _LectureNotesScreenState();
}

class _LectureNotesScreenState extends ConsumerState<LectureNotesScreen> {
  Timer? _studyTimer;
  double _fontScale = 1.0;

  Widget _buildFontSizeControl(List<Color> gradient, [bool isWide = true]) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 10 : 6,
        vertical: isWide ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWide ? 18 : 14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: isWide ? 1.5 : 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.text_decrease_rounded,
              size: isWide ? 26 : 20,
              color: _fontScale > 0.85 ? AppColors.textPrimary : Colors.grey.shade400,
            ),
            tooltip: 'Yazıyı Küçült (A-)',
            constraints: const BoxConstraints(),
            padding: EdgeInsets.all(isWide ? 9 : 7),
            onPressed: _fontScale > 0.85
                ? () {
                    setState(() {
                      _fontScale = (_fontScale - 0.1).clamp(0.8, 1.8);
                    });
                  }
                : null,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _fontScale = 1.0;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Tooltip(
              message: 'Varsayılan Boyut (%100)',
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 10 : 6,
                  vertical: isWide ? 4 : 3,
                ),
                child: Text(
                  '${(_fontScale * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: isWide ? 16 : 13.5,
                    fontWeight: FontWeight.w800,
                    color: gradient.first,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.text_increase_rounded,
              size: isWide ? 26 : 20,
              color: _fontScale < 1.75 ? AppColors.textPrimary : Colors.grey.shade400,
            ),
            tooltip: 'Yazıyı Büyüt (A+)',
            constraints: const BoxConstraints(),
            padding: EdgeInsets.all(isWide ? 9 : 7),
            onPressed: _fontScale < 1.75
                ? () {
                    setState(() {
                      _fontScale = (_fontScale + 0.1).clamp(0.8, 1.8);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    PodcastService().isNotesScreenActive = true;
    _studyTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      ref.read(pointsProvider.notifier).addReadingPoints();
    });

    // Increment cards read progress for badge system
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cardsCount = (widget.data["cards"] as List? ?? []).length;
        for (var i = 0; i < cardsCount; i++) {
          ref.read(badgeProgressProvider.notifier).incrementCardsRead();
        }
      }
    });
  }

  @override
  void dispose() {
    PodcastService().isNotesScreenActive = false;
    _studyTimer?.cancel();
    super.dispose();
  }

  Widget _buildSeekBar(BuildContext context, bool isWide) {
    final player = PodcastService().player;
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = player.duration ?? Duration.zero;

        // Ensure position does not exceed duration
        final currentPos = position.inMilliseconds > duration.inMilliseconds
            ? duration
            : position;

        return Column(
          children: [
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.cyanAccent,
                inactiveTrackColor: Colors.white24,
                trackHeight: isWide ? 4.0 : 3.0,
                thumbColor: Colors.cyanAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: isWide ? 8.0 : 6.0),
                overlayColor: Colors.cyanAccent.withOpacity(0.2),
                overlayShape: RoundSliderOverlayShape(overlayRadius: isWide ? 15.0 : 12.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(currentPos),
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 12 : 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 12 : 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  String _getCourseTitle(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('mesleki_gelisim')) return 'Mesleki Gelişim Atölyesi';
    if (lowerId.contains('konuk_giris_cikis')) return 'Konuk Giriş Çıkış İşlemleri';
    if (lowerId.contains('kat_hizmetleri')) return 'Kat Hizmetleri';
    if (lowerId.contains('surdurulebilir_turizm')) return 'Sürdürülebilir Turizm';
    if (lowerId.contains('alternatif_turizm')) return 'Alternatif Turizm';
    if (lowerId.contains('camasirhane')) return 'Çamaşırhane İşlemleri';
    if (lowerId.contains('dunya_cografyasi')) return 'Dünya Coğrafyası';
    if (lowerId.contains('dunya_kulturleri')) return 'Dünya Kültürleri';
    if (lowerId.contains('gastronomi')) return 'Gastronomi Turizmi';
    if (lowerId.contains('kongre')) return 'Kongre ve Etkinlik';
    if (lowerId.contains('kuru_temizleme')) return 'Kuru Temizleme İşlemleri';
    if (lowerId.contains('sosyal_medya')) return 'Sosyal Medya';
    if (lowerId.contains('transfer')) return 'Transfer Operasyonu';
    if (lowerId.contains('tur_operasyonu')) return 'Tur Operasyonu';
    return 'Turizm Defterim';
  }

  String _getGradeFromCourseId(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.startsWith('9_') || lowerId.contains('mesleki_gelisim') || lowerId.contains('genel_turizm')) {
      return '9';
    }
    if (lowerId.startsWith('10_') || lowerId.contains('konuk_giris') || lowerId.contains('rezervasyon')) {
      return '10';
    }
    if (lowerId.startsWith('11_') || lowerId.contains('kat_hizmetleri') || lowerId.contains('camasirhane') || lowerId.contains('kuru_temizleme') || lowerId.contains('dunya_kahvalti')) {
      return '11';
    }
    return '12';
  }

  Widget _buildPodcastPanel(String podcastUrl, List<Color> gradient, bool isWide) {
    return StreamBuilder<PlayerState>(
      stream: PodcastService().player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isCurrent = PodcastService().currentUrl == podcastUrl;
        final playing = isCurrent && (playerState?.playing ?? false);

        final isLoading = isCurrent && PodcastService().isBuffering;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isWide ? 36 : AppSizes.screenPadding,
            vertical: isWide ? 12 : AppSizes.sm,
          ),
          width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0A192F).withOpacity(0.65),
                borderRadius: BorderRadius.circular(isWide ? 24 : 20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                key: ShellKeys.podcastKey,
                borderRadius: BorderRadius.circular(isWide ? 24 : 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 22 : 16,
                      vertical: isWide ? 16 : 12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // Sol Kısım: Kulaklık İkonu
                            Container(
                              width: isWide ? 52 : 40,
                              height: isWide ? 52 : 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.15)),
                              ),
                              child: Icon(
                                Icons.headset_mic_rounded,
                                color: Colors.white,
                                size: isWide ? 26 : 20,
                              ),
                            ),
                            SizedBox(width: isWide ? 16 : 10),
                            // Ses dalgası animasyonu
                            _SoundWaveVisualizer(
                              isPlaying: playing,
                              color: Colors.cyanAccent,
                            ),
                            SizedBox(width: isWide ? 16 : 10),
                            // Orta Kısım: Metin
                            Expanded(
                              child: Text(
                                "Podcast'le Öğren",
                                style: GoogleFonts.outfit(
                                  fontSize: isWide ? 20 : 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // Hız Kontrolü
                            PodcastSpeedControl(targetAlignKey: ShellKeys.podcastKey),
                            SizedBox(width: isWide ? 12 : 6),
                            // Sağ Kısım: Oynat/Durdur Butonu
                            isLoading
                                ? SizedBox(
                                    width: isWide ? 44 : 32,
                                    height: isWide ? 44 : 32,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                    ),
                                  )
                                : Container(
                                    width: isWide ? 52 : null,
                                    height: isWide ? 52 : null,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        if (playing)
                                          BoxShadow(
                                            color: Colors.cyanAccent.withOpacity(0.3),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: playing ? Colors.cyanAccent : Colors.white,
                                        size: isWide ? 30 : 24,
                                      ),
                                      onPressed: () {
                                        if (playing) {
                                          PodcastService().pause();
                                        } else {
                                          PodcastService().play(
                                            podcastUrl,
                                            id: podcastUrl,
                                            title: "${widget.data["learningUnit"] ?? "Podcast"}: ${widget.data["title"] ?? ""}",
                                            album: _getCourseTitle(widget.courseId),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                          ],
                        ),
                        if (isCurrent)
                          _buildSeekBar(context, isWide),
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
    final title = widget.data["title"] ?? "Ders Notları";
    final learningUnit = widget.data["learningUnit"] ?? "Öğrenme Birimi";
    final cards = (widget.data["cards"] as List? ?? []);
    final String? podcastUrl = widget.data["podcastUrl"];
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Lüks Arka Plan Küreleri (Pinterest/Apple Havası) ──
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.gradient.first.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.gradient.last.withOpacity(0.1),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── ÜST BAR (Apple Tarzı) ──
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 36 : AppSizes.screenPadding,
                    vertical: isWide ? 16 : AppSizes.md,
                  ),
                      child: Row(
                        children: [
                          Container(
                            width: isWide ? 50 : null,
                            height: isWide ? 50 : null,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.textPrimary,
                                size: isWide ? 26 : 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          SizedBox(width: isWide ? 20 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  learningUnit.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 15 : 11,
                                    fontWeight: FontWeight.w800,
                                    color: widget.gradient.first,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 30 : 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isWide) ...[
                            const SizedBox(width: 16),
                            _buildFontSizeControl(widget.gradient, isWide),
                          ],
                        ],
                      ),
                    ),

                // ── STICKY PODCAST CONTROL PANEL ──
                if (podcastUrl != null && podcastUrl.trim().isNotEmpty)
                  _buildPodcastPanel(podcastUrl, widget.gradient, isWide),

                Expanded(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(isWide ? _fontScale : 1.0),
                    ),
                    child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: cards.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // ── Kart Sayacı ──
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 36 : AppSizes.screenPadding,
                              ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.style_rounded,
                                        size: isWide ? 22 : 16,
                                        color: widget.gradient.first,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${cards.length} Çalışma Kartı',
                                        style: GoogleFonts.inter(
                                          fontSize: isWide ? 17 : 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 16 : 10,
                                          vertical: isWide ? 8 : 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.gradient.first.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Aşağı Kaydır ↓',
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 15 : 11,
                                            fontWeight: FontWeight.w600,
                                            color: widget.gradient.first,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isWide ? 18 : AppSizes.md),
                              ],
                            );
                          }

                      // Kartlar
                      final idx = index - 1;
                      final card = cards[idx];
                      return RepaintBoundary(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 36 : AppSizes.screenPadding,
                          ),
                          child: _StudyCardWidget(
                            key: idx == 0 ? ShellKeys.studyCardKey : null,
                            card: card,
                            cardIndex: idx,
                            totalCards: cards.length,
                            gradient: widget.gradient,
                            isWide: isWide,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, _) {
          int? unitIdx;
          try {
            final match = RegExp(r'(\d+)').firstMatch(learningUnit);
            if (match != null) {
              unitIdx = (int.tryParse(match.group(1)!) ?? 1) - 1;
            }
          } catch (_) {}

          final unitNoteCount = unitIdx != null
              ? ref.watch(unitNoteCountProvider((courseId: widget.courseId, unitIndex: unitIdx)))
              : 0;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ── ÜST FAB: NOT DEFTERİM (Öğrenme Birimi Notları) ──
              FloatingActionButton.extended(
                key: ShellKeys.unitNotesFabKey,
                heroTag: 'unit_notes_fab',
                onPressed: () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      child: StudentNotesScreen(
                        initialGrade: _getGradeFromCourseId(widget.courseId),
                        initialCourseId: widget.courseId,
                        initialCourseTitle: _getCourseTitle(widget.courseId),
                        initialUnitIndex: unitIdx,
                        initialUnitTitle: '$learningUnit: $title',
                        gradient: widget.gradient,
                        entrySource: NotesEntrySource.learningUnit,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.white,
                elevation: 8,
                icon: Icon(
                  Icons.edit_note_rounded,
                  color: const Color(0xFFD97706),
                  size: isWide ? 26 : 22,
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Not Defterim',
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 16 : 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                    if (unitNoteCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unitNoteCount',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── ALT FAB: ÖĞRENME BİRİMİ TESTİ ──
              FloatingActionButton.extended(
                key: ShellKeys.unitQuizFabKey,
                heroTag: 'unit_quiz_fab',
                onPressed: () {
                  try {
                    final unitStr = learningUnit.split('.')[0]; 
                    final unitIdx = int.parse(unitStr) - 1; 
                    
                    final unitQuestions = allQuizQuestions
                        .where((q) => q.courseId == widget.courseId && q.unitIndex == unitIdx)
                        .toList()
                      ..shuffle();
                    
                    final selectedQuestions = unitQuestions.take(5).toList();
                    
                    if (selectedQuestions.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            title: '$learningUnit Sınavı',
                            gradient: widget.gradient,
                            questions: selectedQuestions,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    // parsing error fallback
                  }
                },
                backgroundColor: Colors.white,
                elevation: 8,
                icon: Icon(
                  Icons.quiz_rounded,
                  color: widget.gradient.first,
                  size: isWide ? 26 : 20,
                ),
                label: Text(
                  'Öğrenme Birimi Testi',
                  style: GoogleFonts.inter(
                    fontSize: isWide ? 17.5 : 13,
                    fontWeight: FontWeight.w800,
                    color: widget.gradient.first,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StudyCardWidget extends StatelessWidget {
  final Map<String, dynamic> card;
  final int cardIndex;
  final int totalCards;
  final List<Color> gradient;
  final bool isWide;

  const _StudyCardWidget({
    super.key,
    required this.card,
    required this.cardIndex,
    required this.totalCards,
    required this.gradient,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final tag = card["tag"] ?? "DERS NOTU";
    final title = card["title"] ?? "";
    final microSummary = card["microSummary"] ?? "";
    final definitions = (card["definitions"] as List? ?? []);
    final extraDetails = (card["extraDetails"] as List? ?? []);
    
    // Robust Polymorphic Parsing for caseStudy
    final caseStudyRaw = card["caseStudy"];
    String caseStudy = "";
    if (caseStudyRaw is String) {
      caseStudy = caseStudyRaw;
    } else if (caseStudyRaw is Map) {
      final cTitle = caseStudyRaw["title"] ?? "Örnek Olay";
      final cStory = caseStudyRaw["story"] ?? "";
      final cSolution = caseStudyRaw["solution"] ?? "";
      caseStudy = "$cTitle\n\nOlay: $cStory\n\nÇözüm: $cSolution";
    }

    // Robust Polymorphic Parsing for tip / tips
    final tipRaw = card["tip"] ?? card["tips"];
    String tip = "";
    if (tipRaw is String) {
      tip = tipRaw;
    } else if (tipRaw is List && tipRaw.isNotEmpty) {
      tip = tipRaw.first.toString();
    }

    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(isWide ? 32 : 28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isWide ? 32 : 28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Kart Numarası Başlık Şeridi ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 20,
                  vertical: isWide ? 16 : 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: isWide ? 42 : 32,
                      height: isWide ? 42 : 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(isWide ? 12 : 10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${cardIndex + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: isWide ? 19 : 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: isWide ? 16 : 12),
                    Expanded(
                      child: Text(
                        'KART ${cardIndex + 1} / $totalCards',
                        style: GoogleFonts.inter(
                          fontSize: isWide ? 15 : 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    // 🏷️ Tag Etiketi
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 16 : 10,
                        vertical: isWide ? 6 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: isWide ? 13 : 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Kart İçeriği ──
              Padding(
                padding: EdgeInsets.all(isWide ? 28 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👑 Kart Başlığı
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 28 : 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primarySeed,
                        height: 1.25,
                      ),
                    ),

                    SizedBox(height: isWide ? 22 : 16),

                    // 🌸 MİKRO ÖZET (Soft Pastel Rose/Pink Kutusu)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isWide ? 24 : 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5), // Pastel Rose
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFFC0CB).withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: const Color(0xFFDB7093),
                            size: isWide ? 34 : 24,
                          ),
                          SizedBox(width: isWide ? 16 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MİKRO ÖZET',
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 16 : 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFDB7093),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  microSummary,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 20 : 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4A2F3A),
                                    height: isWide ? 1.7 : 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isWide ? 26 : 20),

                    // 📖 TANIMLAR VE DETAYLAR
                    Text(
                      'TANIMLAR VE KAVRAMLAR',
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 18 : 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: isWide ? 14 : 10),

                    ...definitions.map((item) {
                      final isFirstInCard = definitions.indexOf(item) == 0;
                      final isFirstOfFirstCard = isFirstInCard && (cardIndex == 0);
                      return _ConceptTile(
                        key: isFirstOfFirstCard ? ShellKeys.firstConceptKey : null,
                        name: item["name"] ?? "",
                        desc: item["desc"] ?? "",
                        examples: (item["examples"] as List? ?? []).map((e) => e.toString()).toList(),
                        gradient: gradient,
                        isFirst: isFirstOfFirstCard,
                        isWide: isWide,
                      );
                    }),

                    // ⚡ EXTRA DETAILS
                    if (extraDetails.isNotEmpty) ...[
                      SizedBox(height: isWide ? 26 : 20),
                      ...extraDetails.map((ext) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(isWide ? 24 : 16),
                          decoration: BoxDecoration(
                            color: AppColors.primarySeed.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primarySeed.withValues(alpha: 0.15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_rounded,
                                    color: AppColors.primarySeed,
                                    size: isWide ? 28 : 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      ext["title"] ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: isWide ? 21 : 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primarySeed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ext["content"] ?? "",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                  fontSize: isWide ? 19.5 : 13,
                                  color: AppColors.textSecondary,
                                  height: isWide ? 1.65 : 1.55,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // 🎬 SEKTÖRDEN VAKA (Derin Lacivert)
                    if (caseStudy.isNotEmpty) ...[
                      SizedBox(height: isWide ? 26 : 20),
                      Container(
                        key: cardIndex == 0 ? ShellKeys.caseStudyKey : null,
                        width: double.infinity,
                        padding: EdgeInsets.all(isWide ? 24 : 16),
                        decoration: BoxDecoration(
                          color: AppColors.primarySeed,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primarySeed.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.theater_comedy_rounded,
                                  color: AppColors.accent,
                                  size: isWide ? 30 : 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'SEKTÖRDEN VAKA',
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 19 : 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.accent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              caseStudy,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.inter(
                                fontSize: isWide ? 19.5 : 13,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: isWide ? 1.65 : 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 💡 BİLGİ KÖŞESİ (Altın / Bal Rengi)
                    if (tip.isNotEmpty) ...[
                      SizedBox(height: isWide ? 22 : 16),
                      Container(
                        key: cardIndex == 0 ? ShellKeys.tipKey : null,
                        width: double.infinity,
                        padding: EdgeInsets.all(isWide ? 24 : 16),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.accent, width: 1.4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.psychology_rounded,
                              color: AppColors.accentWarm,
                              size: isWide ? 32 : 24,
                            ),
                            SizedBox(width: isWide ? 16 : 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BİLGİ KÖŞESİ',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 17 : 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.accentWarm,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tip,
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 19.5 : 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      height: isWide ? 1.6 : 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  KAVRAM AKORDEON PANELİ
// ══════════════════════════════════════════
class _ConceptTile extends StatelessWidget {
  final String name;
  final String desc;
  final List<String> examples;
  final List<Color> gradient;
  final bool isFirst;
  final bool isWide;

  const _ConceptTile({
    super.key,
    required this.name,
    required this.desc,
    this.examples = const [],
    required this.gradient,
    this.isFirst = false,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 14 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWide ? 16 : 14),
        border: Border.all(color: AppColors.divider, width: 1.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: isFirst ? ShellKeys.firstConceptController : null,
          iconColor: gradient.first,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: isWide ? 22 : 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isWide ? 24 : 16,
                0,
                isWide ? 24 : 16,
                isWide ? 24 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 19.5 : 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: isWide ? 1.65 : 1.5,
                    ),
                  ),
                  if (examples.isNotEmpty) ...[
                    SizedBox(height: isWide ? 16 : 12),
                    ...examples.map((example) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(isWide ? 18 : 12),
                        decoration: BoxDecoration(
                          color: gradient.first.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: gradient.first.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_circle,
                              size: isWide ? 22 : 16,
                              color: gradient.first.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                example,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                  fontSize: isWide ? 17.5 : 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textSecondary.withValues(alpha: 0.85),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundWaveVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color color;

  const _SoundWaveVisualizer({
    required this.isPlaying,
    required this.color,
  });

  @override
  State<_SoundWaveVisualizer> createState() => _SoundWaveVisualizerState();
}

class _SoundWaveVisualizerState extends State<_SoundWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _barHeights = [10.0, 20.0, 15.0, 25.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _SoundWaveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double height = _barHeights[index];
            if (widget.isPlaying) {
              final val = (index % 2 == 0) ? _controller.value : 1.0 - _controller.value;
              height = 8.0 + (height - 8.0) * val;
            } else {
              height = 6.0;
            }
            return Container(
              width: 3.5,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
