import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Extract and update terminology', () {
    // 1. Read existing terminology_data.dart
    final terminologyFile = File('lib/core/data/terminology_data.dart');
    if (!terminologyFile.existsSync()) {
      fail('terminology_data.dart not found');
    }
    final content = terminologyFile.readAsStringSync();

    // Parse existing terms using RegExp
    // Format: Term(word: '...', definition: '...', example: '...', category: '...', [isEnglish: false])
    final termRegExp = RegExp(
      r"Term\(\s*word\s*:\s*'(.*?)'\s*,\s*definition\s*:\s*'(.*?)'\s*,\s*example\s*:\s*'(.*?)'\s*,\s*category\s*:\s*'(.*?)'\s*,(?:\s*isEnglish\s*:\s*(true|false)\s*,)?\s*\)",
      dotAll: true,
    );

    final List<Map<String, dynamic>> existingTerms = [];
    for (final match in termRegExp.allMatches(content)) {
      final word = match.group(1)!.trim();
      final definition = match.group(2)!.trim();
      final example = match.group(3)!.trim();
      final category = match.group(4)!.trim();
      bool isEnglish = true;
      if (match.group(5) != null) {
        isEnglish = match.group(5) == 'true';
      }
      existingTerms.add({
        'word': word,
        'definition': definition,
        'example': example,
        'category': category,
        'isEnglish': isEnglish,
      });
    }

    print('Found ${existingTerms.length} existing terms.');

    // 2. Remove duplicates from existing terms first
    final List<Map<String, dynamic>> uniqueExisting = [];
    final Set<String> seenWords = {};
    for (final term in existingTerms) {
      final key = term['word'].toString().toLowerCase().trim();
      if (!seenWords.contains(key)) {
        seenWords.add(key);
        uniqueExisting.add(term);
      } else {
        print('Removed duplicate from existing terms: ${term['word']}');
      }
    }

    // 3. Scan other files for new terms
    final List<Map<String, dynamic>> scannedTerms = [];
    final List<File> filesToScan = [];
    
    final coursesDir = Directory('lib/core/data/courses');
    if (coursesDir.existsSync()) {
      filesToScan.addAll(
        coursesDir.listSync().whereType<File>().where((f) => f.path.endsWith('.dart'))
      );
    }
    final lectureNotesFile = File('lib/core/data/lecture_notes.dart');
    if (lectureNotesFile.existsSync()) {
      filesToScan.add(lectureNotesFile);
    }

    print('Scanning ${filesToScan.length} files...');

    final noteTermRegExp = RegExp(
      r'["\'](?:name|word)["\']\s*:\s*["\']((?:[^\'"\\]|\\.)*)["\']\s*,\s*["\'](?:desc|definition)["\']\s*:\s*["\']((?:[^\'"\\]|\\.)*)["\'](?:,\s*["\']examples["\']\s*:\s*\[\s*["\']((?:[^\'"\\]|\\.)*)["\']\s*\])?',
      dotAll: true,
    );

    // Language heuristics
    bool hasTurkishChars(String s) {
      const turkishChars = 'çğıöşüÇĞİÖŞÜ';
      return s.split('').any((char) => turkishChars.contains(char));
    }

    bool isEnglishTerm(String word) {
      final w = word.toLowerCase();
      if (hasTurkishChars(word)) return false;

      const englishKeywords = [
        "check-in", "check-out", "no-show", "overbooking", "voucher", "pax", "walk-in", "upgrade", 
        "downgrade", "folio", "late", "early", "inclusive", "board", "room only", "housekeeping", 
        "vip", "turndown", "clean", "dirty", "out of", "discrepancy", "complimentary", "charter", 
        "info tour", "black list", "chart", "city ledger", "door rate", "rack rate", "spa", "golf", 
        "connecting", "adjoining", "cabana", "president", "junior", "suite", "corner", "hospitality", 
        "executive", "efficiency", "single", "double", "triple", "quad", "twin", "french", "queen", 
        "king", "regular", "free", "house use", "repeat", "guest", "cip", "deadline", "waitlist", 
        "email order", "forecast", "closed out", "request", "fom", "stop sales", "extension", 
        "cittaslow", "glamping", "dark", "agro", "diaspora", "eco", "overbooking"
      ];
      for (final kw in englishKeywords) {
        if (w.contains(kw)) return true;
      }

      const turkishWords = [
        "blokaj", "bloke", "transfer", "komisyon", "depozito", "iskonto", "kapora", "konfirmasyon",
        "konsultasyon", "literatur", "manuel", "opsiyon", "paravan", "prosedur", "rumuz", "teyit", 
        "vardiya", "oda", "kahvalti", "yatak", "pansiyon", "kral", "dairesi", "bitisik", "baglantili",
        "yakin", "mutfak", "bolmeli", "ozel", "gereksinimli", "birey", "seçenek", "konsept", 
        "münferit", "grup", "geliş", "saati", "kesin", "türleri", "güvenceleri", "kabul", "yazılı",
        "bildirim", "zorunluluğu", "kontrol", "listesi", "otomasyonun", "faydaları", "değişiklik",
        "iptal", "tarihi", "süresi", "bekleyen", "yöntemleri", "cetveller", "duvar", "dijital",
        "web", "tabanlı", "bulut", "otomasyon", "satış", "dinamikleri", "hesaplamalar", "risk",
        "yönetimi", "shorta", "düşmek", "şorta", "kontrol", "mekanizmaları", "kapanış", "tahminleme",
        "sağlık", "sporları", "hava", "dağcılık", "kaya", "tırmanışı", "su", "altı", "dalış",
        "akarsu", "inanç", "yolu", "kırsal", "çiftlik", "yayla", "yeni", "nesil", "akımları",
        "hüzün", "kıyamet", "yavaş", "kuşağı", "uzay", "yat", "etkinlik", "helal", "kuru", "temizleme",
        "çamaşırhane", "coğrafyası", "kültürleri"
      ];
      for (final tw in turkishWords) {
        if (w.contains(tw)) return false;
      }

      if (word == word.toUpperCase() && word.length <= 5) return true;

      return false;
    }

    for (final file in filesToScan) {
      final fileContent = file.readAsStringSync();
      final fileBasename = file.path.split('/').last.split('\\').last;

      String category = "Genel";
      if (fileBasename.contains("alternatif_turizm")) {
        category = "Alternatif Turizm";
      } else if (fileBasename.contains("kuru_temizleme")) {
        category = "Kuru Temizleme";
      } else if (fileBasename.contains("camasirhane")) {
        category = "Çamaşırhane";
      } else if (fileBasename.contains("dunya_cografyasi")) {
        category = "Turizm Coğrafyası";
      } else if (fileBasename.contains("dunya_kulturleri")) {
        category = "Dünya Kültürleri";
      } else if (fileBasename.contains("kongre_etkinlik")) {
        category = "Kongre & Etkinlik";
      } else if (fileBasename.contains("gastronomi_turizmi")) {
        category = "Gastronomi Turizmi";
      } else if (fileBasename.contains("tur_operasyonu")) {
        category = "Tur Operasyonu";
      } else if (fileBasename.contains("transfer_operasyonu")) {
        category = "Transfer Operasyonu";
      } else if (fileBasename.contains("sosyal_medya")) {
        category = "Sosyal Medya";
      } else if (fileBasename.contains("konaklama_isletmeciligi")) {
        category = "Konaklama İşletmeciliği";
      } else if (fileBasename.contains("surdurulebilir_turizm")) {
        category = "Sürdürülebilir Turizm";
      } else if (fileBasename.contains("kat_hizmetleri")) {
        category = "Kat Hizmetleri";
      } else if (fileBasename.contains("konuk_giris_cikis")) {
        category = "Ön Büro & Rezervasyon";
      } else if (fileBasename.contains("mesleki_gelisim")) {
        category = "Mesleki Gelişim";
      } else if (fileBasename.contains("lecture_notes")) {
        category = "Ön Büro & Rezervasyon";
      }

      int matchesInFile = 0;
      for (final match in noteTermRegExp.allMatches(fileContent)) {
        var name = match.group(1)!.replaceAll('\\"', '"').replaceAll("\\'", "'").replaceAll('\\n', '\n').trim();
        var desc = match.group(2)!.replaceAll('\\"', '"').replaceAll("\\'", "'").replaceAll('\\n', '\n').trim();
        var example = '';
        if (match.group(3) != null) {
          example = match.group(3)!.replaceAll('\\"', '"').replaceAll("\\'", "'").replaceAll('\\n', '\n').trim();
          example = example.replaceAll(RegExp(r'^(?:Örnekle\s+Pekiştirelim:\s*|Örnek\s+Pekiştirme:\s*|Örnek:\s*|Örnekle\s+pekiştirelim:\s*)', caseSensitive: false), '');
        }

        bool isEng = isEnglishTerm(name);
        final firstWord = name.split(' ').first;
        if (hasTurkishChars(firstWord)) {
          isEng = false;
        }

        scannedTerms.add({
          'word': name,
          'definition': desc,
          'example': example,
          'category': category,
          'isEnglish': isEng,
        });
        matchesInFile++;
      }
      print('File $fileBasename: found $matchesInFile matches.');
    }

    // 4. Combine existing unique and scanned unique
    final List<Map<String, dynamic>> finalTerms = List.from(uniqueExisting);
    int newTermsCount = 0;
    for (final term in scannedTerms) {
      final key = term['word'].toString().toLowerCase().trim();
      if (!seenWords.contains(key)) {
        seenWords.add(key);
        finalTerms.add(term);
        newTermsCount++;
        print('Added new term: ${term['word']} (${term['category']}) - isEnglish: ${term['isEnglish']}');
      }
    }

    print('Added $newTermsCount new terms. Total: ${finalTerms.length}');

    // 5. Generate Dart output code
    var code = '''class Term {
  final String word;
  final String definition;
  final String example;
  final String category;
  final bool isEnglish;

  const Term({
    required this.word,
    required this.definition,
    required this.example,
    required this.category,
    this.isEnglish = true,
  });
}

const List<Term> terminologyData = [
''';

    final categoriesOrder = [
      'Ön Büro & Rezervasyon',
      'Kat Hizmetleri',
      'Seyahat & Operasyon',
      'Muhasebe & Finans',
      'Alternatif Turizm',
      'Kuru Temizleme',
      'Çamaşırhane',
      'Turizm Coğrafyası',
      'Dünya Kültürleri',
      'Kongre & Etkinlik',
      'Gastronomi Turizmi',
      'Tur Operasyonu',
      'Transfer Operasyonu',
      'Sosyal Medya',
      'Konaklama İşletmeciliği',
      'Sürdürülebilir Turizm',
      'Mesleki Gelişim',
      'Genel'
    ];

    final presentCategories = finalTerms.map((t) => t['category'] as String).toSet();
    final allCategories = categoriesOrder.where((c) => presentCategories.contains(c)).toList();
    for (final c in presentCategories) {
      if (!allCategories.contains(c)) {
        allCategories.add(c);
      }
    }

    for (final cat in allCategories) {
      final catTerms = finalTerms.where((t) => t['category'] == cat).toList();
      if (catTerms.isEmpty) continue;

      code += '  // ── ${cat.toUpperCase()} TERİMLERİ ──\n';
      for (final t in catTerms) {
        final w = t['word'].toString().replaceAll("'", "\\'");
        final d = t['definition'].toString().replaceAll("'", "\\'");
        final ex = t['example'].toString().replaceAll("'", "\\'");
        final c = t['category'].toString().replaceAll("'", "\\'");
        final isEng = t['isEnglish'] as bool;

        var isEngLine = '';
        if (!isEng) {
          isEngLine = '    isEnglish: false,\n';
        }

        code += '  Term(\n';
        code += "    word: '$w',\n";
        code += "    definition: '$d',\n";
        code += "    example: '$ex',\n";
        code += "    category: '$c',\n";
        if (isEngLine.isNotEmpty) {
          code += isEngLine;
        }
        code += '  ),\n';
      }
      code += '\n';
    }

    code += '];\n';

    terminologyFile.writeAsStringSync(code);
    print('Successfully wrote ${finalTerms.length} terms to ${terminologyFile.path}');
  });
}
