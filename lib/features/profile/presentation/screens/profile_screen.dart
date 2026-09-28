import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/providers/shell_tab_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../providers/profile_provider.dart';
import '../../../badges/data/badge_data.dart';
import '../../../badges/providers/badge_provider.dart';
import '../../../badges/presentation/screens/badges_screen.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
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
                      fontSize: isWide ? 36 : 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  if (screenWidth >= 1020) ...[
                    // PC & Akıllı Tahta: Dengeli 2 Sütunlu Düzen (Kare Profil Kartı + Yanında Rozetler ve Geliştirici Notu)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sol Sütun: Kare Profil Kartı
                        Expanded(
                          flex: 5,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: _buildProfileCard(profileState, points),
                          ),
                        ),
                        const SizedBox(width: 28),
                        // Sağ Sütun: Rozetler ve Geliştirici Notu
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBadgesSection(),
                              const SizedBox(height: 24),
                              _buildDeveloperNote(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Tablet & Mobil: Şık Tek Sütunlu Düzen (Taşmayı önlemek için ortalanmış ve orantılı)
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileCard(profileState, points),
                            const SizedBox(height: AppSizes.xl),
                            _buildBadgesSection(),
                            const SizedBox(height: 32),
                            _buildDeveloperNote(),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 120), // Yüzen navigasyon barının kartın üstüne binmesini engellemek için
                  const SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProfileState profileState, int points) {
    final accentColor = const Color(0xFF00FFCC); // Canlı neon turkuaz
    final isWide = MediaQuery.of(context).size.width >= 768;
    final cardHeight = isWide ? 530.0 : 290.0;
    final imageHeight = isWide ? 425.0 : 190.0;

    return Container(
      key: ShellKeys.profileCardKey,
      width: double.infinity,
      height: cardHeight,
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
            // 1. Üst Görsel Bölümü (Geniş Ekranda Kare Çerçeveye Tam Oturan Görsel, Mobilde Orijinal Düzen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: isWide
                  ? Image.asset(
                      'assets/images/hotel_profile.png',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.2),
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF0A1628),
                          child: const Center(
                            child: Icon(Icons.hotel_rounded, color: Colors.white24, size: 40),
                          ),
                        );
                      },
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
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
                        Container(
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
                      ],
                    ),
            ),

            // 3. Alt Bilgi Paneli (Buzlu Cam Efekti / BackdropFilter)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: isWide ? 108 : 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isWide ? 22 : 20, vertical: isWide ? 18 : 16),
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
                              width: isWide ? 56 : 52,
                              height: isWide ? 56 : 52,
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
                            SizedBox(width: isWide ? 14 : 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Turizm Defterim",
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 12.5 : 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 10, vertical: isWide ? 5 : 4),
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
                                        size: isWide ? 15 : 13,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        profileState.role == "Öğretmen" ? "Öğretmen" : "Öğrenci",
                                        style: GoogleFonts.outfit(
                                          fontSize: isWide ? 12 : 11,
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
                          padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 14, vertical: isWide ? 11 : 10),
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
                              Icon(Icons.stars_rounded, color: const Color(0xFFF59E0B), size: isWide ? 28 : 24),
                              SizedBox(width: isWide ? 9 : 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Toplam Puan',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 10.5 : 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white60,
                                    ),
                                  ),
                                  Text(
                                    '$points TP',
                                    style: GoogleFonts.outfit(
                                      fontSize: isWide ? 16.5 : 14,
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
    final isWide = MediaQuery.of(context).size.width >= 768;
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_rounded, color: AppColors.primaryMid, size: isWide ? 26 : 22),
                SizedBox(width: isWide ? 10 : 8),
                Text(
                  'Kazandığım Rozetler',
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 22 : 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 13 : 10,
                vertical: isWide ? 6 : 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryMid.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(isWide ? 14 : 10),
                border: Border.all(
                  color: AppColors.primaryMid.withValues(alpha: 0.22),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    color: AppColors.primaryMid,
                    size: isWide ? 18 : 15,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${earnedBadges.length} Rozet Kazanıldı',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 13.5 : 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryMid,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.lg),
        Builder(
          builder: (context) {
            final isWide = MediaQuery.of(context).size.width >= 768;
            final badgeListHeight = isWide ? 172.0 : 124.0;
            final badgeCardWidth = isWide ? 132.0 : 96.0;
            final badgeCircleSize = isWide ? 66.0 : 44.0;
            final badgeEmojiSize = isWide ? 34.0 : 22.0;

            return SizedBox(
              height: badgeListHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: earnedBadges.length,
                itemBuilder: (context, index) {
                  final badge = earnedBadges[index];
                  final level = progress.getBadgeLevel(badge.id);
                  final levelIcons = ['🥉', '🥈', '🥇', '💎', '👑'];
                  final activeLevelIcon = level > 0 && level <= levelIcons.length ? levelIcons[level - 1] : '';
                  final activeLevelName = level > 0 && level <= badge.levels.length
                      ? badge.levels[level - 1].name
                      : 'Kazanıldı';

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => showBadgeDetailModal(context, badge, level),
                      child: Container(
                        width: badgeCardWidth,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: badge.gradient.first.withValues(alpha: 0.35),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: badge.gradient.first.withValues(alpha: 0.08),
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
                                  width: badgeCircleSize,
                                  height: badgeCircleSize,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        badge.gradient.first.withValues(alpha: 0.14),
                                        badge.gradient.last.withValues(alpha: 0.06),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: badge.gradient.first.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(badge.emoji, style: TextStyle(fontSize: badgeEmojiSize)),
                                ),
                                const SizedBox(height: 6),
                                // Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    badge.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: isWide ? 13.0 : 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Kazanılan Aşama (Bronz, Gümüş, Altın vb.)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: isWide ? 8 : 6, vertical: isWide ? 2.5 : 1.5),
                                  decoration: BoxDecoration(
                                    color: badge.gradient.first.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    activeLevelName,
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 11.5 : 9,
                                      fontWeight: FontWeight.w700,
                                      color: badge.gradient.first,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Level badge icon at top right
                            if (level > 0)
                              Positioned(
                                top: isWide ? 8 : 6,
                                right: isWide ? 8 : 6,
                                child: Text(
                                  activeLevelIcon,
                                  style: TextStyle(fontSize: isWide ? 15 : 11),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeveloperNote() {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Container(
      key: ShellKeys.devNoteKey,
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 24 : AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.primaryMid.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primaryMid.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Icon(Icons.volunteer_activism_rounded, color: AppColors.primaryMid.withValues(alpha: 0.7), size: isWide ? 38 : 32),
          SizedBox(height: isWide ? 14 : 12),
          Text(
            'Geliştirici Notu',
            style: GoogleFonts.outfit(
              fontSize: isWide ? 17 : 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isWide ? 10 : 8),
          Text(
            'Bu platform; derslerinizden ve kitaplarınızdan öğrendiğiniz bilgileri pekiştirmek, tekrar etmek, somutlaştırmak ve oyunlaştırarak kalıcılığı artırmak amacıyla Konaklama ve Seyahat Hizmetleri alanı öğretmeni Erol Mert YURDAKUL tarafından gönüllü bir çabayla geliştirilmiş, kâr amacı gütmeyen tamamen ücretsiz bir eğitim aracıdır. Başarılar dilerim!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isWide ? 14 : 12,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: isWide ? 20 : 16),
          _RehberButton(
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
          ),
        ],
      ),
    );
  }
}

class _RehberButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RehberButton({required this.onTap});

  @override
  State<_RehberButton> createState() => _RehberButtonState();
}

class _RehberButtonState extends State<_RehberButton> {
  bool _isPressed = false;
  DateTime? _pressStartTime;

  void _onTapDown(TapDownDetails details) {
    _pressStartTime = DateTime.now();
    SfxSynthesizer.playAppleSoftClick();
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    final elapsed = DateTime.now().difference(_pressStartTime ?? DateTime.now()).inMilliseconds;
    final remainingVisualTime = (120 - elapsed).clamp(0, 120);

    Future.delayed(Duration(milliseconds: remainingVisualTime), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      }
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: _isPressed 
            ? const Duration(milliseconds: 100) 
            : const Duration(milliseconds: 200),
        curve: _isPressed 
            ? Curves.easeInOutCubic 
            : Curves.easeOutBack,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              Flexible(
                child: Text(
                  'Uygulama Rehberini Baştan İzle',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
