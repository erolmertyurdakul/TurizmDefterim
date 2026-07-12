class WordSearchCategory {
  final String id;
  final String name;
  final List<String> words;

  const WordSearchCategory({
    required this.id,
    required this.name,
    required this.words,
  });
}

class WordSearchData {
  static const List<WordSearchCategory> categories = [
    WordSearchCategory(
      id: 'on_buro',
      name: 'Ön Büro',
      words: ['CHECKIN', 'CHECKOUT', 'REZERVASYON', 'VALİZ', 'RESEPSİYON', 'BELLBOY', 'VOUCHER', 'KONTENJAN'],
    ),
    WordSearchCategory(
      id: 'mutfak',
      name: 'Yiyecek & İçecek',
      words: ['MENÜ', 'ADİSYON', 'GARNİTÜR', 'İÇECEK', 'AÇIKBÜFE', 'SERVİS', 'BANQUET', 'PORSİYON'],
    ),
    WordSearchCategory(
      id: 'havacilik',
      name: 'Havacılık',
      words: ['BOARDING', 'CHARTER', 'TURİST', 'PASAPORT', 'VİZE', 'TERMİNAL', 'KABİN', 'BİLET'],
    ),
    WordSearchCategory(
      id: 'kat_hizmetleri',
      name: 'Kat Hizmetleri',
      words: ['ÇARŞAF', 'YASTIK', 'TEMİZLİK', 'HİJYEN', 'HAVLU', 'DÜZEN', 'KORİDOR', 'ASANSÖR'],
    ),
    WordSearchCategory(
      id: 'alternatif_turizm',
      name: 'Alternatif Turizm',
      words: ['DOĞA', 'YAYLA', 'KAMP', 'TERMAL', 'MAĞARA', 'SPOR', 'SAĞLIK', 'EKOLOJİ'],
    ),
    WordSearchCategory(
      id: 'dunya_kulturleri',
      name: 'Dünya Kültürleri',
      words: ['MAORİ', 'ABORJİN', 'TAPINAK', 'MİRAS', 'GELENEK', 'FESTİVAL', 'DANS', 'LİSAN'],
    ),
    WordSearchCategory(
      id: 'surdurulebilir_turizm',
      name: 'Sürdürülebilir Turizm',
      words: ['EKOSİSTEM', 'KORUMA', 'ATIK', 'ENERJİ', 'GERİDÖNÜŞÜM', 'KARBON', 'DOĞAL', 'YEŞİL'],
    ),
    WordSearchCategory(
      id: 'turizm_cografya',
      name: 'Turizm Coğrafyası',
      words: ['KANYON', 'ŞELALE', 'AKARSU', 'DENİZ', 'DAĞLAR', 'GEÇİT', 'KÖRFEZ', 'ADALAR'],
    ),
    WordSearchCategory(
      id: 'kongre_etkinlik',
      name: 'Kongre & Etkinlik',
      words: ['KONGRE', 'PANEL', 'FORUM', 'SEMİNER', 'TOPLANTI', 'FUAR', 'SAHNE', 'ETKİNLİK'],
    ),
    WordSearchCategory(
      id: 'dijital_turizm',
      name: 'Dijital Turizm',
      words: ['İNTERNET', 'YORUM', 'BLOG', 'WEB', 'REZERVASYON', 'MOBİL', 'ÇEVRİMİÇİ', 'TEKNOLOJİ'],
    ),
    WordSearchCategory(
      id: 'kultur_mirasi',
      name: 'Kültür Mirası',
      words: ['MÜZE', 'SARAY', 'HÖYÜK', 'KALE', 'ANIT', 'KURGAN', 'KİLİSE', 'KAZI'],
    ),
    WordSearchCategory(
      id: 'mesleki_gelisim',
      name: 'Mesleki Gelişim',
      words: ['ETİK', 'İLETİŞİM', 'EĞİTİM', 'KARİYER', 'VİZYON', 'EMPATİ', 'BAŞARI', 'SAYGI'],
    ),
    WordSearchCategory(
      id: 'animasyon_rekreasyon',
      name: 'Animasyon & Rekreasyon',
      words: ['OYUN', 'AKTİVİTE', 'EĞLENCE', 'SPOR', 'MÜZİK', 'TİYATRO', 'ÇOCUK', 'KULÜP'],
    ),
    WordSearchCategory(
      id: 'seyahat_acentasi',
      name: 'Seyahat Acentacılığı',
      words: ['BİLET', 'TRANSFER', 'REHBER', 'TURİST', 'BROŞÜR', 'CHARTER', 'PASAPORT', 'VİZE'],
    ),
    WordSearchCategory(
      id: 'gastronomi',
      name: 'Gastronomi Turizmi',
      words: ['YÖRESEL', 'MUTFAK', 'LEZZET', 'SUNUM', 'YEMEK', 'MENÜ', 'BAHARAT', 'GIDA'],
    ),
    WordSearchCategory(
      id: 'ekoturizm',
      name: 'Ekoturizm',
      words: ['FLORA', 'FAUNA', 'PATİKA', 'KAMP', 'ORMAN', 'ÇEVRE', 'KORUMA', 'DOĞAL'],
    ),
    WordSearchCategory(
      id: 'saglik_turizmi',
      name: 'Sağlık Turizmi',
      words: ['TERMAL', 'KAPLICA', 'HİJYEN', 'KLİNİK', 'FİZİK', 'ÇAMUR', 'MEDİKAL', 'TEDAVİ'],
    ),
    WordSearchCategory(
      id: 'kruvaziyer_deniz',
      name: 'Kruvaziyer & Deniz',
      words: ['LİMAN', 'KAPTAN', 'ROTA', 'DENİZ', 'GEMİ', 'KAMARA', 'GÜVERTE', 'KÖRFEZ'],
    ),
    WordSearchCategory(
      id: 'kirsal_turizm',
      name: 'Kırsal Turizm',
      words: ['ÇİFTLİK', 'KÖY', 'DOĞAL', 'TARIM', 'YÖRESEL', 'KÜLTÜR', 'HASAT', 'PANSİYON'],
    ),
    WordSearchCategory(
      id: 'turizm_hukuku',
      name: 'Turizm Hukuku',
      words: ['KANUN', 'SÖZLEŞME', 'HAKLAR', 'YASA', 'MÜŞTERİ', 'ACENTE', 'TÜKETİCİ', 'KURAL'],
    ),
    WordSearchCategory(
      id: 'otomasyon_sistemleri',
      name: 'Otomasyon Sistemleri',
      words: ['YAZILIM', 'VERİTABANI', 'SİSTEM', 'RAPOR', 'KART', 'ODA', 'CHECKIN', 'CHECKOUT'],
    ),
    WordSearchCategory(
      id: 'turizm_tanitim',
      name: 'Turizm Tanıtımı',
      words: ['REKLAM', 'AFİŞ', 'FUAR', 'MARKA', 'PAZARLAMA', 'VİDEO', 'BROŞÜR', 'TANITIM'],
    ),
    WordSearchCategory(
      id: 'vip_hizmetler',
      name: 'VIP Hizmetler',
      words: ['SÜİT', 'LİMUZİN', 'İKRAM', 'ÖZEL', 'SERVİS', 'KARŞILAMA', 'HEDİYE', 'KONFOR'],
    ),
  ];
}
