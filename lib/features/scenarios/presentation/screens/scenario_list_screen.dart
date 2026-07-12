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
  String selectedDepartment = 'Hepsi';

  // Renk önbelleği — withOpacity her seferinde yeni nesne yaratmaz
  static const _cardBg = Color(0x0FFFFFFF);       // white 0.06
  static const _cardBorder = Color(0x19FFFFFF);   // white 0.1
  static const _cardShadow = Color(0x33000000);   // black 0.2
  static const _errorBg = Color(0x0DFFFFFF);      // white 0.05
  static const _imageGradientEnd = Color(0xCC000000); // black 0.8
  static const _descColor = Color(0xB3FFFFFF);    // white 0.7
  static const _blackOverlay = Color(0x99000000);  // black 0.6
  static const _deptBlue = Color(0xD92196F3);     // blueAccent 0.85
  static const _deptPurple = Color(0xD9AA00FF);   // purpleAccent 0.85
  static const _deptAmber = Color(0xD9FFD740);    // amberAccent 0.85
  static const _difficultyBorder = Color(0x80FFFFFF); // white 0.5
  static const _selectedBg = Color(0x3300BCD4);    // cyan 0.2
  static const _selectedBorder = Color(0x6600BCD4); // cyan 0.4
  static const _hintColor = Color(0x99FFFFFF);     // white 0.6
  static const _btnShadowCyan = Color(0x4D00E5FF); // cyanAccent 0.3

  final List<String> departments = [
    'Hepsi',
    'Ön Büro',
    'Kat Hizmetleri'
  ];

  @override
  Widget build(BuildContext context) {
    // Filter scenarios based on selection
    final filteredScenarios = selectedDepartment == 'Hepsi'
        ? ScenarioDatabase.scenarios
        : ScenarioDatabase.scenarios
            .where((s) => s.department == selectedDepartment)
            .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Kriz Yönetim Lobisi',
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
                            'Karar Anı Simülasyonu',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Gerçek Turizm Krizleri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
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
                            text: ' Gençler, bu bölümde tek bir net cevap aramıyoruz; amacımız olaylara yönelik tahminlerde bulunmak ve sonrasında gözden kaçırdığımız detayları fark etmektir. Krizleri en uygun şekilde yönettikten sonra senaryolar üzerinde düşünüp mevcut seçeneklerden daha iyi çözüm önerileri üretebilmek için çabalarsanız, bu bölümden alacağınız faydayı artırabilirsiniz. ',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic,
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

              // Horizontal Category Filter
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: departments.length,
                  itemBuilder: (context, index) {
                    final dept = departments[index];
                    final isSelected = selectedDepartment == dept;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDepartment = dept;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.cyanAccent : const Color(0xFF102A35),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected ? Colors.cyanAccent : Colors.white.withValues(alpha: 0.15),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? Colors.cyanAccent.withValues(alpha: 0.3)
                                    : Colors.transparent,
                                blurRadius: isSelected ? 8.0 : 0.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            dept,
                            style: GoogleFonts.inter(
                              color: isSelected ? Colors.black87 : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Scenarios Grid/List
              Expanded(
                child: filteredScenarios.isEmpty
                    ? Center(
                        child: Text(
                          'Bu departmana ait kriz senaryosu bulunamadı.',
                          style: const TextStyle(
                            color: _hintColor,
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
    Color difficultyColor;
    switch (scenario.difficulty) {
      case 'Kolay':
        difficultyColor = Colors.greenAccent;
        break;
      case 'Orta':
        difficultyColor = Colors.orangeAccent;
        break;
      default:
        difficultyColor = Colors.redAccent;
    }

    Color deptColorBg;
    switch (scenario.department) {
      case 'Ön Büro':
        deptColorBg = _deptBlue;
        break;
      case 'Kat Hizmetleri':
        deptColorBg = _deptPurple;
        break;
      default:
        deptColorBg = _deptAmber;
    }

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
                          color: deptColorBg,
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
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _blackOverlay,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _difficultyBorder),
                        ),
                        child: Text(
                          scenario.difficulty,
                          style: TextStyle(
                            color: difficultyColor,
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
