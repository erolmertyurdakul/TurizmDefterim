import 'package:flutter/material.dart';

class ComparisonColors {
  // 6 Farklı Ayırt Edici Renk (Sarı Parlayabileceği İçin Hariç Tutuldu)
  static const List<Color> colors = [
    Color(0xFF0284C7), // 1: Canlı Mavi / Okyanus
    Color(0xFF059669), // 2: Canlı Zümrüt Yeşili
    Color(0xFF7C3AED), // 3: Canlı Mor / Menekşe
    Color(0xFFE11D48), // 4: Canlı Kırmızı / Mercan Gül
    Color(0xFF0D9488), // 5: Canlı Petrol / Koyu Teal
    Color(0xFF4338CA), // 6: Canlı İndigo / Gece Laciverti
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}
