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
  // Renk önbelleği — withOpacity her seferinde yeni nesne yaratmaz
  static const _cardBg = Color(0x0FFFFFFF);       // white 0.06
  static const _cardBorder = Color(0x19FFFFFF);   // white 0.1
  static const _cardShadow = Color(0x33000000);   // black 0.2
  static const _errorBg = Color(0x0DFFFFFF);      // white 0.05
  static const _imageGradientEnd = Color(0xCC000000); // black 0.8
  static const _descColor = Color(0xB3FFFFFF);    // white 0.7
  static const _deptBlue = Color(0xD92196F3);     // blueAccent 0.85
  static const _selectedBg = Color(0x3300BCD4);    // cyan 0.2
  static const _selectedBorder = Color(0x6600BCD4); // cyan 0.4
  static const _btnShadowCyan = Color(0x4D00E5FF); // cyanAccent 0.3

  @override
  Widget build(BuildContext context) {
    final filteredScenarios = ScenarioDatabase.scenarios;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Vaka Analizi Lobisi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Title and Ocean Vibe Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: _selectedBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _selectedBorder),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.waves, color: Colors.cyanAccent, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Kriz Yönetimi Simülasyonu',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                '“',
                                style: GoogleFonts.inter(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 0.8,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                            text: ' Buradaki amacımız, tek bir net cevap aramaktan ziyade olaylara yönelik tahminlerde bulunmak, gözden kaçırdıklarımızı farketmek ve daha iyi çözüm önerileri bulmak için olaylar üzerinde düşünerek kendimizi geliştirmektir. ',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF3E8FF),
                              height: 1.6,
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
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                '”',
                                style: GoogleFonts.inter(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),


              // Scenarios Grid/List
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
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredScenarios.length,
                        itemBuilder: (context, index) {
                          final scenario = filteredScenarios[index];
                          return _buildScenarioCard(context, scenario);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, Scenario scenario) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
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
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scenario Image with Tags on top
            Stack(
              children: [
                SizedBox(
                  height: 288,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      scenario.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
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
                // Gradient overlay over image
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          _imageGradientEnd,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _deptBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          scenario.department,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Title and Description
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scenario.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scenario.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _descColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Start the scenario and navigate
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: _btnShadowCyan,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 22),
                          SizedBox(width: 6),
                          Text(
                            'Krizi Yönetmeye Başla',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
