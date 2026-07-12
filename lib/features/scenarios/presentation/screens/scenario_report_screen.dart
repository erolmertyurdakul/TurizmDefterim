import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scenario_provider.dart';
import 'scenario_game_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

class ScenarioReportScreen extends ConsumerWidget {
  const ScenarioReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scenarioProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF071317),
              Color(0xFF0F2027),
              Color(0xFF1B3B48),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kriz Analiz Raporu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () {
                        ref.read(scenarioProvider.notifier).reset();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Scenario Title Completion Card
                      _buildCompletionCard(state),
                      const SizedBox(height: 20),

                      // Final Erol Hoca Letter
                      _buildErolHocaLetter(state),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF071317),
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Restart
                          if (state.currentScenario != null) {
                            ref.read(scenarioProvider.notifier).startScenario(state.currentScenario!);
                            Navigator.of(context).pushReplacement(
                              FadePageRoute(
                                child: const ScenarioGameScreen(),
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.cyanAccent),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Tekrar Dene',
                          style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Return to lobby
                          ref.read(scenarioProvider.notifier).reset();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Lobiye Dön',
                          style: TextStyle(fontWeight: FontWeight.bold),
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

  // Completion Card
  Widget _buildCompletionCard(ScenarioState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.cyanAccent,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tebrikler!',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.currentScenario?.title ?? "Vaka"} analizi başarıyla tamamlandı.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Erol Hoca\'nın değerlendirme mektubunu aşağıdan inceleyebilirsin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Final mentoring letter by Erol Hoca
  Widget _buildErolHocaLetter(ScenarioState state) {
    String finalQuote;
    final ds = state.dimensionScores;

    if (ds.guestCentricity >= 8 && ds.financialDiscipline >= 4) {
      finalQuote =
          'Evlat, senden tam bir genel müdür olur! Hem misafiri saraylarda ağırladın hem de otelin kasasını deldirmedin. Sektör senin gibi dengeli ve basiretli yöneticiler arıyor. Yanaklarından öpüyorum, yolun açık!';
    } else if (ds.guestCentricity >= 8) {
      finalQuote =
          'Misafirperverliğine şapka çıkartırım evlat. Ama unutma, otel hayır kurumu değil ticarethanedir! Bu cömertlikle ay sonu maaşları ödeyemeyiz. Bir dahaki sefere cüzdanı biraz daha sıkı tut, tamam mı?';
    } else if (ds.financialDiscipline >= 8) {
      finalQuote =
          'Parayı kasaya kilitledin, harika! Ama misafirleri de kapı dışarı ettin be evlat. O memnuniyetsizlikle otelde bir dahaki ay kim kalacak? Turizmde önce insan gelir. Biraz daha empati şart!';
    } else if (ds.riskManagement <= -8) {
      finalQuote =
          'Operasyonda aldığın riskler saçımı başımı ağrıttı! Ajan filmi gibi temizlik bezi aşırmalar, VIP misafirin odasını kumar oynamalar... Gerçek hayatta bu risklerin biri patlarsa sektörel ömrün biter. Tedbiri elden bırakma!';
    } else {
      finalQuote =
          'Kriz yönetimini geliştirmen gerekiyor evlat. Eksiklerin var ama tecrübe kazandıkça hepsi çözülür. Hatalarından ders al ve simülasyonu tekrar oyna. Gerçek hayatta bu tecrübeler altın değerindedir!';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('⚓', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text(
                'Erol Hoca Yönetici Özeti',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            finalQuote,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}


