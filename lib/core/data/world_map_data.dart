class MapDestination {
  final String id;
  final String name;
  final String country;
  final String category;
  final double dx; // 0.0 to 1.0 (X axis on map)
  final double dy; // 0.0 to 1.0 (Y axis on map)
  final String hint;

  const MapDestination({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.dx,
    required this.dy,
    required this.hint,
  });
}

const List<MapDestination> worldMapDestinations = [
  MapDestination(
    id: "cumalikizik",
    name: "Cumalıkızık",
    country: "Türkiye",
    category: "Kültürel",
    dx: 0.56,
    dy: 0.35,
    hint: "Osmanlı sivil mimarisini günümüze taşıyan, UNESCO mirası tarihi bir Bursa köyü.",
  ),
  MapDestination(
    id: "eiffel",
    name: "Eyfel Kulesi",
    country: "Fransa",
    category: "Simge Yapı",
    dx: 0.49,
    dy: 0.28,
    hint: "Paris'in simgesi olan, 1889'da inşa edilmiş dünyaca ünlü demir kule.",
  ),
  MapDestination(
    id: "machu_picchu",
    name: "Machu Picchu",
    country: "Peru",
    category: "Tarihi",
    dx: 0.28,
    dy: 0.65,
    hint: "And Dağları'nın zirvesinde yer alan gizemli antik İnka şehri.",
  ),
  MapDestination(
    id: "taj_mahal",
    name: "Taç Mahal",
    country: "Hindistan",
    category: "Kültürel",
    dx: 0.70,
    dy: 0.42,
    hint: "Şah Cihan'ın eşi için yaptırdığı, beyaz mermerden büyüleyici anıt mezar.",
  ),
  MapDestination(
    id: "sydney_opera",
    name: "Sidney Opera Binası",
    country: "Avustralya",
    category: "Mimari",
    dx: 0.88,
    dy: 0.78,
    hint: "Yelken şeklindeki çatısıyla bilinen, 20. yüzyılın en ünlü yapılarından biri.",
  ),
  MapDestination(
    id: "statue_liberty",
    name: "Özgürlük Heykeli",
    country: "ABD",
    category: "Simge Yapı",
    dx: 0.29,
    dy: 0.32,
    hint: "Fransa'nın ABD'ye hediyesi olan, New York limanındaki meşaleli dev heykel.",
  ),
  MapDestination(
    id: "pyramids",
    name: "Giza Piramitleri",
    country: "Mısır",
    category: "Tarihi",
    dx: 0.55,
    dy: 0.41,
    hint: "Firavun mezarları olan ve Dünyanın Yedi Harikası'ndan günümüze kalan tek yapı.",
  ),
  MapDestination(
    id: "colosseum",
    name: "Kolezyum",
    country: "İtalya",
    category: "Tarihi",
    dx: 0.53,
    dy: 0.31,
    hint: "Roma'da gladyatör dövüşlerine ev sahipliği yapmış antik amfitiyatro.",
  ),
  MapDestination(
    id: "petra",
    name: "Petra Antik Kenti",
    country: "Ürdün",
    category: "Tarihi",
    dx: 0.57,
    dy: 0.38,
    hint: "Kızıl kayalara oyulmuş, 'Kayıp Şehir' olarak da bilinen gizemli kent.",
  ),
  MapDestination(
    id: "great_wall",
    name: "Çin Seddi",
    country: "Çin",
    category: "Simge Yapı",
    dx: 0.78,
    dy: 0.33,
    hint: "Uzaydan görülebildiği efsanesiyle bilinen, dünyanın en uzun savunma duvarı.",
  ),
  MapDestination(
    id: "santorini",
    name: "Santorini",
    country: "Yunanistan",
    category: "Kültürel",
    dx: 0.54,
    dy: 0.34,
    hint: "Beyaz evleri ve mavi kubbeli kiliseleriyle meşhur volkanik Ege adası.",
  ),
  MapDestination(
    id: "angkor_wat",
    name: "Angkor Wat",
    country: "Kamboçya",
    category: "Tarihi",
    dx: 0.76,
    dy: 0.52,
    hint: "Dünyanın en büyük dini anıtı olan devasa tapınak kompleksi.",
  ),
];
