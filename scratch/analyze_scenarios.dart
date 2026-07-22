import 'dart:io';
import '../lib/features/scenarios/data/scenario_database.dart';
import '../lib/features/scenarios/domain/models/scenario_models.dart';

void main() {
  final outputFile = File('C:/Users/erolm/Desktop/vaka_analizleri_akisi.txt');
  final buffer = StringBuffer();

  buffer.writeln('================================================================================');
  buffer.writeln('                     VAKA ANALİZLERİ AKIŞ VE DEĞERLENDİRME RAPORU               ');
  buffer.writeln('================================================================================\n');
  buffer.writeln('Bu dosya, uygulamadaki tüm vaka analizlerinin (senaryolarının) soru-cevap akışlarını,');
  buffer.writeln('verilen cevapların skorlara etkilerini ve ulaşılan sonuçlardaki değerlendirme raporlarını');
  buffer.writeln('göstermektedir. Yollardaki oklar akış yönünü temsil eder.\n');
  buffer.writeln('Kullanıcı Başlangıç Değerleri:');
  buffer.writeln('  - Memnuniyet: 70/100');
  buffer.writeln('  - Bütçe: 500\$');
  buffer.writeln('  - Prestij: 75/100');
  buffer.writeln('  - Boyut Skorları (Misafir Odaklılık, Finansal Disiplin, Risk Yönetimi, Dürüstlük): 0\n');

  for (final scenario in ScenarioDatabase.scenarios) {
    buffer.writeln('================================================================================');
    buffer.writeln('SENARYO: ${scenario.title} (${scenario.department} - ${scenario.difficulty})');
    buffer.writeln('Açıklama: ${scenario.description}');
    buffer.writeln('================================================================================\n');

    // 1. Akış Ağacını Çiz
    buffer.writeln('--- AKIŞ ŞEMASI (AĞAÇ YAPISI) ---');
    _buildTreeString(scenario, 'step_1', '', buffer);
    buffer.writeln('\n');

    // 2. DFS ile tüm yolları ve detaylı sonuçları listele
    final List<List<PathStep>> paths = [];
    _findPaths(scenario, 'step_1', [], paths);

    buffer.writeln('--- OYNANIŞ YOLLARI VE DEĞERLENDİRME RAPORLARI ---');
    buffer.writeln('Bu senaryo için toplam ${paths.length} farklı oynanış yolu bulunmaktadır.\n');

    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      buffer.writeln('--------------------------------------------------------------------------------');
      buffer.writeln('YOL #${i + 1}:');
      buffer.writeln('--------------------------------------------------------------------------------');

      int currentSat = 70;
      int currentBug = 500;
      int currentRep = 75;
      int guestCentricity = 0;
      int financialDiscipline = 0;
      int riskManagement = 0;
      int professionalHonesty = 0;

      for (int stepIdx = 0; stepIdx < path.length; stepIdx++) {
        final pathStep = path[stepIdx];
        final step = pathStep.step;
        final option = pathStep.option;

        buffer.writeln('  [Adım: ${step.id}] ${step.title}');
        buffer.writeln('  Soru: ${step.story.replaceAll('\n', ' ')}');
        buffer.writeln('    ==> SEÇİLEN CEVAP: "${option.text}"');
        buffer.writeln('        [Skor Değişimleri] Memnuniyet: ${option.satisfactionEffect >= 0 ? '+' : ''}${option.satisfactionEffect}, Bütçe: ${option.budgetEffect >= 0 ? '+' : ''}${option.budgetEffect}\$, Prestij: ${option.reputationEffect >= 0 ? '+' : ''}${option.reputationEffect}');
        buffer.writeln('        [Boyut Değişimleri] Misafir Odaklılık: ${option.dimensionScores.guestCentricity >= 0 ? '+' : ''}${option.dimensionScores.guestCentricity}, Finansal Disiplin: ${option.dimensionScores.financialDiscipline >= 0 ? '+' : ''}${option.dimensionScores.financialDiscipline}, Risk Yönetimi: ${option.dimensionScores.riskManagement >= 0 ? '+' : ''}${option.dimensionScores.riskManagement}, Mesleki Dürüstlük: ${option.dimensionScores.professionalHonesty >= 0 ? '+' : ''}${option.dimensionScores.professionalHonesty}');
        buffer.writeln('        Erol Hoca Analizi: ${option.feedback}');

        currentSat = (currentSat + option.satisfactionEffect).clamp(0, 100);
        currentBug = (currentBug + option.budgetEffect).clamp(0, 1000);
        currentRep = (currentRep + option.reputationEffect).clamp(0, 100);
        guestCentricity += option.dimensionScores.guestCentricity;
        financialDiscipline += option.dimensionScores.financialDiscipline;
        riskManagement += option.dimensionScores.riskManagement;
        professionalHonesty += option.dimensionScores.professionalHonesty;

        if (stepIdx < path.length - 1) {
          buffer.writeln('             │');
          buffer.writeln('             ▼');
        }
      }

      // Sonuç Değerlendirmesi
      final ds = DimensionScores(
        guestCentricity: guestCentricity,
        financialDiscipline: financialDiscipline,
        riskManagement: riskManagement,
        professionalHonesty: professionalHonesty,
      );

      // Unvan
      String professionalTitle = 'Gelişmekte Olan Turizm Profesyoneli';
      if (guestCentricity >= 15 && financialDiscipline <= -5) {
        professionalTitle = 'Misafir Dostu Diplomat';
      } else if (financialDiscipline >= 15 && guestCentricity <= -5) {
        professionalTitle = 'Mali Muhafazakar Yönetici';
      } else if (riskManagement <= -15) {
        professionalTitle = 'Risk Sever Kumarbaz';
      } else if (professionalHonesty >= 15 && riskManagement >= 5) {
        professionalTitle = 'Şeffaf ve Etik Kriz Lideri';
      } else if (guestCentricity >= 8 && financialDiscipline >= 5) {
        professionalTitle = 'Dengeli Operasyon Stratejisti';
      }

      // Rozet
      final badgeScore = (currentSat + (currentBug ~/ 5) + currentRep) ~/ 3;
      String badgeName = 'Stajyer Rozeti 🎖️';
      if (badgeScore >= 85) badgeName = 'Altın Hizmet Nişanı 🏆';
      else if (badgeScore >= 60) badgeName = 'Gümüş Kriz Yöneticisi 🥈';

      // Erol Hoca Raporu
      String finalQuote;
      if (guestCentricity >= 8 && financialDiscipline >= 4) {
        finalQuote = 'Gösterdiğiniz üstün performans, üst düzey bir yönetici vizyonunu yansıtmaktadır. Hem misafir memnuniyetini en üst seviyede tuttunuz hem de işletme bütçesini korudunuz. Turizm sektörü, sizin gibi dengeli ve basiretli yöneticilere ihtiyaç duymaktadır. Başarılarınızın devamını dilerim.';
      } else if (guestCentricity >= 8) {
        finalQuote = 'Misafir odaklı yaklaşımınız ve yüksek empati düzeyiniz oldukça takdire şayandır. Ancak sürdürülebilir bir otel işletmeciliği için bütçe dengesinin ve finansal disiplinin de korunması gerektiğini unutmamalısınız. Bir sonraki simülasyonda işletme kaynaklarını daha dengeli yönetmeye özen göstermeniz tavsiye edilir.';
      } else if (financialDiscipline >= 8) {
        finalQuote = 'Finansal kaynakları ve bütçe disiplinini koruma konusundaki hassasiyetiniz oldukça başarılıdır. Ancak misafir memnuniyetini geri plana itmek, uzun vadede işletmenin itibarını ve doluluk oranlarını olumsuz etkileyebilir. Turizmde öncelikli odak noktası insan memnuniyetidir; bu nedenle kararlarınızda empati düzeyini artırmanız tavsiye edilir.';
      } else if (riskManagement <= -8) {
        finalQuote = 'Operasyonel süreçlerde aldığınız riskler, işletme güvenliği ve standartları açısından yüksek risk teşkil etmektedir. Standart dışı ve kontrolsüz uygulamalar, gerçek iş yaşamında telafisi güç prestij ve itibar kayıplarına yol açabilir. Kararlarınızda risk yönetimini ve iş standartlarını daima ön planda tutmalısınız.';
      } else {
        finalQuote = 'Kriz yönetimi becerilerinizi daha da geliştirmeniz yararlı olacaktır. Karşılaştığınız durumlarda daha dengeli ve sakin kararlar alarak işletme performansını artırabilirsiniz. Bu simülasyondaki tecrübelerinizden ders çıkararak çalışmayı tekrar oynamanızı öneririm.';
      }

      buffer.writeln('\n  [YOL SONU TOPLAM SKORLARI VE DURUMU]');
      buffer.writeln('    * Memnuniyet: $currentSat/100 | Bütçe: \$$currentBug | Prestij: $currentRep/100');
      buffer.writeln('    * Misafir Odaklılık: $guestCentricity | Finansal Disiplin: $financialDiscipline | Risk Yönetimi: $riskManagement | Mesleki Dürüstlük: $professionalHonesty');
      buffer.writeln('    * Hak Edilen Rozet: $badgeName');
      buffer.writeln('    * Mesleki Unvan: $professionalTitle');
      buffer.writeln('    * Erol Hoca Değerlendirme Raporu:');
      buffer.writeln('      "$finalQuote"');
      buffer.writeln('--------------------------------------------------------------------------------\n');
    }
  }

  outputFile.writeAsStringSync(buffer.toString());
  print('SUCCESS: Analiz tamamlandı. Dosya masaüstüne kaydedildi: ${outputFile.path}');
}

class PathStep {
  final ScenarioStep step;
  final ScenarioOption option;
  PathStep(this.step, this.option);
}

void _findPaths(Scenario scenario, String stepId, List<PathStep> currentPath, List<List<PathStep>> allPaths) {
  final step = scenario.steps[stepId];
  if (step == null) return;

  for (final option in step.options) {
    final nextPath = List<PathStep>.from(currentPath)..add(PathStep(step, option));
    if (option.nextStepId == null) {
      allPaths.add(nextPath);
    } else {
      _findPaths(scenario, option.nextStepId!, nextPath, allPaths);
    }
  }
}

void _buildTreeString(Scenario scenario, String stepId, String prefix, StringBuffer buffer) {
  final step = scenario.steps[stepId];
  if (step == null) return;

  buffer.writeln('$prefix└── [Soru Adımı: $stepId] "${step.title}"');
  buffer.writeln('$prefix    Hikaye: ${step.story.replaceAll('\n', ' ')}');

  for (int i = 0; i < step.options.length; i++) {
    final option = step.options[i];
    final isLastOption = i == step.options.length - 1;
    final childPrefix = prefix + (isLastOption ? '        ' : '    │   ');

    buffer.writeln('$prefix    ${isLastOption ? '└──' : '├──'} [Seçenek ${i + 1}] "${option.text}"');
    buffer.writeln('$childPrefix Skorlar: Memn(${option.satisfactionEffect >= 0 ? '+' : ''}${option.satisfactionEffect}), Bütçe(${option.budgetEffect >= 0 ? '+' : ''}${option.budgetEffect}\$), Pres(${option.reputationEffect >= 0 ? '+' : ''}${option.reputationEffect})');
    buffer.writeln('$childPrefix Boyutlar: MisOda(${option.dimensionScores.guestCentricity >= 0 ? '+' : ''}${option.dimensionScores.guestCentricity}), FinDis(${option.dimensionScores.financialDiscipline >= 0 ? '+' : ''}${option.dimensionScores.financialDiscipline}), RiskYön(${option.dimensionScores.riskManagement >= 0 ? '+' : ''}${option.dimensionScores.riskManagement}), Dürüst(${option.dimensionScores.professionalHonesty >= 0 ? '+' : ''}${option.dimensionScores.professionalHonesty})');
    buffer.writeln('$childPrefix Hoca Feedback: "${option.feedback}"');

    if (option.nextStepId != null) {
      buffer.writeln('$childPrefix │');
      _buildTreeString(scenario, option.nextStepId!, childPrefix, buffer);
    } else {
      buffer.writeln('$childPrefix └── [SONUÇ] (Senaryo bu kararla sonlanır)');
    }
  }
}
