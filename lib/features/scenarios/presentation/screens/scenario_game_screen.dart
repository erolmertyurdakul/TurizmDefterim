import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scenario_provider.dart';
import 'scenario_report_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

class ScenarioGameScreen extends ConsumerStatefulWidget {
  const ScenarioGameScreen({super.key});

  @override
  ConsumerState<ScenarioGameScreen> createState() => _ScenarioGameScreenState();
}

class _ScenarioGameScreenState extends ConsumerState<ScenarioGameScreen> with SingleTickerProviderStateMixin {
  bool isFeedbackOpen = false;
  late AnimationController _panelController;
  late Animation<Offset> _panelOffsetAnimation;

  @override
  void initState() {
    super.initState();
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

    if (state.currentScenario == null || currentStep == null && !state.isFinished) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          state.currentScenario!.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white70),
          onPressed: () {
            // Confirm quit dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E2F38),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text('Simülasyondan Çıkılsın mı?', style: TextStyle(color: Colors.white)),
                content: const Text(
                  'Mevcut ilerlemeniz ve canlı KPI durumlarınız silinecektir.',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('İptal', style: TextStyle(color: Colors.cyanAccent)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Exit screen
                    },
                    child: const Text('Çık', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
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
                _buildKPIMeters(state),
                const SizedBox(height: 10),

                // Main Game content
                if (currentStep != null)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Story Image Card
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Image.asset(
                                  currentStep.imageUrl,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.white10,
                                    child: const Icon(Icons.broken_image, color: Colors.white24, size: 50),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Step Title & Story Box
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStep.title,
                                  style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentStep.story,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Deceptive Choices (Buttons)
                          Column(
                            children: currentStep.options.map((option) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: isFeedbackOpen
                                      ? null
                                      : () {
                                          ref.read(scenarioProvider.notifier).selectOption(option);
                                          _showFeedback();
                                        },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.cyanAccent.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.text,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.cyanAccent,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 30),
                        ],
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
              child: _buildErolHocaPanel(context, state),
            ),
          ),
        ],
      ),
    );
  }

  // Real-time KPI Status Bars
  Widget _buildKPIMeters(ScenarioState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSingleKPI('Misafir Memnuniyeti', state.satisfaction, '%', Colors.pinkAccent, Icons.favorite_rounded)),
              const SizedBox(width: 16),
              Expanded(child: _buildSingleKPI('Otel Bütçesi', state.budget, '\$', Colors.greenAccent, Icons.account_balance_wallet_rounded, maxVal: 1000)),
            ],
          ),
          const SizedBox(height: 10),
          _buildSingleKPI('Otel İtibarı', state.reputation, '%', Colors.amberAccent, Icons.verified_user_rounded),
        ],
      ),
    );
  }

  Widget _buildSingleKPI(String title, int value, String unit, Color color, IconData icon, {int maxVal = 100}) {
    final ratio = (value / maxVal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 14),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '$value$unit',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }

  // Slide-up Erol Hoca Feedback UI
  Widget _buildErolHocaPanel(BuildContext context, ScenarioState state) {
    final hasNext = state.currentStep != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14242C),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '⚓',
                  style: TextStyle(fontSize: 26),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Erol Hoca Operasyonel Analiz',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sektörel Tecrübe & Gerçekçi Fatura',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Feedback message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              state.lastOptionFeedback ?? '',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 50,
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
                  borderRadius: BorderRadius.circular(14),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    state.isFinished ? Icons.analytics_outlined : Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
