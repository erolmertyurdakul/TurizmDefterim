import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../providers/word_search_provider.dart';
import '../../../badges/providers/badge_provider.dart';

class WordSearchScreen extends ConsumerStatefulWidget {
  const WordSearchScreen({super.key});

  @override
  ConsumerState<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends ConsumerState<WordSearchScreen> {
  final GlobalKey _gridKey = GlobalKey();
  double _cellSize = 0;
  final AudioPlayer _sfxPlayer = AudioPlayer();
  Timer? _timePointsTimer;

  @override
  void initState() {
    super.initState();
    _timePointsTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        ref.read(pointsProvider.notifier).addReadingPoints();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wordSearchProvider.notifier).startGame();
    });
  }

  @override
  void dispose() {
    _timePointsTimer?.cancel();
    _sfxPlayer.dispose();
    super.dispose();
  }

  bool get _isMuted => !ref.read(soundSettingsProvider);

  Future<void> _playSFX(bool isCorrect) async {
    if (_isMuted) return;
    try {
      await _sfxPlayer.stop();
      if (isCorrect) {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getCorrectAnswer()));
      } else {
        await _sfxPlayer.play(BytesSource(SfxSynthesizer.getError()));
      }
    } catch (e) {
      debugPrint("Error playing SFX: $e");
    }
  }

  void _handlePanUpdate(DragUpdateDetails details, int gridSize, WordSearchGameNotifier notifier, WordSearchGameState state) {
    if (_cellSize == 0) return;
    
    RenderBox? box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    Offset localPosition = details.localPosition;
    int col = (localPosition.dx / _cellSize).floor();
    int row = (localPosition.dy / _cellSize).floor();

    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      WordPosition pos = WordPosition(row, col);
      
      List<WordPosition> currentSelection = List.from(state.currentSelection);
      if (currentSelection.isEmpty) {
        currentSelection.add(pos);
        notifier.updateSelection(currentSelection);
      } else {
        WordPosition startPos = currentSelection.first;
        
        int dRow = pos.row - startPos.row;
        int dCol = pos.col - startPos.col;
        
        if (dRow == 0 || dCol == 0 || dRow.abs() == dCol.abs()) {
           List<WordPosition> newSelection = [];
           int steps = max(dRow.abs(), dCol.abs());
           if (steps == 0) {
             newSelection.add(startPos);
           } else {
             int stepRow = dRow ~/ steps;
             int stepCol = dCol ~/ steps;
             for (int i = 0; i <= steps; i++) {
               newSelection.add(WordPosition(startPos.row + i * stepRow, startPos.col + i * stepCol));
             }
           }
           notifier.updateSelection(newSelection);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wordSearchProvider);
    final notifier = ref.read(wordSearchProvider.notifier);
    final isSoundOn = ref.watch(soundSettingsProvider);

    // Increment word search completed for badge progress and award +5 XP silently on completion
    ref.listen<WordSearchGameState>(wordSearchProvider, (prev, next) {
      if (prev != null && !prev.isGameOver && next.isGameOver) {
        ref.read(badgeProgressProvider.notifier).incrementWordSearchCompleted();
        // Bulmacadaki tüm kelimeler tamamlandığında sessizce +5 XP ver
        ref.read(pointsProvider.notifier).addPoints(5);
      }
      
      // Ses efekti tetikleyicisi
      if (prev != null) {
        if (next.foundWords.length > prev.foundWords.length) {
          _playSFX(true);
        } else if (prev.currentSelection.length >= 2 && next.currentSelection.isEmpty) {
          _playSFX(false);
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1E1B4B), // Koyu mor/lacivert tema
      appBar: AppBar(
        title: Text('Kelime Avı', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            notifier.endGame();
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => ref.read(soundSettingsProvider.notifier).toggleMute(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Icon(
                      isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                      color: isSoundOn ? const Color(0xFFA78BFA) : Colors.white38,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: state.isGameOver ? _buildGameOver(state, notifier) : _buildGame(state, notifier),
    );
  }

  Widget _buildGameOver(WordSearchGameState state, WordSearchGameNotifier notifier) {
    bool won = state.foundWords.length == state.placedWords.length && state.placedWords.isNotEmpty;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(won ? Icons.emoji_events_rounded : Icons.timer_off_rounded, color: won ? Colors.amber : Colors.redAccent, size: 80),
          const SizedBox(height: 20),
          Text(
            won ? 'Harika İş!' : 'Süre Doldu!',
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Skor: ${state.score}',
            style: GoogleFonts.inter(fontSize: 24, color: Colors.cyanAccent),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => notifier.startGame(),
            child: Text(
              'Tekrar Oyna',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGame(WordSearchGameState state, WordSearchGameNotifier notifier) {
    if (state.grid.isEmpty) return const Center(child: CircularProgressIndicator());
    
    int gridSize = state.grid.length;

    return Column(
      children: [
        // Top Bar
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
                  color: Colors.purpleAccent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purpleAccent),
                ),
                child: Text(
                  state.currentCategory?.name ?? '',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('SÜRE', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('${state.timeLeft ~/ 60}:${(state.timeLeft % 60).toString().padLeft(2, '0')}', 
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, 
                    color: state.timeLeft <= 30 ? Colors.redAccent : Colors.white)),
                ],
              ),
            ],
          ),
        ),

        // Grid
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5), width: 2),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      _cellSize = constraints.maxWidth / gridSize;
                      
                      return GestureDetector(
                        onPanStart: (details) {
                          notifier.updateSelection([]);
                          _handlePanUpdate(DragUpdateDetails(globalPosition: details.globalPosition, localPosition: details.localPosition), gridSize, notifier, state);
                        },
                        onPanUpdate: (details) => _handlePanUpdate(details, gridSize, notifier, state),
                        onPanEnd: (details) => notifier.submitSelection(state.currentSelection),
                        child: Stack(
                          key: _gridKey,
                          children: [
                            // Selection Highlight
                            if (state.currentSelection.isNotEmpty)
                              ..._buildSelectionHighlight(state.currentSelection),
                              
                            // Found Words Highlights
                            ..._buildFoundWordsHighlights(state),

                            // Grid Letters
                            RepaintBoundary(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridSize,
                                ),
                                itemCount: gridSize * gridSize,
                                itemBuilder: (context, index) {
                                  int row = index ~/ gridSize;
                                  int col = index % gridSize;
                                  String letter = state.grid[row][col];
                                  
                                  bool isSelected = state.currentSelection.contains(WordPosition(row, col));
                                  
                                  return Center(
                                    child: Text(
                                      letter,
                                      style: GoogleFonts.outfit(
                                        fontSize: _cellSize * 0.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.black : Colors.white,
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
                  ),
                ),
              ),
            ),
          ),
        ),

        // Word List
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bulunacak Kelimeler:', style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.placedWords.map((pw) {
                  bool isFound = state.foundWords.contains(pw.word);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isFound ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isFound ? Colors.greenAccent : Colors.transparent),
                    ),
                    child: Text(
                      pw.word,
                      style: GoogleFonts.outfit(
                        color: isFound ? Colors.greenAccent : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: isFound ? TextDecoration.lineThrough : null,
                        decorationColor: Colors.greenAccent,
                        decorationThickness: 2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSelectionHighlight(List<WordPosition> selection) {
    return selection.map((pos) {
      return Positioned(
        left: pos.col * _cellSize,
        top: pos.row * _cellSize,
        width: _cellSize,
        height: _cellSize,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildFoundWordsHighlights(WordSearchGameState state) {
    List<Widget> highlights = [];
    for (var placed in state.placedWords) {
      if (state.foundWords.contains(placed.word)) {
        for (var pos in placed.positions) {
          highlights.add(
            Positioned(
              left: pos.col * _cellSize,
              top: pos.row * _cellSize,
              width: _cellSize,
              height: _cellSize,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        }
      }
    }
    return highlights;
  }
}
