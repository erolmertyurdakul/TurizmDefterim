class ProfanityFilterService {
  // Aşırı uzatmadan, ana küfür ve türevlerini yakalamak için temel kelimeler
  // (contains mantığıyla çalıştığı için ekleri de otomatik yakalar).
  static const List<String> _badWords = [
    'amk',
    'amq',
    'aq',
    'mk',
    'sg',
    'oc',
    'pic',
    'pust',
    'ibne',
    'yavsak',
    'orospu',
    'kahpe',
    'got',
    'siktir',
    'siker',
    'sikik',
    'amcik',
    'yarak',
    'yaram',
    'yarrak',
    'fuck',
    'bitch',
    'shit',
    'asshole',
    'cunt',
    'dick',
    'pussy',
    'slut',
    'whore',
    'bastard',
    'dumbass',
    'idiot',
    'aptal',
    'gerizekali',
    'salak',
    'mal',
    'embesil',
    'pezevenk',
    'gavat',
    'fahişe',
    'fahise',
  ];

  /// Gelen stringi temizleyerek (boşlukları silip, noktalama işaretlerini atıp, sayıları harfe çevirip) kötü kelime kontrolü yapar.
  /// Eğer stringin HERHANGİ BİR YERİNDE kötü kelime geçiyorsa `true` döner.
  static bool hasProfanity(String text) {
    if (text.isEmpty) return false;

    // 1. Tüm yazıyı küçük harfe çevir
    String normalized = text.toLowerCase();

    // 2. Türkçe karakterleri İngilizce eşdeğerlerine çevir (hata payını azaltmak için)
    normalized = normalized
        .replaceAll('ş', 's')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ı', 'i');

    // 3. Yaygın Leetspeak (sayı ve sembol) karakterlerini harfe dönüştür
    normalized = normalized
        .replaceAll('1', 'i')
        .replaceAll('3', 'e')
        .replaceAll('4', 'a')
        .replaceAll('0', 'o')
        .replaceAll('5', 's')
        .replaceAll('7', 't')
        .replaceAll('@', 'a')
        .replaceAll('\$', 's');

    // 4. Harf ve rakam DIŞINDAKİ her şeyi (boşluklar, noktalar, çizgiler, vb.) sil
    normalized = normalized.replaceAll(RegExp(r'[^a-z]'), '');

    // 5. Özel kısa küfür regex kontrolleri
    if (RegExp(r'\b(mk|aq|amk|amq|sg|oc)\b').hasMatch(normalized)) {
      return true;
    }

    // 6. Filtre kontrolü (tam veya içinde geçme durumu)
    for (String badWord in _badWords) {
      if (normalized.contains(badWord)) {
        return true; // Kötü kelime bulundu
      }
    }

    return false; // Temiz
  }
}
