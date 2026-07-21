import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MainShell'deki aktif sekme indeksini tutan ve programatik geçişi sağlayan provider.
final shellTabProvider = StateProvider<int>((ref) => 0);

/// Onboarding turunun aktif olup olmadığını tutan provider.
final isOnboardingActiveProvider = StateProvider<bool>((ref) => false);

/// Alt menü butonlarının tam koordinatlarını bulmak için global key listesi.
class ShellKeys {
  static final List<GlobalKey> navKeys = List.generate(4, (_) => GlobalKey());
  static final GlobalKey courseCardKey = GlobalKey();
  static final GlobalKey unitCardKey = GlobalKey();
  static final GlobalKey podcastKey = GlobalKey();
  static final GlobalKey studyCardKey = GlobalKey();
  static final GlobalKey caseStudyKey = GlobalKey();
  static final List<GlobalKey> gradeCardKeys = List.generate(4, (_) => GlobalKey());
  static final GlobalKey generalQuizKey = GlobalKey();
  static final ExpansionTileController firstConceptController = ExpansionTileController();
  static final GlobalKey firstConceptKey = GlobalKey();
  static final GlobalKey tipKey = GlobalKey();
  static final GlobalKey unitQuizFabKey = GlobalKey();
  static final GlobalKey devNoteKey = GlobalKey();
  static final GlobalKey profileCardKey = GlobalKey();
  static final GlobalKey blitzGameKey = GlobalKey();
}
