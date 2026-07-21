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
            'Vaka Analizi Tamamlandı',
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

  // Final mentoring letter by Erol Hoca — path-based (statik, yola göre)
  Widget _buildErolHocaLetter(ScenarioState state) {
    final report = _getReportForPath(state);

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
                'Operasyonel Değerlendirme',
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
            report,
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

  /// Seçilen seçeneklerin sırasına göre değerlendirme raporunu döndürür.
  /// Her adımdaki seçenek 1 → indeks 0, seçenek 2 → indeks 1 olarak kodlanmıştır.
  String _getReportForPath(ScenarioState state) {
    final options = state.selectedOptions;
    if (options.isEmpty) return 'Değerlendirme raporu oluşturulamadı.';

    final scenarioId = state.currentScenario?.id ?? '';

    // Her senaryoya ait değerlendirme raporları, seçim indeksleri eşleştirilerek
    // reports[yol_anahtarı] = rapor metni şeklinde saklanmıştır.
    // Yol anahtarı: her adımda seçilen seçeneğin o adımdaki index'i "," ile birleştirilir.
    final path = _buildPath(state);

    final Map<String, Map<String, String>> allReports = {
      'bellboy_baggage_mixup': {
        '0,0,0': 'Gösterdiğiniz performans, bir yönetici vizyonunu yansıtmaktadır. Misafir memnuniyetini üst seviyede tuttunuz. Turizm sektörü, sizin gibi yöneticilere ihtiyaç duymaktadır. Olay oldukça rahatsız edici olduğundan dolayı ikram düşüncesi gerçekten bir incelikti. Ancak ikramlar konusunda tedbirli olmanız gerektiğini unutmamalısınız.',
        '0,0,1': 'Gösterdiğiniz performans sayesinde misafirler memnun kaldılar, ancak misafirlerin bu tatsız bekleyişine değecek bir içecek ikramı için şefinize danışmanız daha uygun olabilirdi.',
        '0,1,0': 'Gösterdiğiniz performansla misafir memnuniyetini sağladınız. Olay oldukça rahatsız edici olduğundan dolayı ikram düşüncesi gerçekten bir incelikti. Ancak sağlık konusunda hekim kontrolü yapılmasını sağlamanız daha uygun olurdu. İkramlar konusunda da tedbirli olmanız gerektiğini unutmamalısınız.',
        '0,1,1': 'Gösterdiğiniz performans sayesinde misafirler memnun kaldılar, ancak misafirlerin bu tatsız bekleyişine değecek bir içecek ikramı için şefinize danışmanız ve sağlık konusunda hekim kontrolü yapılmasını sağlamanız daha uygun olurdu.',
        '1,0,0': 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. İkram, misafirleri biraz sakinleştirdi ancak durumu tam olarak çözmedi. Karşılaştığınız durumlarda daha dengeli ve dürüst kararlar alarak işletme performansını artırabilirsiniz. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,0,1': 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. Misafirler memnun kalmadı ve otele düşük puan verdiler. Karşılaştığınız durumlarda daha dengeli ve dürüst kararlar alarak işletme performansını artırabilirsiniz. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,1,0': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Misafirler memnun kalmadı ve otele düşük puan verdiler. Dürüstlük ve çözüm odaklılık bir turizm personeli için vazgeçilmez iki değerdir. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,1,1': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Olay kameralardan kontrol edildi ve işinizi kaybettiniz. Misafirler otele düşük puan verdiler ve kötü yorum yazdılar. Dürüstlük ve çözüm odaklılık bir turizm personeli için vazgeçilmez iki değerdir. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
      },
      'reservation_overbooking': {
        '0,0,0': 'Gösterdiğiniz performans, bir yönetici vizyonunu yansıtmaktadır. Overbooking krizini sadık bir misafir kazanarak kapattınız. İndirim çekleri ve promosyonlar konusunda şefinize danıştınız. Ancak ikramlar konusunda tedbirli olmanız gerektiğini unutmamalısınız.',
        '0,0,1': 'Gösterdiğiniz performans sayesinde misafirler memnun kaldılar, ancak krizin tatsızlığını tamamen gidermek için şefinize danışarak misafirlere küçük bir indirim çeki veya jest sunmanız daha uygun olabilirdi.',
        '0,1,0': 'Gösterdiğiniz performansla misafir memnuniyetini sağladınız. Ancak ilk önce size gelmiş bir misafirin diğer otelin eksikliklerinden dolayı yaşadığı sıkıntıyı kendi ekibinizle çözmeyip topu onlara atmak profesyonelliğe sığmaz. Neyse ki misafirler indirimden etkilenip yine de kötü yorum yazmadılar.',
        '0,1,1': 'Olamaz! İlk önce size gelmiş bir misafirin diğer otelin eksikliklerinden dolayı yaşadığı sıkıntıyı kendi ekibinizle çözmeyip topu onlara atmak profesyonelliğe sığmaz. Unutmayın misafirlerin bir kere gelmesi değil, sürekli misafirler (repeat guests) olmaları bir otel için çok önemlidir. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,0,0': 'Aileyi 4 yıldızlı otele masraflarını otelce karşılayarak göndermek krizi çözdü. İtalyan grup ise ikramdan sonra biraz daha yatıştı ve kötü yorum yazmadılar. Karşılaştığınız durumlarda daha dengeli ve dürüst kararlar alarak işletme performansını korumalısınız. Ayrıca yaptığınız ikramlar konusunda tedbirli olmanızı öneririm.',
        '1,0,1': 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. İtalyan gruptaki o misafirleri görmezden gelmek misafirlerin tatsız bir şekilde odaya yerleşmesine sebep oldu ve misafirler otele düşük puan verdiler. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,1,0': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Gayriresmi teklifler sunmak yerine dürüstçe hareket etmeliydiniz. Dürüstlük ve çözüm odaklılık bir turizm personeli için vazgeçilmez iki değerdir. Bu değerlere uymamak işinizi kaybetmenize sebep oldu.',
        '1,1,1': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Olay tamamen sizin rüşvet girişiminiz yüzünden kontrolden çıktı ve sadece işinizi değil, otelcilik kariyerinizi de kaybettiniz. Dürüstlük ve çözüm odaklılık bir turizm personeli için vazgeçilmez iki değerdir.',
      },
      'receptionist_safe_theft': {
        '0,0,0': 'Gösterdiğiniz performans, bir yönetici vizyonunu yansıtmaktadır. Personeli haksız ithamlardan korudunuz ve otelin güvenilir imajını sağlam tuttunuz. Personel motivasyonunu düşünmeniz ve dosya uyarısı gibi idari adımlar için şefinizle görüşmeniz de oldukça uygundu.',
        '0,0,1': 'Gösterdiğiniz performans sayesinde kriz çözüldü ve personeliniz aklandı. Ancak haksız yere suçlanan kat görevlisini motive edecek bir takdir jesti için şefinize danışmanız daha uygun olabilirdi. Ayrıca asılsız iddiayı misafir dosyasına kaydetmeniz, ileriki dönemlerde oluşabilecek aynı misafir kaynaklı benzer sorunlarda yardımcı olabilir.',
        '0,1,0': 'Log raporu elimizdeyken bütçeden haksız ödeme teklif etmeniz hataydı. Şefinize danışarak teşekkür yemeği düzenlemeniz en azından personelin kırgınlığını biraz giderdi. Bu tür finansal kararlarda dikkatli olmanızı ve çıkardığınız dersler doğrultusunda krizi tekrar yönetmenizi öneririm.',
        '0,1,1': 'Gösterdiğiniz performans yetersiz kaldı. Log raporuna rağmen haksız ödeme teklif ettiniz. Personeller otelin can damarıdır. Ama siz personelin yaşadığı moral bozukluğunu gidermek için hiçbir adım atmadınız. Bu tür finansal kararlarda dikkatli olmanızı öneririm.',
        '1,0,0': 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. Personelinizi misafirin önünde tehdit etmek büyük bir hatadır. Şefinize danışarak teşekkür yemeği organize etmeniz durumu yatıştırsa da otel bütçesine büyük zarar verdi. Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.',
        '1,0,1': 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. Personelin rencide olmasına sebep oldunuz ve şefinizden sert bir uyarı aldınız. Ayrıca durumu düzeltmek için personele hiçbir telafi sunmayıp özür dilemekle yetindiniz. Ekip içi güven sarsıldı ve kat personelleri artık huzursuz çalışıyor.',
        '1,1,0': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Kendi personelinizi suçlayıp istifaya zorlamak ve hatanızı telafi etmeye çalışmamak hem otel itibarını zedeler hem de kariyerinizi. Dürüstlük, kibarlık ve çözüm odaklılık bir turizm personeli için vazgeçilmez üç değerdir.',
        '1,1,1': 'Kriz yönetimi becerileriniz üzerinde çok daha fazla durmanız ve kendinizi geliştirmeniz gerekiyor. Kendi personelinizi suçlayıp istifaya zorlamak, hatanızı telafi etmeye çalışmamak ve üstüne dik başlılık yapmak hem otel itibarını zedeler hem de kariyerinizi. Bu seçimler sonucunda hem işinizden oldunuz hem de başka bir otelde çalışma imkanını tamamen kaybederek kariyerinize son verdiniz.',
      },
    };

    final scenarioReports = allReports[scenarioId];
    if (scenarioReports == null) {
      return 'Bu senaryo için değerlendirme raporu bulunamadı.';
    }

    return scenarioReports[path] ??
        'Bu vakadaki tecrübelerinizden ders çıkararak krizi tekrar yönetmenizi öneririm.';
  }

  /// Seçilen seçeneklerin her adımdaki index'ini "," ile birleştirir.
  /// Örn: step_1 → seçenek 1 (0), step_2_good → seçenek 2 (1), step_3_excellent → seçenek 1 (0) → "0,1,0"
  String _buildPath(ScenarioState state) {
    final scenario = state.currentScenario;
    if (scenario == null) return '';

    final List<String> indices = [];
    String? currentStepId = 'step_1';

    for (final option in state.selectedOptions) {
      final step = scenario.steps[currentStepId];
      if (step == null) break;

      final idx = step.options.indexOf(option);
      indices.add(idx.toString());

      currentStepId = option.nextStepId;
    }

    return indices.join(',');
  }
}
