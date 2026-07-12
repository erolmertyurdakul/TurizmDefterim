import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../data/badge_data.dart';
import '../../providers/badge_provider.dart';

class BadgesScreen extends ConsumerStatefulWidget {
  const BadgesScreen({super.key});

  @override
  ConsumerState<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends ConsumerState<BadgesScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  BadgeItem? _selectedBadge;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: badgeCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Üst Başlık ──
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 0,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rozet Koleksiyonu',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${allBadges.length} rozet • 5 seviye',
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

            const SizedBox(height: AppSizes.md),

            // ── Kategori TabBar ──
            SizedBox(
              height: 40,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryMid,
                ),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                labelPadding: const EdgeInsets.symmetric(horizontal: 14),
                tabs: badgeCategories.map((cat) {
                  return Tab(text: cat);
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: badgeCategories.map((category) {
                  final categoryBadges = allBadges.where((b) => b.category == category).toList();
                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      left: AppSizes.screenPadding,
                      right: AppSizes.screenPadding,
                      top: 4,
                      bottom: 100,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: categoryBadges.length,
                    itemBuilder: (context, index) {
                      final badge = categoryBadges[index];
                      final progress = ref.watch(badgeProgressProvider);
                      final level = progress.getBadgeLevel(badge.id);
                      return _BadgeTile(
                        badge: badge,
                        currentLevel: level,
                        onTap: () => _showBadgeDetail(badge, level),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Rozet Detay Bottom Sheet ──
  void _showBadgeDetail(BadgeItem badge, int currentLevel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BadgeDetailSheet(badge: badge, currentLevel: currentLevel),
    );
  }
}

// ══════════════════════════════════════════
//  ROZET TILE (Grid Kartı)
// ══════════════════════════════════════════
class _BadgeTile extends StatelessWidget {
  final BadgeItem badge;
  final int currentLevel;
  final VoidCallback onTap;

  const _BadgeTile({
    required this.badge,
    required this.currentLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = currentLevel > 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: badge.gradient.first.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji Rozet
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    badge.gradient.first.withValues(alpha: isUnlocked ? 0.12 : 0.04),
                    badge.gradient.last.withValues(alpha: isUnlocked ? 0.06 : 0.02),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: badge.gradient.first.withValues(alpha: isUnlocked ? 0.2 : 0.08),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Opacity(
                opacity: isUnlocked ? 1.0 : 0.35,
                child: Text(
                  badge.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // İsim
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Seviye çubukları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final isLevelUnlocked = currentLevel > i;
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLevelUnlocked
                        ? badge.levels[i].color
                        : badge.levels[i].color.withValues(alpha: 0.15),
                    border: Border.all(
                      color: isLevelUnlocked
                          ? badge.levels[i].color
                          : badge.levels[i].color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════
//  ROZET DETAY BOTTOM SHEET
// ══════════════════════════════════════════
class _BadgeDetailSheet extends StatelessWidget {
  final BadgeItem badge;
  final int currentLevel;

  const _BadgeDetailSheet({required this.badge, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Sürükleme çubuğu
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Gradient Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: badge.gradient,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: badge.gradient.first.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Büyük Emoji
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(badge.emoji, style: const TextStyle(fontSize: 38)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge.category,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge.name,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Seviye Listesi
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: badge.levels.length,
                  itemBuilder: (context, index) {
                    final level = badge.levels[index];
                    final levelIcons = ['🥉', '🥈', '🥇', '💎', '👑'];
                    final isLevelUnlocked = currentLevel > index;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isLevelUnlocked
                            ? level.color.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLevelUnlocked
                              ? level.color.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.05),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Seviye İkonu
                          Opacity(
                            opacity: isLevelUnlocked ? 1.0 : 0.4,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: level.color.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: level.color.withValues(alpha: 0.3)),
                              ),
                              alignment: Alignment.center,
                              child: Text(levelIcons[index], style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Opacity(
                              opacity: isLevelUnlocked ? 1.0 : 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    level.condition,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Açılmışsa check, kilitliyse lock
                          Icon(
                            isLevelUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                            size: 20,
                            color: isLevelUnlocked ? Colors.green : Colors.grey.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
