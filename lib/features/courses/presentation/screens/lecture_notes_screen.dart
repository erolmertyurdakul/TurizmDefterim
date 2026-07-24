import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/lecture_notes.dart';

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/data/quiz_data.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import '../../../../core/services/podcast_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../../badges/providers/badge_provider.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../../../core/presentation/widgets/podcast_speed_control.dart';

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

  Widget _buildSeekBar(BuildContext context) {
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
                trackHeight: 3.0,
                thumbColor: Colors.cyanAccent,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayColor: Colors.cyanAccent.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
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
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: GoogleFonts.inter(
                      fontSize: 10,
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

  Widget _buildPodcastPanel(String podcastUrl, List<Color> gradient) {
    return StreamBuilder<PlayerState>(
      stream: PodcastService().player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isCurrent = PodcastService().currentUrl == podcastUrl;
        final playing = isCurrent && (playerState?.playing ?? false);

        final isLoading = isCurrent && PodcastService().isBuffering;

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.sm,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0A192F).withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
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
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Sol Kısım: Kulaklık İkonu
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: const Icon(
                            Icons.headset_mic_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Ses dalgası animasyonu
                        _SoundWaveVisualizer(
                          isPlaying: playing,
                          color: Colors.cyanAccent,
                        ),
                        const SizedBox(width: 10),
                        // Orta Kısım: Metin
                        Expanded(
                          child: Text(
                            "Podcast'le Öğren",
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // Hız Kontrolü
                        PodcastSpeedControl(targetAlignKey: ShellKeys.podcastKey),
                        const SizedBox(width: 6),
                        // Sağ Kısım: Oynat/Durdur Butonu
                        isLoading
                            ? const SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    if (playing)
                                      BoxShadow(
                                        color: Colors.cyanAccent.withOpacity(0.3),
                                        blurRadius: 8,
                                      ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: playing ? Colors.cyanAccent : Colors.white,
                                    size: 24,
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
                      _buildSeekBar(context),
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

    final isOnboarding = ref.watch(isOnboardingActiveProvider);

    return PopScope(
      canPop: !isOnboarding,
      child: Scaffold(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.screenPadding,
                      vertical: AppSizes.md,
                    ),
                    child: Row(
                      children: [
                        if (!isOnboarding)
                          Container(
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
                              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        if (!isOnboarding)
                          const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              learningUnit.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: widget.gradient.first,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── STICKY PODCAST CONTROL PANEL ──
                if (podcastUrl != null)
                  _buildPodcastPanel(podcastUrl, widget.gradient),

                Expanded(
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
                              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                              child: Row(
                                children: [
                                  Icon(Icons.style_rounded, size: 16, color: widget.gradient.first),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${cards.length} Çalışma Kartı',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: widget.gradient.first.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Aşağı Kaydır ↓',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: widget.gradient.first,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),
                          ],
                        );
                      }

                      // Kartlar
                      final idx = index - 1;
                      final card = cards[idx];
                      return RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                          child: _StudyCardWidget(
                            key: idx == 0 ? ShellKeys.studyCardKey : null,
                            card: card,
                            cardIndex: idx,
                            totalCards: cards.length,
                            gradient: widget.gradient,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        icon: Icon(Icons.quiz_rounded, color: widget.gradient.first),
        label: Text(
          'Ünite Sınavına Gir',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            color: widget.gradient.first,
          ),
        ),
      ),
    ),
  );
}
}

// ══════════════════════════════════════════
//  MODERN GLASSMORPHIC ÇALIŞMA KARTI
// ══════════════════════════════════════════
class _StudyCardWidget extends StatelessWidget {
  final Map<String, dynamic> card;
  final int cardIndex;
  final int totalCards;
  final List<Color> gradient;

  const _StudyCardWidget({
    super.key,
    required this.card,
    required this.cardIndex,
    required this.totalCards,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final tag = card["tag"] ?? "DERS NOTU";
    final title = card["title"] ?? "";
    final microSummary = card["microSummary"] ?? "";
    final definitions = (card["definitions"] as List? ?? []);
    final extraDetails = (card["extraDetails"] as List? ?? []);
    final caseStudy = card["caseStudy"] ?? "";
    final tip = card["tip"] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(28),
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
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Kart Numarası Başlık Şeridi ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${cardIndex + 1}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'KART ${cardIndex + 1} / $totalCards',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    // 🏷️ Tag Etiketi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 9,
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👑 Kart Başlığı
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primarySeed,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🌸 MİKRO ÖZET (Soft Pastel Rose/Pink Kutusu)
                    if (microSummary.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5), // Pastel Rose
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFC0CB).withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.bolt_rounded, color: Color(0xFFDB7093), size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MİKRO ÖZET',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFDB7093),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    microSummary,
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4A2F3A),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // 📖 TANIMLAR VE DETAYLAR
                    Text(
                      'TANIMLAR VE KAVRAMLAR',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ...definitions.map((item) {
                      final isFirstConcept = cardIndex == 0 && definitions.indexOf(item) == 0;
                      return _ConceptTile(
                        key: isFirstConcept ? ShellKeys.studyCardKey : null,
                        name: item["name"] ?? "",
                        desc: item["desc"] ?? "",
                        examples: (item["examples"] as List? ?? []).map((e) => e.toString()).toList(),
                        gradient: gradient,
                      );
                    }),

                    // ⚡ EXTRA DETAILS
                    if (extraDetails.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      ...extraDetails.map((ext) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
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
                                  const Icon(Icons.menu_book_rounded, color: AppColors.primarySeed, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ext["title"] ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primarySeed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ext["content"] ?? "",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    // 🎬 SEKTÖRDEN VAKA (Derin Lacivert)
                    if (caseStudy.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        key: cardIndex == 0 ? ShellKeys.caseStudyKey : null,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primarySeed,
                          borderRadius: BorderRadius.circular(16),
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
                                const Icon(Icons.theater_comedy_rounded, color: AppColors.accent, size: 22),
                                const SizedBox(width: 10),
                                Text(
                                  'SEKTÖRDEN VAKA',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.accent,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              caseStudy,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // 🧠 BİLGİ KÖŞESİ
                    if (tip.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        key: cardIndex == 0 ? ShellKeys.tipKey : null,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.accent, width: 1.2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.psychology_rounded, color: AppColors.accentWarm, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BİLGİ KÖŞESİ',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.accentWarm,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tip,
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                      height: 1.45,
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

  const _ConceptTile({
    super.key,
    required this.name,
    required this.desc,
    this.examples = const [],
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstConcept = (key == ShellKeys.studyCardKey);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.0),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: isFirstConcept ? ShellKeys.firstConceptController : null,
          iconColor: gradient.first,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (examples.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...examples.map((example) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: gradient.first.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: gradient.first.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb_circle, size: 16, color: gradient.first.withValues(alpha: 0.6)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                example,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                                  height: 1.4,
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
