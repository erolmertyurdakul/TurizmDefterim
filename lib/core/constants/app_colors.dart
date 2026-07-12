import 'package:flutter/material.dart';

/// Okyanus Temalı Renk Paleti
/// Derin deniz mavisi, turkuaz ve kumsal altını tonları.
class AppColors {
  AppColors._();

  // ── Birincil: Derin Okyanus ──
  static const Color primarySeed = Color(0xFF0A2647);
  static const Color primaryLight = Color(0xFF144272);
  static const Color primaryMid = Color(0xFF205295);
  static const Color primaryBright = Color(0xFF2C74B3);

  // ── İkincil: Turkuaz & Mercan ──
  static const Color secondary = Color(0xFF0E918C);
  static const Color secondaryLight = Color(0xFF17B5B0);
  static const Color teal = Color(0xFF1B9C9A);

  // ── Aksan: Kumsal Altını ──
  static const Color accent = Color(0xFFE8AA42);
  static const Color accentLight = Color(0xFFF0C36D);
  static const Color accentWarm = Color(0xFFE07A3A);

  // ── Nötr ──
  static const Color surface = Color(0xFFF0F7FF);
  static const Color surfaceVariant = Color(0xFFE3EFF9);
  static const Color background = Color(0xFFF8FBFF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0A1628);
  static const Color textSecondary = Color(0xFF4A6580);
  static const Color textHint = Color(0xFF8FAABE);
  static const Color divider = Color(0xFFDAE8F5);

  // ── Dark Mode ──
  static const Color darkBackground = Color(0xFF0A1628);
  static const Color darkSurface = Color(0xFF122240);
  static const Color darkCard = Color(0xFF1A2F52);
  static const Color darkTextPrimary = Color(0xFFE8F0FE);
  static const Color darkTextSecondary = Color(0xFF8FAABE);

  // ── Gradient Setleri ──
  static const List<Color> oceanGradient = [
    Color(0xFF0A2647),
    Color(0xFF144272),
    Color(0xFF205295),
  ];

  static const List<Color> turquoiseGradient = [
    Color(0xFF0E918C),
    Color(0xFF17B5B0),
    Color(0xFF56D6D2),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFE07A3A),
    Color(0xFFE8AA42),
    Color(0xFFF0C36D),
  ];

  static const List<Color> coralGradient = [
    Color(0xFFFF6B6B),
    Color(0xFFFF8E8E),
    Color(0xFFFFB4B4),
  ];

  // ── Sınıf Kart Renkleri ──
  static const List<Color> grade9Gradient = [Color(0xFF205295), Color(0xFF2C74B3)];
  static const List<Color> grade10Gradient = [Color(0xFF0E918C), Color(0xFF17B5B0)];
  static const List<Color> grade11Gradient = [Color(0xFFE07A3A), Color(0xFFE8AA42)];
  static const List<Color> grade12Gradient = [Color(0xFF8B5CF6), Color(0xFFA78BFA)];
}
