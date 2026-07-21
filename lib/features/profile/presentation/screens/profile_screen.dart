import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../providers/profile_provider.dart';
import '../../../badges/data/badge_data.dart';
import '../../../badges/providers/badge_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;
  
  const ProfileScreen({
    super.key,
    this.isOnboarding = false,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final points = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.md),
              Text(
                'Profil',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              _buildProfileCard(profileState, points),
              const SizedBox(height: AppSizes.xl),
              _buildBadgesSection(),

              const SizedBox(height: 36),
              _buildDeveloperNote(),
              const SizedBox(height: 120), // Yüzen navigasyon barının kartın üstüne binmesini engellemek için
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileState profileState, int points) {
    final accentColor = const Color(0xFF00FFCC); // Canlı neon turkuaz

    return Container(
      key: ShellKeys.profileCardKey,
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        color: const Color(0xFF0A192F).withOpacity(0.65),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // 1. Arka Plan Otel Görseli (Üst Yarıda)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 190,
              child: Image.asset(
                'assets/images/hotel_profile.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.65),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF0A1628),
                    child: const Center(
                      child: Icon(Icons.hotel_rounded, color: Colors.white24, size: 40),
                    ),
                  );
                },
              ),
            ),

            // 2. Resmin Üzerindeki Karartma Degradesi
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 190,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      const Color(0xFF0A192F).withOpacity(0.85),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Alt Bilgi Paneli (Buzlu Cam Efekti / BackdropFilter)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 12, sigmaY: kIsWeb ? 0 : 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A192F).withOpacity(0.7),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sol Taraf: Profil Fotoğrafı ve Bilgiler
                        Row(
                          children: [
                            // Dairesel Profil Fotoğrafı (o 2 otel personelinin olduğu foto)
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/hotel_profile.png',
                                  fit: BoxFit.cover,
                                  alignment: const Alignment(0, -0.4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Turizm Defterim",
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A192F).withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: accentColor.withOpacity(0.55),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentColor.withOpacity(0.15),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        profileState.role == "Öğretmen" ? Icons.psychology_rounded : Icons.school_rounded,
                                        color: accentColor,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        profileState.role == "Öğretmen" ? "Öğretmen" : "Öğrenci",
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      
                        // Sağ Taraf: Toplam Puan
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFF59E0B).withOpacity(0.25),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                            const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 24),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Toplam Puan',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  '$points XP',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
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
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    final progress = ref.watch(badgeProgressProvider);
    final earnedBadges = allBadges.where((badge) {
      return progress.getBadgeLevel(badge.id) > 0;
    }).toList();

    if (earnedBadges.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: AppColors.primaryMid),
              const SizedBox(width: 8),
              Text(
                'Kazandığım Rozetler',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 48, color: AppColors.textHint.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                Text(
                  'Henüz rozet kazanmadın',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rozet ekranından görevleri inceleyip\nhemen kazanmaya başla!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: AppColors.primaryMid),
                const SizedBox(width: 8),
                Text(
                  'Kazandığım Rozetler',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '${earnedBadges.length} Rozet',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMid,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: earnedBadges.length,
            itemBuilder: (context, index) {
              final badge = earnedBadges[index];
              final level = progress.getBadgeLevel(badge.id);
              final levelIcons = ['🥉', '🥈', '🥇', '💎', '👑'];
              final activeLevelIcon = level > 0 ? levelIcons[level - 1] : '';

              return Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider.withValues(alpha: 0.6), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: badge.gradient.first.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                badge.gradient.first.withValues(alpha: 0.12),
                                badge.gradient.last.withValues(alpha: 0.06),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(badge.emoji, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(height: 6),
                        // Name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            badge.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Level badge at top right
                    if (level > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Text(
                          activeLevelIcon,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperNote() {
    return Container(
      key: ShellKeys.devNoteKey,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryMid.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryMid.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.volunteer_activism_rounded, color: AppColors.primaryMid.withValues(alpha: 0.6), size: 32),
          const SizedBox(height: 12),
          Text(
            'Geliştirici Notu',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu platform, eğitim süreçlerinizi daha interaktif, verimli ve keyifli hale getirmek amacıyla Konaklama ve Seyahat Hizmetleri alanı öğretmeni Erol Mert YURDAKUL tarafından gönüllü bir çabayla geliştirilmiş, kâr amacı gütmeyen tamamen ücretsiz bir eğitim aracıdır. Başarılar dilerim!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('has_seen_onboarding_guide', false);
              ref.read(shellTabProvider.notifier).state = 0;
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Uygulama rehberi sıfırlandı. Ana sayfaya yönlendiriliyorsunuz...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryMid.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryMid.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.help_outline_rounded, size: 18, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    'Uygulama Rehberini Baştan İzle',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
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
