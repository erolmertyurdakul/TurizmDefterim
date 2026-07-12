import 'dart:math';

/// Resepsiyon Simülatörü - Oyun Veri Sabitleri
/// Ön büro personeli yetiştirmek için tasarlanmış eğitici simülasyon.

// ══════════════════════════════════════════
//  OYUN FAZLARI & GERİ BİLDİRİM
// ══════════════════════════════════════════

enum GamePhase { intro, tutorial, playing, levelUp, gameOver }

enum FeedbackType { perfect, correct, partial, wrong, guestLeft }

// ══════════════════════════════════════════
//  ODA TİPLERİ
// ══════════════════════════════════════════

enum RoomType {
  standart(
    emoji: '🏠',
    displayName: 'Standart Oda',
    price: 800,
    minLevel: 0,
    tip: 'Standart oda, otellerde en çok tercih edilen oda tipidir.',
  ),
  kose(
    emoji: '📐',
    displayName: 'Köşe Oda',
    price: 1100,
    minLevel: 1,
    tip: 'Köşe odalar, binanın köşelerinde yer alan, standart odalardan biraz daha geniş olan ve genellikle çift cepheli olup iki farklı manzarayı birden gören odalardır.',
  ),
  executive(
    emoji: '👔',
    displayName: 'Executive Oda',
    price: 1300,
    minLevel: 1,
    tip: 'Yönetici odaları (Executive Room), geniş çalışma masası ve prizler gibi iş odaklı donanımlarla CIP misafirlere hitap eder.',
  ),
  aile(
    emoji: '👨‍👩‍👧‍👦',
    displayName: 'Aile Odası',
    price: 1500,
    minLevel: 2,
    tip: 'Aile odaları geniş yapılıdır ve genellikle ek yatak imkânı sunar.',
  ),
  ozelGereksinim(
    emoji: '♿',
    displayName: 'Özel Gereksinimli Birey Odası',
    price: 900,
    minLevel: 2,
    tip: 'Özel gereksinimli birey odaları geniş kapı, erişilebilir banyo ve tutunma barları içerir.',
  ),
  baglantili(
    emoji: '🚪',
    displayName: 'Bağlantılı Oda',
    price: 1800,
    minLevel: 3,
    tip: 'Bağlantılı odalar, aralarında geçişi sağlayan bir iç kapı bulunan iki odadır.',
  ),
  bitisik(
    emoji: '🧱',
    displayName: 'Bitişik Oda',
    price: 1600,
    minLevel: 3,
    tip: 'Bitişik odalar, yan yana bulunan ancak aralarında doğrudan bir geçiş kapısı olmayan odalardır.',
  ),
  suite(
    emoji: '🏨',
    displayName: 'Suite Oda',
    price: 3500,
    minLevel: 4,
    tip: 'Suite odalar ayrı oturma odası ile misafire özel yaşam alanı sunar.',
  ),
  kralDairesi(
    emoji: '👑',
    displayName: 'Kral Dairesi',
    price: 6000,
    minLevel: 6,
    tip: 'Kral dairesi, otelin en prestijli odası olup VIP ve CIP misafirlere önerilir.',
  );

  const RoomType({
    required this.emoji,
    required this.displayName,
    required this.price,
    required this.minLevel,
    required this.tip,
  });

  final String emoji;
  final String displayName;
  final int price;
  final int minLevel;
  final String tip;
}

// ══════════════════════════════════════════
//  PANSİYON DURUMLARI
// ══════════════════════════════════════════

enum BoardType {
  sadeceOda(
    emoji: '🚫',
    displayName: 'Sadece Oda',
    shortName: 'RO',
    price: 0,
    minLevel: 0,
    tip: 'Room Only (RO): Konaklama ücretine yemek dahil değildir.',
  ),
  odaKahvalti(
    emoji: '☕',
    displayName: 'Oda + Kahvaltı',
    shortName: 'B&B',
    price: 150,
    minLevel: 0,
    tip: 'Bed & Breakfast (B&B): Sadece sabah kahvaltısı dahildir.',
  ),
  yarimPansiyon(
    emoji: '🍽️',
    displayName: 'Yarım Pansiyon',
    shortName: 'HP',
    price: 300,
    minLevel: 1,
    tip: 'Half Pension (HP): Kahvaltı ve akşam yemeği dahildir.',
  ),
  tamPansiyon(
    emoji: '🍴',
    displayName: 'Tam Pansiyon',
    shortName: 'FB',
    price: 500,
    minLevel: 2,
    tip: 'Full Board (FB): Kahvaltı, öğle ve akşam yemeği dahildir.',
  ),
  herSeyDahil(
    emoji: '🌟',
    displayName: 'Her Şey Dahil',
    shortName: 'AI',
    price: 800,
    minLevel: 3,
    tip: 'All Inclusive (AI): Tüm yemekler ve yerli içecekler dahildir.',
  ),
  ultraHerSeyDahil(
    emoji: '👑',
    displayName: 'Ultra Her Şey Dahil',
    shortName: 'UAI',
    price: 1200,
    minLevel: 5,
    tip: 'Ultra All Inclusive (UAI): Premium içecekler ve ekstra hizmetler de dahildir.',
  );

  const BoardType({
    required this.emoji,
    required this.displayName,
    required this.shortName,
    required this.price,
    required this.minLevel,
    required this.tip,
  });

  final String emoji;
  final String displayName;
  final String shortName;
  final int price;
  final int minLevel;
  final String tip;
}

// ══════════════════════════════════════════
//  MİSAFİR TİPLERİ
// ══════════════════════════════════════════

enum GuestType {
  normal(
    emoji: '🧑',
    displayName: 'Bireysel Misafir',
    patienceMultiplier: 1.0,
    pointMultiplier: 1.0,
    minLevel: 0,
  ),
  turistGrup(
    emoji: '🎒',
    displayName: 'Turist Grubu',
    patienceMultiplier: 0.9,
    pointMultiplier: 1.2,
    minLevel: 0,
  ),
  isInsani(
    emoji: '💼',
    displayName: 'İş İnsanı',
    patienceMultiplier: 0.7,
    pointMultiplier: 1.5,
    minLevel: 1,
  ),
  aile(
    emoji: '👨‍👩‍👧‍👦',
    displayName: 'Aile',
    patienceMultiplier: 1.3,
    pointMultiplier: 1.2,
    minLevel: 2,
  ),
  yasliCift(
    emoji: '👴',
    displayName: 'Yaşlı Çift',
    patienceMultiplier: 1.5,
    pointMultiplier: 1.0,
    minLevel: 2,
  ),
  ozelGereksinim(
    emoji: '♿',
    displayName: 'Özel Gereksinimli Misafir',
    patienceMultiplier: 1.2,
    pointMultiplier: 1.3,
    minLevel: 2,
  ),
  vip(
    emoji: '⭐',
    displayName: 'VIP Misafir',
    patienceMultiplier: 0.6,
    pointMultiplier: 3.0,
    minLevel: 4,
  ),
  balayi(
    emoji: '💑',
    displayName: 'Balayı Çifti',
    patienceMultiplier: 0.8,
    pointMultiplier: 2.0,
    minLevel: 4,
  );

  const GuestType({
    required this.emoji,
    required this.displayName,
    required this.patienceMultiplier,
    required this.pointMultiplier,
    required this.minLevel,
  });

  final String emoji;
  final String displayName;
  final double patienceMultiplier;
  final double pointMultiplier;
  final int minLevel;
}

// ══════════════════════════════════════════
//  ÖZEL İSTEKLER
// ══════════════════════════════════════════

enum SpecialRequest {
  denizManzarasi(emoji: '🌊', displayName: 'Deniz Manzarası', bonusPoints: 20,
    dialogueHint: 'Deniz manzaralı bir oda tercih ederim.'),
  yuksekKat(emoji: '🏗️', displayName: 'Yüksek Kat', bonusPoints: 15,
    dialogueHint: 'Yüksek katta bir oda olursa sevinirim.'),
  sessizOda(emoji: '🤫', displayName: 'Sessiz Oda', bonusPoints: 15,
    dialogueHint: 'Sessiz bir oda olsun lütfen.'),
  bebekYatagi(emoji: '🍼', displayName: 'Bebek Yatağı', bonusPoints: 20,
    dialogueHint: 'Odaya bebek yatağı koyabilir misiniz?'),
  gecCheckout(emoji: '🕐', displayName: 'Geç Check-out', bonusPoints: 15,
    dialogueHint: 'Geç çıkış yapabilir miyim?'),
  havuzManzarasi(emoji: '🏊', displayName: 'Havuz Manzarası', bonusPoints: 20,
    dialogueHint: 'Havuz manzaralı bir oda olsa harika olur.'),
  diyetMenu(emoji: '🥗', displayName: 'Diyet Menü', bonusPoints: 15,
    dialogueHint: 'Diyet menü seçeneğiniz var mı?'),
  transfer(emoji: '🚐', displayName: 'Havalimanı Transferi', bonusPoints: 20,
    dialogueHint: 'Havalimanı transferi ayarlayabilir misiniz?');

  const SpecialRequest({
    required this.emoji,
    required this.displayName,
    required this.bonusPoints,
    required this.dialogueHint,
  });

  final String emoji;
  final String displayName;
  final int bonusPoints;
  final String dialogueHint;
}

// ══════════════════════════════════════════
//  GÜÇ-UP TİPLERİ
// ══════════════════════════════════════════

enum PowerUpType {
  zamanDondur(emoji: '⏸️', displayName: 'Zaman Dondur',
    description: '5 saniye sabır çubuğunu dondurur'),
  ipucu(emoji: '💡', displayName: 'İpucu',
    description: 'Doğru oda tipini otomatik seçer'),
  pasGec(emoji: '⏭️', displayName: 'Pas Geç',
    description: 'Misafiri hata yapmadan pas geçer');

  const PowerUpType({
    required this.emoji,
    required this.displayName,
    required this.description,
  });

  final String emoji;
  final String displayName;
  final String description;
}

// ══════════════════════════════════════════
//  BAŞARI ROZETLERİ
// ══════════════════════════════════════════

enum Achievement {
  ilkCheckIn(emoji: '🎖️', displayName: 'İlk Check-in',
    description: 'İlk misafirini başarıyla yerleştir'),
  comboUstasi(emoji: '🔥', displayName: 'Combo Ustası',
    description: '10 üst üste doğru check-in yap'),
  mukemmeliyetci(emoji: '💯', displayName: 'Mükemmeliyetçi',
    description: 'Hiç hata yapmadan oyna'),
  gelirKrali(emoji: '💰', displayName: 'Gelir Kralı',
    description: 'Tek oyunda 30.000₺ gelir elde et'),
  genelMudur(emoji: '👑', displayName: 'Genel Müdür',
    description: 'Seviye 8\'e ulaş');

  const Achievement({
    required this.emoji,
    required this.displayName,
    required this.description,
  });

  final String emoji;
  final String displayName;
  final String description;
}

// ══════════════════════════════════════════
//  MİSAFİR PROFİLİ
// ══════════════════════════════════════════

class GuestProfile {
  final String name;
  final String flag;
  final GuestType type;
  final RoomType correctRoom;
  final BoardType correctBoard;
  final List<SpecialRequest> specialRequests;
  final String dialogue;

  const GuestProfile({
    required this.name,
    required this.flag,
    required this.type,
    required this.correctRoom,
    required this.correctBoard,
    required this.specialRequests,
    required this.dialogue,
  });
}

// ══════════════════════════════════════════
//  SEVİYE KONFİGÜRASYONU
// ══════════════════════════════════════════

class LevelConfig {
  final int level;
  final String title;
  final double basePatience;
  final int maxSpecialRequests;
  final int totalGuests;

  const LevelConfig({
    required this.level,
    required this.title,
    required this.basePatience,
    required this.maxSpecialRequests,
    required this.totalGuests,
  });

  List<RoomType> get availableRooms =>
      RoomType.values.where((r) => r.minLevel <= level).toList();

  List<BoardType> get availableBoards =>
      BoardType.values.where((b) => b.minLevel <= level).toList();

  List<GuestType> get availableGuestTypes =>
      GuestType.values.where((g) => g.minLevel <= level).toList();

  static const List<LevelConfig> levels = [
    LevelConfig(level: 0, title: 'Stajyer', basePatience: 15, maxSpecialRequests: 0, totalGuests: 4),
    LevelConfig(level: 1, title: 'Bellboy', basePatience: 17, maxSpecialRequests: 0, totalGuests: 8),
    LevelConfig(level: 2, title: 'Resepsiyonist', basePatience: 19, maxSpecialRequests: 1, totalGuests: 8),
    LevelConfig(level: 3, title: 'Kıdemli Resepsiyonist', basePatience: 21, maxSpecialRequests: 1, totalGuests: 8),
    LevelConfig(level: 4, title: 'Vardiya Amiri', basePatience: 23, maxSpecialRequests: 2, totalGuests: 8),
    LevelConfig(level: 5, title: 'Ön Büro Şefi', basePatience: 25, maxSpecialRequests: 2, totalGuests: 8),
    LevelConfig(level: 6, title: 'Ön Büro Müdürü', basePatience: 27, maxSpecialRequests: 2, totalGuests: 8),
    LevelConfig(level: 7, title: 'Genel Müdür', basePatience: 29, maxSpecialRequests: 3, totalGuests: 8),
  ];
}

// ══════════════════════════════════════════
//  MİSAFİR SENARYO ŞABLONLARI
// ══════════════════════════════════════════

class _GuestScenario {
  final List<RoomType> correctRooms;
  final BoardType correctBoard;
  final String dialogue;
  const _GuestScenario(this.correctRooms, this.correctBoard, this.dialogue);
}

class _GuestCandidate {
  final GuestType type;
  final RoomType room;
  final BoardType board;
  final String dialogue;
  const _GuestCandidate({
    required this.type,
    required this.room,
    required this.board,
    required this.dialogue,
  });
}

class _RoomBoardPair {
  final RoomType room;
  final BoardType board;
  const _RoomBoardPair(this.room, this.board);
}

// ══════════════════════════════════════════
//  OYUN VERİ FABRİKASI
// ══════════════════════════════════════════

class ReceptionSimulatorData {
  ReceptionSimulatorData._();

  // ── Misafir İsimleri ──
  static const List<String> _guestNames = [
    'Ahmet Bey', 'Fatma Hanım', 'Mehmet Bey', 'Ayşe Hanım',
    'Mustafa Bey', 'Zeynep Hanım', 'Ali Bey', 'Elif Hanım',
    'Hüseyin Bey', 'Hatice Hanım', 'İbrahim Bey', 'Merve Hanım',
    'Yusuf Bey', 'Büşra Hanım', 'Oğuz Bey', 'Selin Hanım',
    'Emre Bey', 'Derya Hanım', 'Kemal Bey', 'Pınar Hanım',
    'Serkan Bey', 'Gizem Hanım', 'Tolga Bey', 'Ece Hanım',
    'Barış Bey', 'Canan Hanım', 'Murat Bey', 'Deniz Hanım',
    'Hakan Bey', 'Sibel Hanım', 'Burak Bey', 'Nur Hanım',
    'Cem Bey', 'Aslı Hanım', 'Onur Bey', 'İrem Hanım',
    'Furkan Bey', 'Esra Hanım', 'Tuncay Bey', 'Melis Hanım',
    'Erol Bey',
  ];

  // ── Milliyetler (Bayrak Emojileri) ──
  static const List<String> _nationalities = [
    '🇹🇷', '🇹🇷', '🇹🇷', '🇹🇷', '🇹🇷', // %50 Türk
    '🇩🇪', '🇬🇧', '🇫🇷', '🇷🇺', '🇳🇱',
  ];

  // ── Senaryo Şablonları ──
  static final Map<GuestType, List<_GuestScenario>> _scenarios = {
    GuestType.normal: [
      _GuestScenario(
        [RoomType.standart], BoardType.odaKahvalti,
        'Merhaba, bir gece kalacağım. Uygun bir oda ve sabah kahvaltısı yeterli.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.sadeceOda,
        'İyi günler, kısa süreliğine kalacağım. Normal bir oda olsun, yemek istemiyorum.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.odaKahvalti,
        'Selam, bütçem kısıtlı. En uygun fiyatlı odanız olsun, kahvaltı dahil olursa sevinirim.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.odaKahvalti,
        'Merhaba, tek kişi kalacağım. Standart bir oda ve kahvaltı paketi lütfen.',
      ),
      _GuestScenario(
        [RoomType.kose], BoardType.odaKahvalti,
        'Merhaba, dinlenmek için çift cepheli, geniş ve iki farklı yönden manzara gören bir oda istiyorum. Sabah kahvaltısı dahil olsun.',
      ),
    ],

    GuestType.turistGrup: [
      _GuestScenario(
        [RoomType.standart], BoardType.odaKahvalti,
        'Merhaba, tur grubuyuz. Uygun fiyatlı odalar ve kahvaltı dahil olsun.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.sadeceOda,
        'İyi günler, gezi grubu olarak geldik. En ekonomik odalarınızı istiyoruz, yemek dahil olmasın.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.yarimPansiyon,
        'Merhaba, grup halindeyiz. Standart odalar ve sabah-akşam yemek olsun.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.tamPansiyon,
        'Merhaba, büyük bir gezi grubuyuz. Çok ucuz odalar ve üç öğün yemek istiyoruz.',
      ),
    ],

    GuestType.isInsani: [
      _GuestScenario(
        [RoomType.executive], BoardType.odaKahvalti,
        'İyi günler, iş toplantısı için buradayım. Geniş çalışma masası ve iş donanımları olan bir oda rica ediyorum. Sadece kahvaltı yeterli.',
      ),
      _GuestScenario(
        [RoomType.executive], BoardType.yarimPansiyon,
        'Merhaba, bir haftalık iş gezisindeyim. Çalışma konforu yüksek, ofis donanımlı özel bir oda ile yarım pansiyon paketi rica ediyorum.',
      ),
      _GuestScenario(
        [RoomType.executive], BoardType.odaKahvalti,
        'İyi akşamlar, ben bir CIP konuğuyum. Odada geniş bir çalışma masası, fazladan prizler ve masa lambası arıyorum. İş odaklı tasarlanmış konsept bir oda açabilir misiniz? Kahvaltı dahil olsun.',
      ),
      _GuestScenario(
        [RoomType.executive], BoardType.yarimPansiyon,
        'Merhaba, seminer için şehirdeyim. İş odaklı donatılmış, rahat çalışabileceğim özel bir çalışma alanı sunan oda ve yarım pansiyon talep ediyorum.',
      ),
    ],

    GuestType.aile: [
      _GuestScenario(
        [RoomType.aile], BoardType.tamPansiyon,
        'Merhabalar, eşim ve iki çocuğumla geldik. Geniş bir aile odası ve üç öğün yemek olsun.',
      ),
      _GuestScenario(
        [RoomType.baglantili], BoardType.herSeyDahil,
        'Merhaba, çocuklu bir aileyiz. Aralarında geçiş kapısı olan iki oda (Bağlantılı Oda) istiyoruz, her şey dahil olsun.',
      ),
      _GuestScenario(
        [RoomType.bitisik], BoardType.yarimPansiyon,
        'İyi günler, kalabalık bir aileyiz. Yan yana bulunan ancak aralarında doğrudan bir ara kapı bulunmayan iki oda (Bitişik Oda) rica ediyoruz, yarım pansiyon olsun.',
      ),
    ],

    GuestType.yasliCift: [
      _GuestScenario(
        [RoomType.standart, RoomType.kose], BoardType.yarimPansiyon,
        'Merhaba evladım, eşimle dinlenmeye geldik. Çift cepheli, iki farklı yöne bakıp manzarayı geniş gören ferah bir oda ve yarım pansiyon olsun.',
      ),
      _GuestScenario(
        [RoomType.standart], BoardType.tamPansiyon,
        'İyi günler, emekli bir çiftiz. Normal bir oda yeterli, üç öğün yemek dahil olsun lütfen.',
      ),
      _GuestScenario(
        [RoomType.kose], BoardType.yarimPansiyon,
        'Merhaba evladım, eşimle rahat etmek istiyoruz. İki yönden de pencereli olan, standart odalardan biraz daha geniş ve ferah bir oda ile yarım pansiyon paketini rica ediyoruz.',
      ),
    ],

    GuestType.ozelGereksinim: [
      _GuestScenario(
        [RoomType.ozelGereksinim], BoardType.odaKahvalti,
        'Merhaba, tekerlekli sandalye kullanıyorum. Özel gereksinimli birey odası ve kahvaltı dahil olsun.',
      ),
      _GuestScenario(
        [RoomType.ozelGereksinim], BoardType.yarimPansiyon,
        'İyi günler, yürüme güçlüğüm var. Özel donanımlı, engelsiz bir Özel Gereksinimli Birey Odası ve yarım pansiyon istiyorum.',
      ),
      _GuestScenario(
        [RoomType.ozelGereksinim], BoardType.tamPansiyon,
        'Merhaba, hareket kısıtlılığım var. Kendime uygun donanımlı Özel Gereksinimli Birey Odası ve tam pansiyon olsun lütfen.',
      ),
    ],

    GuestType.vip: [
      _GuestScenario(
        [RoomType.suite], BoardType.herSeyDahil,
        'İyi akşamlar, en iyi odanızı ve her şey dahil paketi istiyorum. Kaliteden ödün vermem.',
      ),
      _GuestScenario(
        [RoomType.suite, RoomType.kralDairesi], BoardType.herSeyDahil,
        'Merhaba, VIP konuğunuzum. En lüks odanız ve tüm hizmetlerin dahil olduğu paketi istiyorum.',
      ),
      _GuestScenario(
        [RoomType.kralDairesi], BoardType.ultraHerSeyDahil,
        'En prestijli odanızı ve ultra her şey dahil paketinizi hazırlayın lütfen.',
      ),
    ],

    GuestType.balayi: [
      _GuestScenario(
        [RoomType.suite], BoardType.herSeyDahil,
        'Merhaba, eşimle balayındayız! Romantik bir süit oda ve her şey dahil istiyoruz.',
      ),
      _GuestScenario(
        [RoomType.kose, RoomType.suite], BoardType.herSeyDahil,
        'İyi günler, yeni evlendik! Çift cepheli iki yönü gören güzel bir oda veya lüks bir süit oda ile her şey dahil konaklama rica ediyoruz.',
      ),
      _GuestScenario(
        [RoomType.kralDairesi], BoardType.ultraHerSeyDahil,
        'Balayımız için en özel deneyimi istiyoruz. En lüks odanız ve en kapsamlı paketiniz olsun.',
      ),
    ],
  };

  // ── Eğitici Bilgiler ──
  static const List<String> educationalTips = [
    '💡 Ön büro, otelin vitrinidir. İlk izlenim burada oluşur.',
    '💡 Check-in sırasında misafirin kimlik belgesi mutlaka kontrol edilmelidir.',
    '💡 B&B (Bed & Breakfast) sadece kahvaltı dahil demektir.',
    '💡 Yarım pansiyon (HP), kahvaltı ve akşam yemeğini kapsar.',
    '💡 Tam pansiyon (FB), sabah, öğle ve akşam olmak üzere 3 öğün içerir.',
    '💡 Her şey dahil (AI) sisteminde tüm yiyecek ve yerli içecekler dahildir.',
    '💡 Suite odalarda ayrı bir oturma alanı bulunur.',
    '💡 Özel gereksinimli birey odaları, engelsiz bir konaklama için özel tasarlanmıştır.',
    '💡 VIP misafirlere oda yükseltmesi (upgrade) sunmak kaliteli hizmetin göstergesidir.',
    '💡 Executive Room (Yönetici Odası), VIP\'den ziyade CIP (Commercially Important Person) misafirlere sunulur. Bu odalarda geniş çalışma masası, fazladan prizler, masa lambası gibi iş odaklı donanımlar yer alır.',
    '💡 Bağlantılı Odalar (Connecting Rooms), aralarında doğrudan geçişi sağlayan bir iç kapı bulunan ve genellikle kalabalık aileler tarafından tercih edilen yan yana odalardır.',
    '💡 Bitişik Odalar (Adjoining Rooms), yan yana bulunan ancak aralarında doğrudan bir iç geçiş kapısı olmayan odalardır.',
    '💡 Köşe Odalar (Corner Rooms), binanın köşelerinde yer aldıkları için normal odalardan biraz daha geniştir ve genellikle çift cepheli olmaları sayesinde aynı anda iki farklı manzarayı birden görebilirler.',
    '💡 Resepsiyon görevlisi, misafirin tüm konaklama süresindeki ana iletişim noktasıdır.',
    '💡 Kral dairesi (Presidential Suite), otelin en prestijli konaklama birimidir.',
    '💡 Misafir memnuniyeti, otelin tekrar ziyaret oranını doğrudan etkiler.',
    '💡 Pansiyon türünü belirlerken misafirin seyahat amacı önemli bir ipucudur.',
    '💡 Ultra her şey dahil (UAI), premium içecekleri ve ek hizmetleri de kapsar.',
    '💡 Ön büro departmanı; resepsiyon, concierge ve santral birimlerinden oluşur.',
    '💡 Walk-in misafir, rezervasyonsuz gelen misafir anlamına gelir.',
    '💡 No-show, rezervasyon yaptırıp gelmeyen misafir demektir.',
    '💡 Overbooking, otel kapasitesinin üzerinde rezervasyon alınması durumudur.',
    '💡 Grup rezervasyonlarında genellikle allotment (kontenjan) uygulanır.',
  ];

  /// Verilen seviyeye uygun rastgele bir misafir profili üretir.
  static GuestProfile generateGuest(int level, Random random) {
    final config = LevelConfig.levels[level];

    // Uygun misafir tiplerini ve senaryolarını bul
    final validEntries = <GuestType, List<_GuestScenario>>{};
    for (final guestType in config.availableGuestTypes) {
      final scenarios = _scenarios[guestType] ?? [];
      final validScenarios = scenarios.where((s) {
        final hasRoom = s.correctRooms.any((r) => r.minLevel <= level);
        final hasBoard = s.correctBoard.minLevel <= level;
        return hasRoom && hasBoard;
      }).toList();
      if (validScenarios.isNotEmpty) {
        validEntries[guestType] = validScenarios;
      }
    }

    // Fallback
    if (validEntries.isEmpty) {
      return GuestProfile(
        name: 'Misafir',
        flag: '🇹🇷',
        type: GuestType.normal,
        correctRoom: RoomType.standart,
        correctBoard: BoardType.odaKahvalti,
        specialRequests: const [],
        dialogue: 'Merhaba, standart bir oda ve kahvaltı istiyorum.',
      );
    }

    // Rastgele misafir tipi seç
    final types = validEntries.keys.toList();
    final guestType = types[random.nextInt(types.length)];

    // Rastgele senaryo seç
    final scenarios = validEntries[guestType]!;
    final scenario = scenarios[random.nextInt(scenarios.length)];

    // Uygun odalardan birini seç
    final availableRooms =
        scenario.correctRooms.where((r) => r.minLevel <= level).toList();
    final correctRoom = availableRooms[random.nextInt(availableRooms.length)];

    // Özel istekler oluştur
    final requests = _generateSpecialRequests(config.maxSpecialRequests, random);

    // Diyaloğu tamamla
    String dialogue = scenario.dialogue;
    if (requests.isNotEmpty) {
      final requestTexts = requests.map((r) => r.dialogueHint).join(' ');
      dialogue += ' $requestTexts';
    }

    // İsim ve milliyet
    final name = _guestNames[random.nextInt(_guestNames.length)];
    final flag = _nationalities[random.nextInt(_nationalities.length)];

    return GuestProfile(
      name: name,
      flag: flag,
      type: guestType,
      correctRoom: correctRoom,
      correctBoard: scenario.correctBoard,
      specialRequests: requests,
      dialogue: dialogue,
    );
  }

  /// Verilen seviye için benzersiz misafir istekleri üretir.
  static List<GuestProfile> generateUniqueGuestsForLevel(int level, int count, Random random) {
    final config = LevelConfig.levels[level];

    // Seviye için uygun tüm aday senaryo ve oda kombinasyonlarını topla
    final candidates = <_GuestCandidate>[];
    for (final guestType in config.availableGuestTypes) {
      final scenarios = _scenarios[guestType] ?? [];
      for (final scenario in scenarios) {
        final validRooms = scenario.correctRooms.where((r) => r.minLevel <= level).toList();
        final isBoardValid = scenario.correctBoard.minLevel <= level;

        if (validRooms.isNotEmpty && isBoardValid) {
          for (final room in validRooms) {
            candidates.add(_GuestCandidate(
              type: guestType,
              room: room,
              board: scenario.correctBoard,
              dialogue: scenario.dialogue,
            ));
          }
        }
      }
    }

    // Fallback durumunda (beklenmedik şekilde boş kalırsa)
    if (candidates.isEmpty) {
      return List.generate(count, (index) {
        return GuestProfile(
          name: _guestNames[index % _guestNames.length],
          flag: '🇹🇷',
          type: GuestType.normal,
          correctRoom: RoomType.standart,
          correctBoard: BoardType.odaKahvalti,
          specialRequests: const [],
          dialogue: 'Merhaba, standart bir oda ve kahvaltı istiyorum.',
        );
      });
    }

    final selectedCandidates = <_GuestCandidate>[];

    if (level == 0) {
      // Seviye 0'da tam olarak 4 benzersiz kombinasyon isteriz:
      // (ekonomik, sadeceOda), (ekonomik, odaKahvalti), (standart, sadeceOda), (standart, odaKahvalti)
      final combinations = [
        const _RoomBoardPair(RoomType.standart, BoardType.sadeceOda),
        const _RoomBoardPair(RoomType.standart, BoardType.odaKahvalti),
        const _RoomBoardPair(RoomType.standart, BoardType.sadeceOda),
        const _RoomBoardPair(RoomType.standart, BoardType.odaKahvalti),
      ];

      for (final pair in combinations) {
        final matches = candidates.where((c) => c.room == pair.room && c.board == pair.board).toList();
        if (matches.isNotEmpty) {
          selectedCandidates.add(matches[random.nextInt(matches.length)]);
        } else {
          final fallback = candidates[random.nextInt(candidates.length)];
          selectedCandidates.add(fallback);
        }
      }
    } else {
      // Seviye 1+ için 'count' (8) adet benzersiz diyalog/istek adayı seçeriz.
      // Aynı zamanda oda-pansiyon çeşitliliğini maksimize ederiz.
      final shuffledCandidates = List<_GuestCandidate>.from(candidates)..shuffle(random);
      final usedDialogues = <String>{};
      final roomBoardCounts = <String, int>{};

      String rbKey(RoomType r, BoardType b) => '${r.name}_${b.name}';

      // 1. Aşama: Hem diyalog hem oda/pansiyon kombinasyonu benzersiz olanları seç
      for (final c in shuffledCandidates) {
        if (selectedCandidates.length >= count) break;
        final key = rbKey(c.room, c.board);
        if (!usedDialogues.contains(c.dialogue) && (roomBoardCounts[key] ?? 0) == 0) {
          selectedCandidates.add(c);
          usedDialogues.add(c.dialogue);
          roomBoardCounts[key] = (roomBoardCounts[key] ?? 0) + 1;
        }
      }

      // 2. Aşama: Gerekirse oda/pansiyon tekrarına izin ver ama diyaloğu benzersiz tut
      if (selectedCandidates.length < count) {
        for (final c in shuffledCandidates) {
          if (selectedCandidates.length >= count) break;
          if (!usedDialogues.contains(c.dialogue)) {
            selectedCandidates.add(c);
            usedDialogues.add(c.dialogue);
            final key = rbKey(c.room, c.board);
            roomBoardCounts[key] = (roomBoardCounts[key] ?? 0) + 1;
          }
        }
      }

      // 3. Aşama: Hala eksik varsa (pool çok küçükse), her türlü tekrara izin vererek tamamla
      if (selectedCandidates.length < count) {
        for (final c in shuffledCandidates) {
          if (selectedCandidates.length >= count) break;
          selectedCandidates.add(c);
        }
      }
    }

    // Seçilen adayların sırasını karıştır
    selectedCandidates.shuffle(random);

    // İsimlerin benzersiz olması için isim havuzunu karıştır
    final namesPool = List<String>.from(_guestNames)..shuffle(random);
    final result = <GuestProfile>[];

    for (int i = 0; i < selectedCandidates.length; i++) {
      final candidate = selectedCandidates[i];
      final name = namesPool[i % namesPool.length];
      final flag = _nationalities[random.nextInt(_nationalities.length)];

      // Özel istekler
      final requests = _generateSpecialRequests(config.maxSpecialRequests, random);

      // Diyaloğa özel istek ipuçlarını ekle
      String dialogue = candidate.dialogue;
      if (requests.isNotEmpty) {
        final requestTexts = requests.map((r) => r.dialogueHint).join(' ');
        dialogue += ' $requestTexts';
      }

      result.add(GuestProfile(
        name: name,
        flag: flag,
        type: candidate.type,
        correctRoom: candidate.room,
        correctBoard: candidate.board,
        specialRequests: requests,
        dialogue: dialogue,
      ));
    }

    return result;
  }

  /// Rastgele özel istekler oluşturur.
  static List<SpecialRequest> _generateSpecialRequests(
      int maxRequests, Random random) {
    if (maxRequests <= 0) return const [];
    final hasRequests = random.nextBool();
    if (!hasRequests) return const [];

    final numRequests = random.nextInt(maxRequests) + 1;
    final all = List<SpecialRequest>.from(SpecialRequest.values)..shuffle(random);
    return all.take(numRequests).toList();
  }

  /// Misafirin özel isteklerini içeren seçenekler oluşturur (doğru + yanlış seçenekler).
  static List<SpecialRequest> getRequestOptions(
      List<SpecialRequest> correctRequests, Random random) {
    final options = Set<SpecialRequest>.from(correctRequests);
    final distractors = SpecialRequest.values
        .where((r) => !correctRequests.contains(r))
        .toList()
      ..shuffle(random);

    // 5 seçenek göster (doğrular + yanlışlar)
    while (options.length < 5 && distractors.isNotEmpty) {
      options.add(distractors.removeAt(0));
    }

    final result = options.toList()..shuffle(random);
    return result;
  }

  /// Seviye geçişinde açılan yeni özellikleri döndürür.
  static List<String> getNewUnlocks(int newLevel) {
    final unlocks = <String>[];

    for (final room in RoomType.values) {
      if (room.minLevel == newLevel) {
        unlocks.add('${room.emoji} ${room.displayName} açıldı!');
      }
    }
    for (final board in BoardType.values) {
      if (board.minLevel == newLevel) {
        unlocks.add('${board.emoji} ${board.displayName} açıldı!');
      }
    }
    for (final guest in GuestType.values) {
      if (guest.minLevel == newLevel) {
        unlocks.add('${guest.emoji} ${guest.displayName} gelmeye başladı!');
      }
    }

    final config = LevelConfig.levels[newLevel];
    if (newLevel == 2) {
      unlocks.add('🎯 Özel İstekler sistemi açıldı!');
    }
    if (config.maxSpecialRequests > LevelConfig.levels[newLevel - 1].maxSpecialRequests) {
      unlocks.add('📋 Özel istek sayısı artırıldı!');
    }

    return unlocks;
  }

  /// Rastgele bir eğitici bilgi döndürür.
  static String getRandomTip(Random random) {
    return educationalTips[random.nextInt(educationalTips.length)];
  }

  /// İtibar değerinden yıldız sayısını hesaplar (1-5).
  static int getStarRating(int reputation) {
    if (reputation >= 80) return 5;
    if (reputation >= 60) return 4;
    if (reputation >= 40) return 3;
    if (reputation >= 20) return 2;
    return 1;
  }

  /// Combo sayısından çarpan değerini hesaplar.
  static double getComboMultiplier(int combo) {
    if (combo >= 12) return 3.0;
    if (combo >= 8) return 2.5;
    if (combo >= 5) return 2.0;
    if (combo >= 3) return 1.5;
    return 1.0;
  }
}
