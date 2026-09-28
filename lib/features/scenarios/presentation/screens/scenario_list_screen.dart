import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/scenario_database.dart';
import '../../domain/models/scenario_models.dart';
import '../providers/scenario_provider.dart';
import 'scenario_game_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

class ScenarioListScreen extends ConsumerStatefulWidget {
  const ScenarioListScreen({super.key});

  @override
  ConsumerState<ScenarioListScreen> createState() => _ScenarioListScreenState();
}

class _ScenarioListScreenState extends ConsumerState<ScenarioListScreen> {
  // Renk önbelleği
  static const _cardBg = Color(0x0FFFFFFF);       // white 0.06
  static const _cardBorder = Color(0x19FFFFFF);   // white 0.1
  static const _cardShadow = Color(0x33000000);   // black 0.2
  static const _errorBg = Color(0x0DFFFFFF);      // white 0.05
  static const _descColor = Color(0xCCFFFFFF);    // white 0.8
  static const _deptBlue = Color(0xD90284C7);     // sky 600
  static const _selectedBg = Color(0x3300BCD4);    // cyan 0.2
  static const _selectedBorder = Color(0x6600BCD4); // cyan 0.4
  static const _btnShadowCyan = Color(0x4D00E5FF); // cyanAccent 0.3

  @override
  Widget build(BuildContext context) {
    final filteredScenarios = ScenarioDatabase.scenarios;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth >= 768;
    final bool isDesktop = screenWidth >= 1150;
    final int crossAxisCount = isDesktop ? 3 : 2;
    final double childAspectRatio = isDesktop
        ? (screenWidth >= 1350 ? 0.78 : 0.72)
        : (screenWidth >= 900 ? 0.75 : 0.70);

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        title: Text(
          'Vaka Analizi Lobisi',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: isWide ? 28 : 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F2027),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: isWide ? 28 : 22,
          ),
          tooltip: 'Geri',
          splashRadius: isWide ? 26 : 20,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Title and Ocean Vibe Banner
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 36.0 : 20.0, 
                  8.0, 
                  isWide ? 36.0 : 20.0, 
                  isWide ? 20.0 : 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 16.0 : 12.0, 
                        vertical: isWide ? 8.0 : 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _selectedBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.waves, color: Colors.cyanAccent, size: isWide ? 22 : 16),
                          const SizedBox(width: 8),
                          Text(
                            'Kriz Yönetimi Simülasyonu',
                            style: GoogleFonts.inter(
                              color: Colors.cyanAccent,
                              fontSize: isWide ? 16 : 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '“ Buradaki amacımız, tek bir net cevap aramaktan ziyade olaylara yönelik tahminlerde bulunmak, gözden kaçırdıklarımızı farketmek ve daha iyi çözüm önerileri bulmak için olaylar üzerinde düşünerek kendimizi geliştirmektir. ”',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 17.5 : 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF3E8FF),
                        height: 1.55,
                        letterSpacing: 0.2,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 1.5),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scenarios Grid / List
              Expanded(
                child: filteredScenarios.isEmpty
                    ? const Center(
                        child: Text(
                          'Senaryo bulunamadı.',
                          style: TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      )
                    : isWide
                        ? Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1450),
                              child: GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: childAspectRatio,
                                ),
                                itemCount: filteredScenarios.length,
                                itemBuilder: (context, index) {
                                  final scenario = filteredScenarios[index];
                                  return _buildScenarioCard(context, scenario, isWide: true);
                                },
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredScenarios.length,
                            itemBuilder: (context, index) {
                              final scenario = filteredScenarios[index];
                              return _buildScenarioCard(context, scenario, isWide: false);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, Scenario scenario, {required bool isWide}) {
    // ── Sinematik Ambient Görsel Vitrini ──
    final imageStack = ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: isWide ? 220 : 195,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Arka plan: Ambient Flu Görsel (Kenar boşluklarını şık otel atmosferiyle doldurur)
            Image.asset(
              scenario.imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
            // 2. Bulanıklık ve Karartma (Ön plandaki karakteri net ve belirgin kılar)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: const Color(0xFF0A1624).withValues(alpha: 0.52),
              ),
            ),
            // 3. Ön Plan: Net, Tam Oranlı Karakter ve Mekan Görseli
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: isWide ? 10 : 6),
                child: Image.asset(
                  scenario.imageUrl,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: _errorBg,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.white24, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 4. Alt Yumuşak Geçiş Gradyanı (Kartın gövdesine pürüzsüz erir)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 55,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xEE0F2027),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // 5. Departman Rozeti (Sol Üst)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 12.0 : 10.0,
                  vertical: isWide ? 5.0 : 4.0,
                ),
                decoration: BoxDecoration(
                  color: _deptBlue.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  scenario.department,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: isWide ? 13.5 : 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final actionButton = SizedBox(
      width: double.infinity,
      height: isWide ? 50 : 44,
      child: ElevatedButton(
        onPressed: () {
          ref.read(scenarioProvider.notifier).startScenario(scenario);
          Navigator.of(context).push(
            FadePageRoute(
              child: const ScenarioGameScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: _btnShadowCyan,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, size: isWide ? 24 : 20),
            const SizedBox(width: 6),
            Text(
              'Krizi Yönetmeye Başla',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                fontSize: isWide ? 16.5 : 13.5,
              ),
            ),
          ],
        ),
      ),
    );

    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(bottom: isWide ? 0 : 18),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder),
          boxShadow: const [
            BoxShadow(
              color: _cardShadow,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: isWide
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageStack,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scenario.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: isWide ? 20 : 17,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                scenario.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: _descColor,
                                  fontSize: 14.5,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            actionButton,
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    imageStack,
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            scenario.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scenario.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: _descColor,
                              fontSize: 13.5,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 14),
                          actionButton,
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
