import 'package:flutter/material.dart';

enum NoteTemplateType {
  general,
  comparison,
  workshop,
}

class NoteTemplate {
  final NoteTemplateType type;
  final String id;
  final String title;
  final String shortTitle;
  final String badgeTitle;
  final String subtitle;
  final String iconEmoji;
  final IconData iconData;
  final Color accentColor;
  final String defaultTitle;
  final String defaultContent;
  final String defaultTag;
  final int defaultColorIndex;

  const NoteTemplate({
    required this.type,
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.badgeTitle,
    required this.subtitle,
    required this.iconEmoji,
    required this.iconData,
    required this.accentColor,
    required this.defaultTitle,
    required this.defaultContent,
    required this.defaultTag,
    required this.defaultColorIndex,
  });

  static const List<NoteTemplate> templates = [
    NoteTemplate(
      type: NoteTemplateType.general,
      id: 'general',
      title: 'Serbest Not Şablonu',
      shortTitle: 'Serbest Not',
      badgeTitle: 'Klasik & Serbest',
      subtitle: 'Ders notları, sınav hatırlatıcıları ve serbest konu özetleri',
      iconEmoji: '📝',
      iconData: Icons.edit_note_rounded,
      accentColor: Color(0xFFF59E0B),
      defaultTitle: '',
      defaultContent: '',
      defaultTag: '',
      defaultColorIndex: 0,
    ),
    NoteTemplate(
      type: NoteTemplateType.comparison,
      id: 'comparison',
      title: 'Karşılaştırmalı Not Şablonu',
      shortTitle: 'Kavram Karşılaştırma',
      badgeTitle: 'Kavram Analizi',
      subtitle: 'Kavramları ve işletme türlerini karşılaştır (Örn: Otel ile Tatil Köyü)',
      iconEmoji: '⚖️',
      iconData: Icons.balance_rounded,
      accentColor: Color(0xFF0284C7),
      defaultTitle: 'Kavram Karşılaştırması',
      defaultContent: '',
      defaultTag: '',
      defaultColorIndex: 1,
    ),
    NoteTemplate(
      type: NoteTemplateType.workshop,
      id: 'workshop',
      title: 'Uygulama Adımları Şablonu',
      shortTitle: 'Uygulama Adımları',
      badgeTitle: 'Uygulama Adımları',
      subtitle: 'Uygulama adımları, işlem sırası ve iş güvenliği kuralları',
      iconEmoji: '🛎️',
      iconData: Icons.checklist_rounded,
      accentColor: Color(0xFF059669),
      defaultTitle: 'Atölye Uygulaması: [İşlem Adı]',
      defaultContent: '',
      defaultTag: '',
      defaultColorIndex: 2,
    ),
  ];

  static NoteTemplate get general => templates[0];
  static NoteTemplate get comparison => templates[1];
  static NoteTemplate get workshop => templates[2];

  static NoteTemplate fromType(NoteTemplateType type) {
    switch (type) {
      case NoteTemplateType.general:
        return templates[0];
      case NoteTemplateType.comparison:
        return templates[1];
      case NoteTemplateType.workshop:
        return templates[2];
    }
  }
}
