import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/world_map_data.dart';
import '../../providers/world_map_game_provider.dart';

class WorldMapQuizScreen extends ConsumerStatefulWidget {
  const WorldMapQuizScreen({super.key});

  @override
  ConsumerState<WorldMapQuizScreen> createState() => _WorldMapQuizScreenState();
}

class _WorldMapQuizScreenState extends ConsumerState<WorldMapQuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(worldMapGameProvider.notifier).startGame();
    });
  }

  void _handleAnswer(MapDestination dest, WorldMapGameNotifier notifier, WorldMapGameState state) {
    final isCorrect = dest.id == state.currentQuestion?.id;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: Curves.elasticOut.transform(value),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: isCorrect ? const Color(0xFF059669).withValues(alpha: 0.95) : const Color(0xFFDC2626).withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isCorrect ? const Color(0xFF059669) : const Color(0xFFDC2626)).withValues(alpha: 0.5),
                          blurRadius: 40,
                          spreadRadius: 15,
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_outline_rounded : Icons.cancel_outlined,
                          color: Colors.white,
                          size: 70,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isCorrect ? 'HARİKA!' : 'YANLIŞ!',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        );
      }
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      Navigator.pop(context);
      notifier.answerQuestion(dest);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(worldMapGameProvider);
    final notifier = ref.read(worldMapGameProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF071317),
      appBar: AppBar(
        title: Text(
          'Dünya Haritası Testi',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            notifier.endGame();
            Navigator.pop(context);
          },
        ),
      ),
      body: gameState.isGameOver
          ? _buildGameOverScreen(gameState, notifier)
          : _buildGameScreen(gameState, notifier),
    );
  }

  Widget _buildGameOverScreen(WorldMapGameState state, WorldMapGameNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 80),
          const SizedBox(height: 20),
          Text(
            'Süre Doldu!',
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Toplam Skor: ${state.score}',
            style: GoogleFonts.inter(fontSize: 24, color: Colors.cyanAccent),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => notifier.startGame(),
            child: Text(
              'Tekrar Oyna',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameScreen(WorldMapGameState state, WorldMapGameNotifier notifier) {
    return Column(
      children: [
        // Top Bar: Score, Combo, Timer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SKOR', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('${state.score}', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '${state.comboMultiplier}x',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.amber),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('SÜRE', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('00:${state.timeLeft.toString().padLeft(2, '0')}', 
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, 
                    color: state.timeLeft <= 10 ? Colors.redAccent : Colors.white)),
                ],
              ),
            ],
          ),
        ),

        // Question
        if (state.currentQuestion != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Text(
                  'Haritada Neresi?',
                  style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Text(
                  state.currentQuestion!.name,
                  style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                if (state.currentHint != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.cyanAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.currentHint!,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),

        // Map Area
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 2),
              color: const Color(0xFF0B1B22),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: Stack(
                      children: [
                        // Map Image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/world_map_game.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Markers
                        ...state.activeOptions.map((dest) {
                          final x = dest.dx * constraints.maxWidth;
                          final y = dest.dy * constraints.maxHeight;
                          
                          return Positioned(
                            left: x - 20, // offset for center
                            top: y - 40,  // offset for bottom pin
                            child: GestureDetector(
                              onTap: () => _handleAnswer(dest, notifier, state),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Text(
                                      dest.name,
                                      style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF6B6B), Color(0xFFDC2626)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent.withValues(alpha: 0.6),
                                          blurRadius: 12,
                                          spreadRadius: 3,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),

        // Lifelines Bottom Bar
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLifeline(
                icon: Icons.exposure_minus_2, 
                label: '50:50', 
                count: state.lifeline5050Count,
                color: Colors.purpleAccent,
                onTap: notifier.use5050,
              ),
              _buildLifeline(
                icon: Icons.lightbulb_outline, 
                label: 'İpucu', 
                count: state.lifelineHintCount,
                color: Colors.amberAccent,
                onTap: notifier.useHint,
              ),
              _buildLifeline(
                icon: Icons.more_time, 
                label: '+15s', 
                count: state.lifelineTimeCount,
                color: Colors.greenAccent,
                onTap: notifier.useExtraTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLifeline({
    required IconData icon, 
    required String label, 
    required int count, 
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isAvailable = count > 0;
    
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.4,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAvailable ? color.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                border: Border.all(color: isAvailable ? color : Colors.grey, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, color: isAvailable ? color : Colors.grey, size: 24),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isAvailable ? Colors.white : Colors.white54, 
                fontSize: 12, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
