import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'word_search_screen.dart';
import 'reception_simulator_screen.dart';
import 'blitz_quiz_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

/// Mini oyun veri modeli
class _MiniGame {
  final String emoji;
  final String name;
  final String description;
  final String type;
  final List<Color> gradient;
  final bool comingSoon;

  const _MiniGame({
    required this.emoji,
    required this.name,
    required this.description,
    required this.type,
    required this.gradient,
    this.comingSoon = true,
  });
}

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  static final List<_MiniGame> _games = [
    _MiniGame(
      emoji: '🛎️',
      name: 'Resepsiyon Simülatörü',
      description: 'Misafirleri doğru oda tipi ve pansiyon durumlarıyla eşleştir. Zamana karşı yarış!',
      type: 'Simülasyon',
      gradient: [const Color(0xFF0E918C), const Color(0xFF17B5B0)],
      comingSoon: false,
    ),
    _MiniGame(
      emoji: '🔤',
      name: 'Kelime Avı',
      description: 'Harf ızgarasında gizlenmiş turizm terimlerini bul. Tematik bulmacalar!',
      type: 'Bulmaca',
      gradient: [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
      comingSoon: false,
    ),
    _MiniGame(
      emoji: '⚡',
      name: 'Blitz Test',
      description: '60 saniyede mümkün olduğunca çok soruya doğru cevap ver!',
      type: 'Hızlı Test',
      gradient: [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
      comingSoon: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Başlık ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 0,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.sports_esports_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uygulamalar',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${_games.length} eğlenceli öğrenme uygulaması',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.lg)),

            // ── Oyun Kartları Listesi ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final game = _games[index];
                    return _GameCard(game: game, index: index);
                  },
                  childCount: _games.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  OYUN KARTI
// ══════════════════════════════════════════
class _GameCard extends StatelessWidget {
  final _MiniGame game;
  final int index;

  const _GameCard({required this.game, required this.index});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: game.gradient.first.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (game.name == 'Kelime Avı') {
              Navigator.push(
                context,
                FadePageRoute(child: const WordSearchScreen()),
              );
              return;
            } else if (game.name == 'Resepsiyon Simülatörü') {
              Navigator.push(
                context,
                FadePageRoute(child: const ReceptionSimulatorScreen()),
              );
              return;
            } else if (game.name == 'Blitz Test') {
              Navigator.push(
                context,
                FadePageRoute(child: const BlitzQuizScreen()),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${game.name} yakında aktif olacak! 🎮',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                backgroundColor: game.gradient.first,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Emoji İkon
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: game.gradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: game.gradient.first.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(game.emoji, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                // Oyun Bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.name,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: game.gradient.first.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              game.type,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: game.gradient.first,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        game.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Yakında veya Oyna Etiketi
                      if (game.comingSoon)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 12, color: AppColors.accentWarm),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Yakında',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.accentWarm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: game.gradient.first,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: game.gradient.first.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.play_arrow_rounded, size: 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Oyna',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
