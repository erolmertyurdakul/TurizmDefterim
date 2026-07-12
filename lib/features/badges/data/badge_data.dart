import 'package:flutter/material.dart';

/// Rozet seviye isimleri ve renkleri
class BadgeLevel {
  final String name;
  final Color color;
  final String condition;

  const BadgeLevel({
    required this.name,
    required this.color,
    required this.condition,
  });
}

/// Tekil rozet modeli
class BadgeItem {
  final int id;
  final String emoji;
  final String name;
  final String description;
  final String category;
  final List<Color> gradient;
  final List<BadgeLevel> levels;

  const BadgeItem({
    required this.id,
    required this.emoji,
    required this.name,
    required this.description,
    required this.category,
    required this.gradient,
    required this.levels,
  });
}

// ── Seviye Renkleri ──
const _bronze = Color(0xFFCD7F32);
const _silver = Color(0xFFC0C0C0);
const _gold = Color(0xFFFFD700);
const _platinum = Color(0xFF7EB8DA);
const _legendary = Color(0xFFAA6CFC);

/// 11 Kazanılabilir Rozet
final List<BadgeItem> allBadges = [
  BadgeItem(
    id: 1,
    emoji: '📚',
    name: 'Kitap Kurdu',
    description: 'Ders notlarını okuyarak bilgi biriktir.',
    category: 'Öğrenme & Akademik',
    gradient: [const Color(0xFF205295), const Color(0xFF2C74B3)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '5 ders notu kartı oku'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '15 ders notu kartı oku'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '40 ders notu kartı oku'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '100 ders notu kartı oku'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '200 ders notu kartı oku'),
    ],
  ),
  BadgeItem(
    id: 2,
    emoji: '🎯',
    name: 'Bilgi Avcısı',
    description: 'Test çözerek bilgini sına.',
    category: 'Öğrenme & Akademik',
    gradient: [const Color(0xFF205295), const Color(0xFF2C74B3)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '2 test tamamla'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '5 test tamamla'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '15 test tamamla'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '30 test tamamla'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '50 test tamamla'),
    ],
  ),
  BadgeItem(
    id: 3,
    emoji: '🗝️',
    name: 'Terim Ustası',
    description: 'Mesleki terimleri öğrenerek sözlüğünü genişlet.',
    category: 'Öğrenme & Akademik',
    gradient: [const Color(0xFF205295), const Color(0xFF2C74B3)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '5 terim öğren'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '20 terim öğren'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '50 terim öğren'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '100 terim öğren'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '200 terim öğren'),
    ],
  ),
  BadgeItem(
    id: 4,
    emoji: '💯',
    name: 'Mükemmeliyetçi',
    description: 'Testlerde kusursuz performans göster.',
    category: 'Öğrenme & Akademik',
    gradient: [const Color(0xFF205295), const Color(0xFF2C74B3)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 testte tam puan al'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '3 testte tam puan al'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '10 testte tam puan al'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '20 testte tam puan al'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '40 testte tam puan al'),
    ],
  ),
  BadgeItem(
    id: 22,
    emoji: '🔧',
    name: 'Sorun Çözücü',
    description: 'İnteraktif vaka analizlerinde başarılı ol.',
    category: 'Senaryo & Problem Çözme',
    gradient: [const Color(0xFFE07A3A), const Color(0xFFE8AA42)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 senaryo tamamla'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '3 senaryo tamamla'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '6 senaryo tamamla'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '10 senaryo tamamla'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '15 senaryo tamamla'),
    ],
  ),
  BadgeItem(
    id: 23,
    emoji: '🚨',
    name: 'Karar Verici',
    description: 'Blitz testlerinde hızlı kararlar ver.',
    category: 'Senaryo & Problem Çözme',
    gradient: [const Color(0xFFE07A3A), const Color(0xFFE8AA42)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 blitz testi tamamla'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '3 blitz testi tamamla'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '8 blitz testi tamamla'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '15 blitz testi tamamla'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '25 blitz testi tamamla'),
    ],
  ),
  BadgeItem(
    id: 9,
    emoji: '🛎️',
    name: 'Ön Büro Stajyeri',
    description: 'Resepsiyon simülasyonunda check-in işlemlerini tamamla.',
    category: 'Mesleki Uzmanlık',
    gradient: [const Color(0xFF0E918C), const Color(0xFF17B5B0)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 simülasyon tamamla'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '3 simülasyon tamamla'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '7 simülasyon tamamla'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '12 simülasyon tamamla'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '20 simülasyon tamamla'),
    ],
  ),
  BadgeItem(
    id: 5,
    emoji: '🧩',
    name: 'Kelime Kaşifi',
    description: 'Kelime avı mini oyunlarını tamamla.',
    category: 'Mesleki Uzmanlık',
    gradient: [const Color(0xFF0E918C), const Color(0xFF17B5B0)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 kelime avı bitir'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '3 kelime avı bitir'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '7 kelime avı bitir'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '12 kelime avı bitir'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: '20 kelime avı bitir'),
    ],
  ),
  BadgeItem(
    id: 38,
    emoji: '🚀',
    name: 'İlk Adım',
    description: 'Uygulamadaki ilk deneyimlerini tamamla.',
    category: 'Özel Başarılar',
    gradient: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: 'İlk ders notunu oku'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: 'İlk terimini öğren'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: 'İlk testini çöz'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: 'İlk simülasyonunu tamamla'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: 'Tüm modülleri başarıyla dene'),
    ],
  ),
  BadgeItem(
    id: 39,
    emoji: '🗺️',
    name: 'Keşifçi',
    description: 'Tüm sınıfların ders listelerini aç.',
    category: 'Özel Başarılar',
    gradient: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: '1 sınıf listesi aç'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: '2 sınıf listesi aç'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: '3 sınıf listesi aç'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: '4 sınıf listesinin tamamını aç'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: 'Tüm sınıfları keşfet'),
    ],
  ),
  BadgeItem(
    id: 40,
    emoji: '✈️',
    name: 'Altın Pasaport',
    description: 'Uygulamadaki toplam rozet seviyelerini yükselt.',
    category: 'Özel Başarılar',
    gradient: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
    levels: [
      const BadgeLevel(name: 'Bronz', color: _bronze, condition: 'Toplam 5 rozet seviyesi kazan'),
      const BadgeLevel(name: 'Gümüş', color: _silver, condition: 'Toplam 12 rozet seviyesi kazan'),
      const BadgeLevel(name: 'Altın', color: _gold, condition: 'Toplam 20 rozet seviyesi kazan'),
      const BadgeLevel(name: 'Platin', color: _platinum, condition: 'Toplam 30 rozet seviyesi kazan'),
      const BadgeLevel(name: 'Efsane', color: _legendary, condition: 'Toplam 40 rozet seviyesi kazan'),
    ],
  ),
];

/// Kategori listesi
final List<String> badgeCategories = allBadges
    .map((b) => b.category)
    .toSet()
    .toList();
