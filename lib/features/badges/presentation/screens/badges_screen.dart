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
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 5 : 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWide ? 0.88 : 0.78,
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
    ),
  ),
);
  }

  // ── Rozet Detay Gösterimi ──
  void _showBadgeDetail(BadgeItem badge, int currentLevel) {
    showBadgeDetailModal(context, badge, currentLevel);
  }
}

/// Rozet detayını hem Web/PC (şık ortalanmış Dialog) hem de mobil (tam boy BottomSheet)
/// üzerinde eksiksiz ve taşma olmadan gösteren ortak fonksiyon.
void showBadgeDetailModal(BuildContext context, BadgeItem badge, int currentLevel) {
  final isWide = MediaQuery.of(context).size.width >= 768;
  if (isWide) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (context) => _BadgeDetailDialog(badge: badge, currentLevel: currentLevel),
    );
  } else {
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
    final isWide = MediaQuery.of(context).size.width >= 768;
    final circleSize = isWide ? 76.0 : 56.0;
    final emojiSize = isWide ? 38.0 : 28.0;
    final nameFontSize = isWide ? 14.5 : 12.0;

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
              width: circleSize,
              height: circleSize,
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
                  style: TextStyle(fontSize: emojiSize),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // İsim
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: nameFontSize,
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
// ══════════════════════════════════════════
//  ROZET DETAY DİYALOĞU (PC / Web İçin Ortalanmış, Asla Kesilmeyen Şık Modal)
// ══════════════════════════════════════════
class _BadgeDetailDialog extends StatelessWidget {
  final BadgeItem badge;
  final int currentLevel;

  const _BadgeDetailDialog({required this.badge, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: screenHeight * 0.88,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gradient Başlık + Kapat Butonu
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: badge.gradient,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Büyük Emoji
                            Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(badge.emoji, style: const TextStyle(fontSize: 42)),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      badge.category,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    badge.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    badge.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                            onPressed: () => Navigator.of(context).pop(),
                            tooltip: 'Kapat',
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Seviye Aşamaları Listesi (Tam görünür, alttan kesilmez)
                  Flexible(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                        shrinkWrap: true,
                        itemCount: badge.levels.length,
                        itemBuilder: (context, index) {
                          final level = badge.levels[index];
                          final levelIcons = ['🥉', '🥈', '🥇', '💎', '👑'];
                          final isLevelUnlocked = currentLevel > index;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isLevelUnlocked
                                  ? level.color.withValues(alpha: 0.08)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isLevelUnlocked
                                    ? level.color.withValues(alpha: 0.35)
                                    : AppColors.divider.withValues(alpha: 0.8),
                                width: isLevelUnlocked ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: level.color.withValues(alpha: isLevelUnlocked ? 0.2 : 0.08),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: level.color.withValues(alpha: isLevelUnlocked ? 0.4 : 0.15),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: isLevelUnlocked ? 1.0 : 0.4,
                                    child: Text(levelIcons[index], style: const TextStyle(fontSize: 24)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            level.name,
                                            style: GoogleFonts.outfit(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w800,
                                              color: isLevelUnlocked
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isLevelUnlocked
                                                  ? const Color(0xFF2ED573).withValues(alpha: 0.15)
                                                  : Colors.black.withValues(alpha: 0.05),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              isLevelUnlocked ? 'Kazanıldı' : 'Kilitli',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: isLevelUnlocked
                                                    ? const Color(0xFF2ED573)
                                                    : AppColors.textHint,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        level.condition,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          color: isLevelUnlocked
                                              ? AppColors.textSecondary
                                              : AppColors.textHint,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  isLevelUnlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
                                  size: 22,
                                  color: isLevelUnlocked
                                      ? const Color(0xFF2ED573)
                                      : Colors.grey.withValues(alpha: 0.45),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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

// ══════════════════════════════════════════
//  ROZET DETAY BOTTOM SHEET (Mobil / Android)
// ══════════════════════════════════════════
class _BadgeDetailSheet extends StatelessWidget {
  final BadgeItem badge;
  final int currentLevel;

  const _BadgeDetailSheet({required this.badge, required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, -6),
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
                  borderRadius: BorderRadius.circular(3),
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
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        badge.emoji, 
                        style: const TextStyle(fontSize: 36),
                      ),
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
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            badge.name,
                            style: GoogleFonts.outfit(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge.description,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.35,
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
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 36),
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
                              child: Text(
                                levelIcons[index], 
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Opacity(
                              opacity: isLevelUnlocked ? 1.0 : 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        level.name,
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isLevelUnlocked
                                              ? const Color(0xFF2ED573).withValues(alpha: 0.15)
                                              : Colors.black.withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isLevelUnlocked ? 'Kazanıldı' : 'Kilitli',
                                          style: GoogleFonts.inter(
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w700,
                                            color: isLevelUnlocked
                                                ? const Color(0xFF2ED573)
                                                : AppColors.textHint,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    level.condition,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
