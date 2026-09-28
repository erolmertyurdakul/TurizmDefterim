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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1180;
    final isTablet = screenWidth >= 800 && screenWidth < 1180;
    final isWide = screenWidth >= 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1450),
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
                          padding: EdgeInsets.all(isWide ? 12 : 10),
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
                          child: Icon(Icons.sports_esports_rounded, color: Colors.white, size: isWide ? 30 : 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uygulamalar',
                                style: GoogleFonts.outfit(
                                  fontSize: isWide ? 28 : 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${_games.length} eğlenceli öğrenme uygulaması',
                                style: GoogleFonts.inter(
                                  fontSize: isWide ? 14 : 13,
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

                // ── Oyun Kartları Listesi (Masaüstünde 3'lü grid, tablette 2'li grid, mobilde liste) ──
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                  sliver: isWide
                      ? SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isDesktop ? 3 : 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 145,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final game = _games[index];
                              return _GameCard(
                                game: game,
                                index: index,
                                inGrid: true,
                                isWide: isWide,
                                isDesktop: isDesktop,
                              );
                            },
                            childCount: _games.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final game = _games[index];
                              return _GameCard(
                                game: game,
                                index: index,
                                isWide: false,
                                isDesktop: false,
                              );
                            },
                            childCount: _games.length,
                          ),
                        ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
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
  final bool inGrid;
  final bool isWide;
  final bool isDesktop;

  const _GameCard({
    required this.game,
    required this.index,
    this.inGrid = false,
    this.isWide = false,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(bottom: inGrid ? 0 : 14),
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
            padding: EdgeInsets.all(isDesktop ? 16 : 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Emoji İkon
                Container(
                  width: isDesktop ? 62 : 54,
                  height: isDesktop ? 62 : 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: game.gradient,
                    ),
                    borderRadius: BorderRadius.circular(isDesktop ? 16 : 14),
                    boxShadow: [
                      BoxShadow(
                        color: game.gradient.first.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(game.emoji, style: TextStyle(fontSize: isDesktop ? 30 : 26)),
                ),
                SizedBox(width: isDesktop ? 14 : 11),
                // Oyun Bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: isDesktop ? 16.5 : 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: game.gradient.first.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              game.type,
                              style: GoogleFonts.inter(
                                fontSize: isDesktop ? 11 : 9.5,
                                fontWeight: FontWeight.w700,
                                color: game.gradient.first,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        game.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: isDesktop ? 12.5 : 11.5,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Yakında veya Oyna Etiketi
                      if (game.comingSoon)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 10 : 8,
                                vertical: isWide ? 4 : 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.schedule_rounded, size: isWide ? 14 : 12, color: AppColors.accentWarm),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Yakında',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 11.5 : 10,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 16 : 12,
                                vertical: isWide ? 6 : 4,
                              ),
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
                                  Icon(Icons.play_arrow_rounded, size: isWide ? 16 : 14, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Oyna',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 12.5 : 11,
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
