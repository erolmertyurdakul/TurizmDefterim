import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/course_note_model.dart';
import '../../domain/models/comparison_colors.dart';
import '../widgets/note_card_widget.dart';

class NoteFullscreenReaderScreen extends StatefulWidget {
  final CourseNoteModel note;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NoteFullscreenReaderScreen({
    super.key,
    required this.note,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<NoteFullscreenReaderScreen> createState() => _NoteFullscreenReaderScreenState();
}

class _NoteFullscreenReaderScreenState extends State<NoteFullscreenReaderScreen> {
  // Okuma Modu Yazı Boyutu Çarpanı (Kullanıcı dilediği gibi büyütebilir)
  double _fontScale = 1.15; // Varsayılan olarak standarttan daha büyük ve okunaklı

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    final day = dt.day;
    final month = months[dt.month];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month ${dt.year}, $hour:$minute';
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Sınav':
        return const Color(0xFFDC2626);
      case 'Tanım':
        return const Color(0xFF0284C7);
      case 'Ödev':
        return const Color(0xFF7C3AED);
      case 'İpucu':
        return const Color(0xFFD97706);
      case 'Kişisel':
        return const Color(0xFF0D9488);
      default:
        return const Color(0xFFE11D48);
    }
  }

  IconData _getTagIcon(String tag) {
    switch (tag) {
      case 'Sınav':
        return Icons.school_rounded;
      case 'Tanım':
        return Icons.menu_book_rounded;
      case 'Ödev':
        return Icons.assignment_rounded;
      case 'İpucu':
        return Icons.lightbulb_rounded;
      case 'Kişisel':
        return Icons.person_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: '${widget.note.title}\n\n${widget.note.content}'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Not panoya kopyalandı'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;
    final isLargeScreen = screenWidth >= 1024;

    final safeColorIndex = (note.colorIndex >= 0 && note.colorIndex < NoteColors.bgColors.length)
        ? note.colorIndex
        : 0;
    final bgColor = NoteColors.bgColors[safeColorIndex];
    final borderColor = NoteColors.borderColors[safeColorIndex];
    final tagColor = _getTagColor(note.tag);
    final tagIcon = _getTagIcon(note.tag);

    final isWorkshop = (note.content.contains('【') && note.content.contains('⬇️')) ||
        note.content.contains('1. Adım') ||
        note.content.contains('İşlem Sırası ve Detaylar');
    final isComparison = note.content.contains('KAVRAM KARŞILAŞTIRMASI') ||
        note.content.contains('【 Özellik:') ||
        (note.content.contains('⚖️') && (note.content.contains('Kavramlar:') || note.content.contains('Kavram 1')));

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── ÜST KONTROL VE GEZİNME BARI (Apple / Reader Mode Stili) ──
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 32 : 14,
                vertical: isWide ? 18 : 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.90),
                border: Border(
                  bottom: BorderSide(
                    color: borderColor.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Geri / Kapat Butonu
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(isWide ? 14 : 12),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 16 : 10,
                          vertical: isWide ? 9 : 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(isWide ? 14 : 12),
                          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_rounded, size: isWide ? 22 : 19, color: AppColors.textPrimary),
                            if (isWide) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Geri Dön',
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: isWide ? 18 : 9),

                  // Ders & Sınıf Rozeti (Hem mobilde hem PC'de ferah ve taşmasız)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isWide ? 16 : 8,
                            vertical: isWide ? 8 : 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: borderColor,
                            borderRadius: BorderRadius.circular(isWide ? 10 : 8),
                            boxShadow: [
                              BoxShadow(
                                color: borderColor.withValues(alpha: 0.25),
                                blurRadius: isWide ? 8 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${note.grade}. Sınıf',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 15.5 : 11.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(width: isWide ? 12 : 7),
                        Expanded(
                          child: Text(
                            note.courseTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 19.5 : 13.5,
                              fontWeight: isWide ? FontWeight.w800 : FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: isWide ? 14 : 6),

                  // Yazı Boyutu Kontrolü (A- / % / A+)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 10 : 4,
                      vertical: isWide ? 6 : 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isWide ? 18 : 12),
                      border: Border.all(color: const Color(0xFFCBD5E1), width: isWide ? 1.5 : 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.text_decrease_rounded, size: isWide ? 26 : 18),
                          tooltip: 'Yazıyı Küçült',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.all(isWide ? 9 : 5),
                          onPressed: () {
                            if (_fontScale > 0.9) {
                              setState(() => _fontScale -= 0.1);
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: isWide ? 8 : 3),
                          child: Text(
                            '${(_fontScale * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 16 : 11.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.text_increase_rounded, size: isWide ? 26 : 18),
                          tooltip: 'Yazıyı Büyüt',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.all(isWide ? 9 : 5),
                          onPressed: () {
                            if (_fontScale < 1.7) {
                              setState(() => _fontScale += 0.1);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: isWide ? 10 : 4),

                  // Mobilde Taşmayı Önleyen Menü / Geniş Ekranda Ayrı Butonlar
                  if (!isWide)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 21),
                      tooltip: 'İşlemler',
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      onSelected: (val) {
                        if (val == 'copy') _copyToClipboard();
                        if (val == 'edit') {
                          Navigator.pop(context);
                          widget.onEdit?.call();
                        }
                        if (val == 'delete') {
                          Navigator.pop(context);
                          widget.onDelete?.call();
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'copy',
                          child: Row(
                            children: [
                              Icon(Icons.copy_rounded, size: 18, color: AppColors.textPrimary),
                              SizedBox(width: 10),
                              Text('Notu Kopyala'),
                            ],
                          ),
                        ),
                        if (widget.onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_note_rounded, size: 18, color: Color(0xFF4F46E5)),
                                SizedBox(width: 10),
                                Text('Düzenle'),
                              ],
                            ),
                          ),
                        if (widget.onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
                                SizedBox(width: 10),
                                Text('Sil'),
                              ],
                            ),
                          ),
                      ],
                    )
                  else ...[
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 23),
                      tooltip: 'Notu Kopyala',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(10),
                      color: AppColors.textSecondary,
                      onPressed: _copyToClipboard,
                    ),
                    if (widget.onEdit != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.edit_note_rounded, size: 27),
                        tooltip: 'Notu Düzenle',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xFF4F46E5),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onEdit?.call();
                        },
                      ),
                    ],
                    if (widget.onDelete != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 23),
                        tooltip: 'Notu Sil',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xFFEF4444),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onDelete?.call();
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),

            // ── ANA OKUMA İÇERİĞİ (Geniş Ekranda Ortalı, Ferah ve Büyük Tipografi) ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? (screenWidth >= 1400 ? 36.0 : 22.0) : 16.0,
                  vertical: isWide ? 24 : 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth >= 1200
                          ? (screenWidth * 0.98).clamp(1100.0, 2200.0)
                          : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Üst Bilgi Satırı: Öğrenme Birimi, Tarih ve Etiket
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (note.unitTitle != null && note.unitTitle!.trim().isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.bookmark_rounded, size: 14, color: borderColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      note.unitTitle!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: borderColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Tarih
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textSecondary),
                                  const SizedBox(width: 5),
                                  Text(
                                    _formatDate(note.updatedAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Etiket
                            if (note.tag.trim().isNotEmpty && note.tag != 'Etiketsiz')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                                decoration: BoxDecoration(
                                  color: tagColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: tagColor.withValues(alpha: 0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(tagIcon, size: 14, color: tagColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      note.tag,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: tagColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Büyük Başlık
                        Text(
                          note.title,
                          style: GoogleFonts.outfit(
                            fontSize: (isLargeScreen ? 34.0 : (isWide ? 28.0 : 23.0)) * _fontScale,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            height: 1.22,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // İçerik Alanı (Tam Ekran Büyütülmüş Görünüm)
                        if (isWorkshop)
                          _buildFullscreenWorkshopView(note.content, isWide, _fontScale)
                        else if (isComparison)
                          _buildFullscreenComparisonView(note.content, isWide, _fontScale)
                        else
                          _buildFullscreenGeneralView(note.content, isWide, _fontScale),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TAM EKRAN: ATÖLYE / UYGULAMA ADIMLARI ──
  Widget _buildFullscreenWorkshopView(String content, bool isWide, double fontScale) {
    final stepChunks = content.split('⬇️');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < stepChunks.length; i++) ...[
          () {
            final raw = stepChunks[i].trim();
            final titleMatch = RegExp(r'【\s*(.*?)\s*】').firstMatch(raw);
            final stepTitle = titleMatch?.group(1) ?? '${i + 1}. Adım';
            final stepBody = raw.replaceAll(RegExp(r'【.*?】'), '').trim();

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(isWide ? 20 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF059669).withValues(alpha: 0.35),
                  width: 1.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF059669).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stepTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 14 * fontScale,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (stepBody.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      stepBody,
                      style: GoogleFonts.inter(
                        fontSize: (isWide ? 17.0 : 15.0) * fontScale,
                        color: const Color(0xFF1E293B),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }(),
          if (i < stepChunks.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF059669),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 16,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  // ── TAM EKRAN: KAVRAM KARŞILAŞTIRMA TABLOSU ──
  Widget _buildFullscreenComparisonView(String content, bool isWide, double fontScale) {
    // 1. Kavram isimlerini ayıkla
    final lines = content.split('\n');
    final concepts = <String>[];
    for (final l in lines) {
      final trimmed = l.trim();
      if (trimmed.startsWith('Kavramlar:')) {
        final raw = trimmed.replaceFirst('Kavramlar:', '').split(RegExp(r'➔|→|->|,|\s+vs\s+'));
        for (final r in raw) {
          final clean = r.trim();
          if (clean.isNotEmpty && !concepts.contains(clean)) concepts.add(clean);
        }
        break;
      }
    }

    // 2. Özellik bloklarını ayıkla (Hem yeni 【 Özellik: 】 hem eski ⚖️ bloklarını destekler)
    final rawBlocks = content.split('⚖️');
    final featureBlocks = <Map<String, dynamic>>[];

    for (int bIdx = 0; bIdx < rawBlocks.length; bIdx++) {
      final bText = rawBlocks[bIdx].trim();
      if (bText.isEmpty) continue;

      final isHeaderOnly = bText.startsWith('KAVRAM KARŞILAŞTIRMASI') &&
          !bText.contains('•') &&
          !bText.contains('-') &&
          !bText.contains('【');
      if (isHeaderOnly) continue;

      String featureTitle = '';
      final titleMatch = RegExp(r'【\s*Özellik:\s*(.*?)\s*】').firstMatch(bText);
      if (titleMatch != null) {
        featureTitle = titleMatch.group(1)!.trim();
      } else {
        final bLines = bText.split('\n');
        for (final bl in bLines) {
          final bt = bl.trim();
          if (bt.isEmpty || bt.startsWith('KAVRAM KARŞILAŞTIRMASI') || bt.startsWith('Kavramlar:')) {
            continue;
          }
          if (bt.startsWith('•') || bt.startsWith('-')) break;
          featureTitle = bt.replaceAll(RegExp(r'^[•\-\*#\s]+'), '').trim();
          break;
        }
      }
      if (featureTitle.isEmpty) {
        featureTitle = '${featureBlocks.length + 1}. Özellik';
      }

      final itemLines = bText.split('\n').where((s) => s.trim().isNotEmpty).toList();
      final extractedValues = <String, String>{};

      for (final line in itemLines) {
        final cleanLine = line.trim().replaceFirst(RegExp(r'^[•\-\*]\s*'), '').trim();
        if (cleanLine.startsWith('KAVRAM KARŞILAŞTIRMASI') ||
            cleanLine.startsWith('Kavramlar:') ||
            cleanLine.startsWith('【') ||
            cleanLine == featureTitle) {
          continue;
        }
        final colonIdx = cleanLine.indexOf(':');
        if (colonIdx > 0) {
          final cName = cleanLine.substring(0, colonIdx).trim();
          final cVal = cleanLine.substring(colonIdx + 1).trim();
          if (cName.isNotEmpty && cName != 'Özellik') {
            extractedValues[cName.toLowerCase()] = cVal.isNotEmpty ? cVal : '-';
            if (!concepts.any((c) => c.toLowerCase() == cName.toLowerCase())) {
              concepts.add(cName);
            }
          }
        }
      }

      if (extractedValues.isNotEmpty) {
        featureBlocks.add({
          'title': featureTitle,
          'values': extractedValues,
        });
      }
    }

    if (concepts.isEmpty || featureBlocks.isEmpty) {
      return _buildFullscreenGeneralView(content, isWide, fontScale);
    }

    // Mobilde (isWide == false): Yatay kaydırma gerektirmeyen, özellik bazlı dikey karşılaştırma akışı
    if (!isWide) {
      return _buildMobileComparisonFlowView(concepts, featureBlocks, fontScale);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleFactor = fontScale.clamp(1.0, 1.35);
        final minFeatureColWidth = (isWide ? 195.0 : 140.0) * scaleFactor;
        final minConceptColWidth = (isWide ? 205.0 : 160.0) * scaleFactor;
        final totalNeededWidth = minFeatureColWidth + (concepts.length * minConceptColWidth);
        // Container kenar bordürleri (1.5 + 1.5 = 3.0 px) ve render toleransı için güvenli dış genişlik:
        final tableOuterWidth = totalNeededWidth + 6.0;
        final canFitAllInRow = constraints.maxWidth >= tableOuterWidth;

        Widget buildTable() {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── TABLO SÜTUN BAŞLIKLARI (Üstte Kavramlar) ──
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      canFitAllInRow
                          ? Expanded(flex: 2, child: _buildFullscreenHeaderFeatureCell(fontScale))
                          : SizedBox(width: minFeatureColWidth, child: _buildFullscreenHeaderFeatureCell(fontScale)),
                      for (int cIdx = 0; cIdx < concepts.length; cIdx++)
                        canFitAllInRow
                            ? Expanded(
                                flex: 3,
                                child: _buildFullscreenHeaderConceptCell(
                                  concepts[cIdx],
                                  cIdx,
                                  isLast: cIdx == concepts.length - 1,
                                  fontScale: fontScale,
                                ),
                              )
                            : SizedBox(
                                width: minConceptColWidth,
                                child: _buildFullscreenHeaderConceptCell(
                                  concepts[cIdx],
                                  cIdx,
                                  isLast: cIdx == concepts.length - 1,
                                  fontScale: fontScale,
                                ),
                              ),
                    ],
                  ),
                ),

                // ── TABLO VERİ SATIRLARI (Sol tarafta Özellikler, Sütunlarda Karşılıkları) ──
                for (int fIdx = 0; fIdx < featureBlocks.length; fIdx++)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        canFitAllInRow
                            ? Expanded(
                                flex: 2,
                                child: _buildFullscreenDataFeatureCell(
                                  featureBlocks[fIdx]['title'] as String,
                                  fIdx,
                                  fontScale,
                                  isLastRow: fIdx == featureBlocks.length - 1,
                                ),
                              )
                            : SizedBox(
                                width: minFeatureColWidth,
                                child: _buildFullscreenDataFeatureCell(
                                  featureBlocks[fIdx]['title'] as String,
                                  fIdx,
                                  fontScale,
                                  isLastRow: fIdx == featureBlocks.length - 1,
                                ),
                              ),
                        for (int cIdx = 0; cIdx < concepts.length; cIdx++)
                          canFitAllInRow
                              ? Expanded(
                                  flex: 3,
                                  child: _buildFullscreenDataConceptValueCell(
                                    (featureBlocks[fIdx]['values'] as Map<String, String>)[concepts[cIdx].toLowerCase()] ?? '-',
                                    cIdx,
                                    isLastCol: cIdx == concepts.length - 1,
                                    fontScale: fontScale,
                                    rowIdx: fIdx,
                                    isLastRow: fIdx == featureBlocks.length - 1,
                                  ),
                                )
                              : SizedBox(
                                  width: minConceptColWidth,
                                  child: _buildFullscreenDataConceptValueCell(
                                    (featureBlocks[fIdx]['values'] as Map<String, String>)[concepts[cIdx].toLowerCase()] ?? '-',
                                    cIdx,
                                    isLastCol: cIdx == concepts.length - 1,
                                    fontScale: fontScale,
                                    rowIdx: fIdx,
                                    isLastRow: fIdx == featureBlocks.length - 1,
                                  ),
                                ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }

        if (canFitAllInRow) {
          return buildTable();
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableOuterWidth,
              child: buildTable(),
            ),
          );
        }
      },
    );
  }

  // ── MOBİL: ÖZELLİK BAZLI DİKEY KARŞILAŞTIRMA AKIŞI (Sıfır Yatay Kaydırma) ──
  Widget _buildMobileComparisonFlowView(
    List<String> concepts,
    List<Map<String, dynamic>> featureBlocks,
    double fontScale,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Üst Kavram Rozetleri Barı (Hangi kavramlar kıyaslanıyor)
        _buildMobileComparisonConceptsBar(concepts, fontScale),

        const SizedBox(height: 14),

        // 2. Özellik Kartları (Her özellik altında kavramlar alt alta dizilir)
        for (int fIdx = 0; fIdx < featureBlocks.length; fIdx++) ...[
          _buildMobileComparisonFeatureCard(
            fIdx,
            featureBlocks[fIdx],
            concepts,
            fontScale,
          ),
          if (fIdx < featureBlocks.length - 1)
            _buildMobileComparisonConnector(),
        ],
      ],
    );
  }

  Widget _buildMobileComparisonConceptsBar(List<String> concepts, double fontScale) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.compare_arrows_rounded,
                  size: 15,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Karşılaştırılan Kavramlar (${concepts.length})',
                style: GoogleFonts.outfit(
                  fontSize: 13.5 * fontScale,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (int cIdx = 0; cIdx < concepts.length; cIdx++) ...[
                () {
                  final cName = concepts[cIdx];
                  final cColor = ComparisonColors.getColor(cIdx);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: cColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: cColor.withValues(alpha: 0.35), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7.5,
                          height: 7.5,
                          decoration: BoxDecoration(
                            color: cColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          cName,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5 * fontScale,
                            fontWeight: FontWeight.w800,
                            color: cColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileComparisonFeatureCard(
    int fIdx,
    Map<String, dynamic> fb,
    List<String> concepts,
    double fontScale,
  ) {
    final featureTitle = fb['title'] as String;
    final Map<String, String> valuesMap = fb['values'] as Map<String, String>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Özellik Başlık Bandı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(
                bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 15,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    featureTitle,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5 * fontScale,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kavramlar Dikey Listesi (Her kavram alt alta açık ve net)
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              children: [
                for (int cIdx = 0; cIdx < concepts.length; cIdx++) ...[
                  () {
                    final cName = concepts[cIdx];
                    final val = valuesMap[cName.toLowerCase()] ?? '-';
                    final cColor = ComparisonColors.getColor(cIdx);
                    final isLastConcept = cIdx == concepts.length - 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: isLastConcept ? 0 : 8),
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: cColor.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cColor.withValues(alpha: 0.28), width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kavram Adı Başlığı
                          Row(
                            children: [
                              Container(
                                width: 8.5,
                                height: 8.5,
                                decoration: BoxDecoration(
                                  color: cColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  cName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5 * fontScale,
                                    fontWeight: FontWeight.w800,
                                    color: cColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Değer Metni (Tam genişlikte, ferah)
                          Text(
                            val,
                            style: GoogleFonts.inter(
                              fontSize: 14 * fontScale,
                              fontWeight: FontWeight.w500,
                              color: val == '-' ? AppColors.textHint : const Color(0xFF1E293B),
                              fontStyle: val == '-' ? FontStyle.italic : FontStyle.normal,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    );
                  }(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileComparisonConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF0284C7).withValues(alpha: 0.28),
              width: 1.2,
            ),
          ),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16,
            color: Color(0xFF0284C7),
          ),
        ),
      ),
    );
  }

  Widget _buildFullscreenHeaderFeatureCell(double fontScale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        border: Border(
          right: BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
          bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Özellikler',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 14.0 * fontScale,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullscreenHeaderConceptCell(
    String conceptName,
    int index, {
    required bool isLast,
    required double fontScale,
  }) {
    final color = ComparisonColors.getColor(index);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border(
          right: isLast ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
          bottom: const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                conceptName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14.0 * fontScale,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreenDataFeatureCell(
    String title,
    int rowIdx,
    double fontScale, {
    bool isLastRow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: rowIdx.isEven ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9),
        border: Border(
          right: const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
          bottom: isLastRow ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF0284C7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 14.5 * fontScale,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullscreenDataConceptValueCell(
    String value,
    int colIdx, {
    required bool isLastCol,
    required double fontScale,
    int rowIdx = 0,
    bool isLastRow = false,
  }) {
    final color = ComparisonColors.getColor(colIdx);
    final isNone = value == '-' || value.trim().isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: rowIdx.isEven ? 0.05 : 0.095),
        border: Border(
          right: isLastCol ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
          bottom: isLastRow ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.3),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: isNone
          ? Text(
              '—',
              style: GoogleFonts.inter(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.40),
              ),
            )
          : Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.5 * fontScale,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
                height: 1.45,
              ),
            ),
    );
  }

  // ── TAM EKRAN: SERBEST DERS NOTU (Büyük, Akıcı Tipografi) ──
  Widget _buildFullscreenGeneralView(String content, bool isWide, double fontScale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isWide ? 26 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        content,
        style: GoogleFonts.inter(
          fontSize: (isWide ? 18.0 : 16.0) * fontScale,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1E293B),
          height: 1.7,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}
