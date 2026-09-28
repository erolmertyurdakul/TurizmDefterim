import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/scenario_provider.dart';
import '../../domain/models/scenario_models.dart';
import 'scenario_report_screen.dart';
import '../../../../core/utils/fade_page_route.dart';
import '../../../../core/providers/points_provider.dart';

class ScenarioGameScreen extends ConsumerStatefulWidget {
  const ScenarioGameScreen({super.key});

  @override
  ConsumerState<ScenarioGameScreen> createState() => _ScenarioGameScreenState();
}

class _ScenarioGameScreenState extends ConsumerState<ScenarioGameScreen> with SingleTickerProviderStateMixin {
  bool isFeedbackOpen = false;
  late AnimationController _panelController;
  late Animation<Offset> _panelOffsetAnimation;
  Timer? _timePointsTimer;

  @override
  void initState() {
    super.initState();
    _timePointsTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        ref.read(pointsProvider.notifier).addReadingPoints();
      }
    });
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _panelOffsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _timePointsTimer?.cancel();
    _panelController.dispose();
    super.dispose();
  }

  void _showFeedback() {
    setState(() {
      isFeedbackOpen = true;
    });
    _panelController.forward();
  }

  void _hideFeedback() {
    _panelController.reverse().then((_) {
      setState(() {
        isFeedbackOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scenarioProvider);
    final currentStep = state.currentStep;
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 768;

    if (state.currentScenario == null || currentStep == null && !state.isFinished) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF071317),
      appBar: AppBar(
        title: Text(
          state.currentScenario!.title,
          style: GoogleFonts.outfit(
            fontSize: isWide ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.white, size: isWide ? 34 : 24),
          tooltip: 'Simülasyondan Çık',
          splashRadius: isWide ? 28 : 22,
          onPressed: () {
            // Confirm quit dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E2F38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text('Simülasyondan Çıkılsın mı?', style: GoogleFonts.outfit(color: Colors.white, fontSize: isWide ? 20 : 16)),
                content: Text(
                  'Mevcut ilerlemeniz silinecektir.',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: isWide ? 16 : 14),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('İptal', style: GoogleFonts.inter(color: Colors.cyanAccent, fontSize: isWide ? 16 : 14)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Exit screen
                    },
                    child: Text('Çık', style: GoogleFonts.inter(color: Colors.redAccent, fontSize: isWide ? 16 : 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFF071317),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF071317),
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Main Game content
                if (currentStep != null)
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isWide ? 1240 : 640),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWide ? 32 : 16,
                              vertical: isWide ? 20 : 12,
                            ),
                            child: isWide
                                ? // ── PC GÖRÜNÜMÜ: Yan Yana Sinematik Stüdyo Vitrini + Karar Alanı ──
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 1. Sol Sütun: Sinematik Büyük Sahne Vitrini (460x540)
                                      _buildPcVisualStage(currentStep, state.currentScenario!.department),
                                      const SizedBox(width: 32),
                                      // 2. Sağ Sütun: Senaryo Durumu + Karar Seçenekleri
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Senaryo Kartı
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(26),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10202B),
                                                borderRadius: BorderRadius.circular(24),
                                                border: Border.all(
                                                  color: Colors.cyanAccent.withValues(alpha: 0.22),
                                                  width: 1.2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.35),
                                                    blurRadius: 18,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                                    decoration: BoxDecoration(
                                                      color: Colors.cyanAccent.withValues(alpha: 0.12),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.35)),
                                                    ),
                                                    child: Text(
                                                      currentStep.title,
                                                      style: GoogleFonts.outfit(
                                                        color: Colors.cyanAccent,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    currentStep.story,
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      height: 1.6,
                                                      letterSpacing: 0.2,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 22),
                                            // Kararını Ver Başlığı
                                            Row(
                                              children: [
                                                const Icon(Icons.psychology_rounded, color: Colors.cyanAccent, size: 22),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'KARARINI VER • NE YAPMALISIN?',
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.cyanAccent,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Container(
                                                    height: 1,
                                                    color: Colors.cyanAccent.withValues(alpha: 0.2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            // Seçenekler
                                            ...currentStep.options.asMap().entries.map((entry) {
                                              return _buildOptionCard(
                                                context: context,
                                                option: entry.value,
                                                index: entry.key,
                                                isWide: true,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : // ── MOBİL GÖRÜNÜMÜ: Akıcı, Bütünleşik Sinematik Akış ──
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 1. Üst Sinematik Görsel
                                      Container(
                                        height: 230,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F1E2E),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.45),
                                              blurRadius: 14,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.asset(
                                                currentStep.imageUrl,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                errorBuilder: (_, __, ___) => const SizedBox(),
                                              ),
                                              BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                                child: Container(
                                                  color: const Color(0xFF071317).withValues(alpha: 0.52),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: Image.asset(
                                                    currentStep.imageUrl,
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.center,
                                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.white24,
                                                      size: 44,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Alt gölge
                                              Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                height: 40,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.transparent,
                                                        const Color(0xFF071317).withValues(alpha: 0.6),
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Departman Rozeti
                                              Positioned(
                                                top: 12,
                                                left: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF0284C7).withValues(alpha: 0.9),
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                                  ),
                                                  child: Text(
                                                    state.currentScenario!.department,
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Canlı Vaka Rozeti
                                              Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.65),
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 6,
                                                        height: 6,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.cyanAccent,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        'CANLI VAKA',
                                                        style: GoogleFonts.inter(
                                                          color: Colors.cyanAccent,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w800,
                                                          letterSpacing: 0.6,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // 2. Senaryo Kartı
                                      Container(
                                        padding: const EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10202B),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.2)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.3),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.cyanAccent.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                                              ),
                                              child: Text(
                                                currentStep.title,
                                                style: GoogleFonts.outfit(
                                                  color: Colors.cyanAccent,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              currentStep.story,
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 15,
                                                height: 1.55,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // 3. Kararını Ver Başlığı
                                      Row(
                                        children: [
                                          const Icon(Icons.psychology_rounded, color: Colors.cyanAccent, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            'KARARINI VER • NE YAPMALISIN?',
                                            style: GoogleFonts.outfit(
                                              color: Colors.cyanAccent,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: Colors.cyanAccent.withValues(alpha: 0.2),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // 4. Karar Seçenekleri
                                      ...currentStep.options.asMap().entries.map((entry) {
                                        return _buildOptionCard(
                                          context: context,
                                          option: entry.value,
                                          index: entry.key,
                                          isWide: false,
                                        );
                                      }),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Sliding Erol Hoca Feedback Panel
          if (isFeedbackOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {}, // Blocks tap events behind
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),

          SlideTransition(
            position: _panelOffsetAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildErolHocaPanel(context, state, isWide),
            ),
          ),
        ],
      ),
    );
  }

  // ── PC İçin Büyük Sinematik Sahne Vitrini ──
  Widget _buildPcVisualStage(ScenarioStep currentStep, String department) {
    return Container(
      width: 460,
      height: 540,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1E2E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Ambiyans Bulanık Arka Plan
            Image.asset(
              currentStep.imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: const Color(0xFF071317).withValues(alpha: 0.5),
              ),
            ),
            // 2. Net Merkez Görsel
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Image.asset(
                  currentStep.imageUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.white24,
                    size: 60,
                  ),
                ),
              ),
            ),
            // 3. Alt Yumuşak Gradyan
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF071317).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // 4. Departman Rozeti (Sol Üst)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hotel_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      department,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 5. Canlı Vaka Durum Rozeti (Sağ Üst)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.cyanAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'CANLI VAKA',
                      style: GoogleFonts.inter(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
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

  // ── Karar Seçenek Kartı (A / B Harf Rozetli, Etkileşimli ve Işıltılı) ──
  Widget _buildOptionCard({
    required BuildContext context,
    required ScenarioOption option,
    required int index,
    required bool isWide,
  }) {
    final letters = ['A', 'B', 'C', 'D'];
    final letter = index < letters.length ? letters[index] : '${index + 1}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFeedbackOpen
              ? null
              : () {
                  ref.read(scenarioProvider.notifier).selectOption(option);
                  _showFeedback();
                },
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.cyanAccent.withValues(alpha: 0.15),
          highlightColor: Colors.cyanAccent.withValues(alpha: 0.08),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 20.0 : 16.0,
              vertical: isWide ? 16.0 : 14.0,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF132330),
                  Color(0xFF0F1E29),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.cyanAccent.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Seçenek Harf Rozeti (A / B)
                Container(
                  width: isWide ? 36 : 30,
                  height: isWide ? 36 : 30,
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.cyanAccent.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: GoogleFonts.outfit(
                        color: Colors.cyanAccent,
                        fontSize: isWide ? 15 : 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Seçenek Metni
                Expanded(
                  child: Text(
                    option.text,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: isWide ? 16.0 : 14.5,
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // İleri Oku
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.cyanAccent,
                    size: isWide ? 15 : 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Slide-up Erol Hoca Feedback UI
  Widget _buildErolHocaPanel(BuildContext context, ScenarioState state, bool isWide) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 860 : double.infinity),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isWide ? 32 : 24),
          decoration: BoxDecoration(
            color: const Color(0xFF14242C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isWide ? 36 : 32),
              topRight: Radius.circular(isWide ? 36 : 32),
            ),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.05),
                blurRadius: 25,
                spreadRadius: 5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Erol Hoca Character
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isWide ? 12 : 10),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '⚓',
                      style: TextStyle(fontSize: isWide ? 30 : 26),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Operasyonel Analiz',
                    style: GoogleFonts.outfit(
                      color: Colors.cyanAccent,
                      fontSize: isWide ? 19 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isWide ? 22 : 18),

              // Feedback message
              Container(
                padding: EdgeInsets.all(isWide ? 22 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(isWide ? 20 : 16),
                ),
                child: Text(
                  _cleanFeedbackText(state.lastOptionFeedback),
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: isWide ? 17 : 13,
                    height: 1.6,
                  ),
                ),
              ),
              SizedBox(height: isWide ? 28 : 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: isWide ? 58 : 50,
                child: ElevatedButton(
                  onPressed: () {
                    _hideFeedback();
                    if (state.isFinished) {
                      // Navigate to report
                      Navigator.of(context).pushReplacement(
                        FadePageRoute(
                          child: const ScenarioReportScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isFinished ? Colors.cyanAccent : Colors.white10,
                    foregroundColor: state.isFinished ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isWide ? 18 : 14),
                      side: state.isFinished
                          ? BorderSide.none
                          : BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.isFinished ? 'Değerlendirme Raporunu Gör' : 'Bir Sonraki Aşamaya Geç',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: isWide ? 18 : 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        state.isFinished ? Icons.analytics_outlined : Icons.arrow_forward_rounded,
                        size: isWide ? 22 : 18,
                      ),
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

  /// Geri bildirim metinlerini resmi ve pedagojik hale getiren filtre
  String _cleanFeedbackText(String? text) {
    if (text == null) return '';
    String result = text;
    
    // "Erol Hoca Analizi:" ön ekini temizle
    if (result.startsWith('Erol Hoca Analizi:')) {
      result = result.replaceFirst('Erol Hoca Analizi:', '').trim();
    }
    
    // Tırnak işaretlerini kaldır
    if (result.startsWith('"') && result.endsWith('"')) {
      result = result.substring(1, result.length - 1);
    } else if (result.startsWith('“') && result.endsWith('”')) {
      result = result.substring(1, result.length - 1);
    }
    
    // Kelimeleri resmi ve pedagojik hale getir
    return result
        .replaceAll('evlat!', 'genç meslektaşım!')
        .replaceAll('evlat.', 'genç meslektaşım.')
        .replaceAll(' evlat', ' genç meslektaşım')
        .replaceAll('evlat ', 'genç meslektaşım ')
        .replaceAll('evlat', 'genç meslektaşım')
        .replaceAll('öğrencim!', 'öğrencimiz!')
        .replaceAll('öğrencim.', 'öğrencimiz.')
        .replaceAll(' öğrencim', ' öğrencimiz')
        .replaceAll('öğrencim ', 'öğrencimiz ')
        .replaceAll('öğrencim', 'öğrencimiz')
        .replaceAll('Aferin', 'Tebrikler')
        .replaceAll('Korkunç', 'Son derece uygunsuz')
        .replaceAll('çöküş', 'yaklaşım')
        .replaceAll('oteli batırdın', 'işletmeye zarar verdiniz');
  }
}
