import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/course_note_model.dart';
import '../../domain/models/comparison_colors.dart';
import '../screens/note_fullscreen_reader_screen.dart';

class NoteColors {
  // Not kartının zemin rengi (pastel, okunaklı, defter yaprağı tonları)
  static const List<Color> bgColors = [
    Color(0xFFFEF3C7), // 0: Sıcak Defter Sarısı
    Color(0xFFE0F2FE), // 1: Gökyüzü Mavisi
    Color(0xFFDCFCE7), // 2: Nane Yeşili
    Color(0xFFFFE4E6), // 3: Gül Pembesi
    Color(0xFFF3E8FF), // 4: Lavanta Moru
    Color(0xFFF1F5F9), // 5: İnci Grisi
  ];

  // Renk seçim butonlarında net görünen canlı renkler
  static const List<Color> pickerColors = [
    Color(0xFFF59E0B), // 0: Canlı Sarı / Kehribar
    Color(0xFF0EA5E9), // 1: Canlı Mavi / Okyanus
    Color(0xFF10B981), // 2: Canlı Yeşil / Zümrüt
    Color(0xFFF43F5E), // 3: Canlı Pembe / Mercan
    Color(0xFFA855F7), // 4: Canlı Mor / Lavanta
    Color(0xFF64748B), // 5: Canlı Gri / Arduvaz
  ];

  static const List<Color> borderColors = [
    Color(0xFFD97706),
    Color(0xFF0284C7),
    Color(0xFF059669),
    Color(0xFFE11D48),
    Color(0xFF9333EA),
    Color(0xFF475569),
  ];

  static const List<String> colorNames = [
    'Sarı',
    'Mavi',
    'Yeşil',
    'Pembe',
    'Mor',
    'Gri',
  ];
}

class NoteCardWidget extends StatefulWidget {
  final CourseNoteModel note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final bool initiallyExpanded;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
    this.initiallyExpanded = false, // Varsayılan olarak kapalı başlar
  });

  @override
  State<NoteCardWidget> createState() => _NoteCardWidgetState();
}

class _NoteCardWidgetState extends State<NoteCardWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(covariant NoteCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _openFullscreenReader(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFullscreenReaderScreen(
          note: widget.note,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
    ];
    final day = dt.day;
    final month = months[dt.month];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month, $hour:$minute';
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

  void _copyToClipboard(BuildContext context) {
    final note = widget.note;
    final copyText = '''
[${note.courseTitle} - ${note.unitTitle ?? 'Genel Not'}]
📌 ${note.title}
${note.content}
''';
    Clipboard.setData(ClipboardData(text: copyText.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Not panoya kopyalandı!',
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: AppColors.primarySeed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final isWide = MediaQuery.of(context).size.width >= 768;
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

    return Container(
      margin: EdgeInsets.only(bottom: isWide ? 18 : 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isWide ? 22 : 18),
        border: Border.all(
          color: _isExpanded
              ? borderColor.withValues(alpha: 0.75)
              : borderColor.withValues(alpha: 0.45),
          width: isWide ? 1.8 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: _isExpanded ? 0.12 : 0.07),
            blurRadius: isWide ? 16 : 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(isWide ? 22 : 18),
        child: InkWell(
          borderRadius: BorderRadius.circular(isWide ? 22 : 18),
          onTap: _toggleExpanded,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 20 : 14,
              isWide ? 16 : 12,
              isWide ? 18 : 12,
              isWide ? 16 : 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                          // ── ÜST SATIR: Rozetler, Tarih ve Açılır/Kapanır İkonu ──
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    // Sınıf & Ders Rozeti (Uzun ders isimlerinde taşmayı önlemek için Flexible)
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 9 : 7,
                                          vertical: isWide ? 4.5 : 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          borderRadius: BorderRadius.circular(isWide ? 9 : 7),
                                          border: Border.all(
                                            color: borderColor.withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: isWide ? 6 : 5,
                                                vertical: isWide ? 2 : 1,
                                              ),
                                              decoration: BoxDecoration(
                                                color: borderColor,
                                                borderRadius: BorderRadius.circular(isWide ? 5 : 4),
                                              ),
                                              child: Text(
                                                '${note.grade}. Sınıf',
                                                style: GoogleFonts.inter(
                                                  fontSize: isWide ? 11.5 : 10,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: isWide ? 7 : 5),
                                            Flexible(
                                              child: Text(
                                                note.courseTitle,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: isWide ? 13 : 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Tarih
                                    Text(
                                      _formatDate(note.updatedAt),
                                      style: GoogleFonts.inter(
                                        fontSize: isWide ? 12 : 10.5,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary.withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 6),

                              // Tam Ekran Butonu (Tek tıkla doğrudan tam ekrana geçiş)
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(isWide ? 6 : 4),
                                icon: Icon(
                                  Icons.fullscreen_rounded,
                                  size: isWide ? 23 : 20,
                                  color: borderColor,
                                ),
                                tooltip: 'Tam Ekran Oku',
                                onPressed: () => _openFullscreenReader(context),
                              ),

                              // Aç/Kapat Chevron Oku (Açılır pencere hissi)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedRotation(
                                  turns: _isExpanded ? 0.5 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: isWide ? 22 : 19,
                                    color: borderColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Öğrenme Birimi Rozeti (varsa)
                          if (note.unitTitle != null && note.unitTitle!.trim().isNotEmpty) ...[
                            SizedBox(height: isWide ? 8 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 10 : 8,
                                vertical: isWide ? 4 : 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(isWide ? 8 : 6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bookmark_rounded,
                                    size: isWide ? 15 : 12,
                                    color: borderColor,
                                  ),
                                  SizedBox(width: isWide ? 6 : 4),
                                  Flexible(
                                    child: Text(
                                      note.unitTitle!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: isWide ? 13 : 11,
                                        fontWeight: FontWeight.w600,
                                        color: borderColor.withValues(alpha: 0.95),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: isWide ? 12 : 8),

                          // Başlık (Her zaman görünür, açılır pencerenin ana başlığı)
                          Text(
                            note.title,
                            style: GoogleFonts.outfit(
                              fontSize: isWide ? 22 : 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.25,
                            ),
                          ),

                          // ════════════════════════════════════════════════
                          // KAPALI DURUM (Collapsed): Sadece başlık & özet etiketler
                          // ════════════════════════════════════════════════
                          if (!_isExpanded) ...[
                            SizedBox(height: isWide ? 10 : 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Şablon / Tür Göstergesi
                                if (isWorkshop)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.format_list_numbered_rounded, size: 13, color: Color(0xFF0284C7)),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Uygulama Adımları (${note.content.split('⬇️').length} Adım)',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 12 : 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0284C7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (isComparison)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.compare_arrows_rounded, size: 13, color: Color(0xFF7C3AED)),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Kavram Karşılaştırma',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 12 : 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF7C3AED),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (note.tag.trim().isNotEmpty && note.tag != 'Etiketsiz')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: tagColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: tagColor.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(tagIcon, size: 13, color: tagColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          note.tag,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 12 : 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: tagColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),

                                // "Aç / Oku" İpucu
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Açmak için dokunun',
                                      style: GoogleFonts.inter(
                                        fontSize: isWide ? 12 : 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: borderColor.withValues(alpha: 0.9),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      Icons.touch_app_rounded,
                                      size: isWide ? 15 : 13,
                                      color: borderColor.withValues(alpha: 0.9),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],

                          // ════════════════════════════════════════════════
                          // AÇIK DURUM (Expanded): Tam içerik + Tam Ekran Butonu + Alt Bar
                          // ════════════════════════════════════════════════
                          if (_isExpanded) ...[
                            SizedBox(height: isWide ? 12 : 8),

                            // İçerik (Geniş ekranda akıcı, okunaklı büyük yazı)
                            if (isWorkshop) ...[
                              _buildWorkshopFlowView(note.content, isWide),
                            ] else if (isComparison) ...[
                              _buildComparisonFlowView(note.content, isWide),
                            ] else ...[
                              _buildGeneralView(note.content, isWide),
                            ],

                            SizedBox(height: isWide ? 14 : 10),

                            // ── TAM EKRAN OKUMA BUTONU (Özel ve Belirgin) ──
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.95),
                                    Colors.white.withValues(alpha: 0.85),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: borderColor.withValues(alpha: 0.4),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: borderColor.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => _openFullscreenReader(context),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isWide ? 16 : 12,
                                    vertical: isWide ? 11 : 9,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.open_in_full_rounded,
                                        size: isWide ? 19 : 17,
                                        color: borderColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Tam Ekran Görünümünde Oku',
                                        style: GoogleFonts.outfit(
                                          fontSize: isWide ? 14.5 : 13,
                                          fontWeight: FontWeight.w800,
                                          color: borderColor,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: isWide ? 16 : 14,
                                        color: borderColor.withValues(alpha: 0.7),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isWide ? 14 : 10),

                            // Alt Bar: Etiket Rozeti, Kapat butonu ve Aksiyon Butonları
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Etiket Rozeti (Varsa gösterilir)
                                if (note.tag.trim().isNotEmpty && note.tag != 'Etiketsiz')
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isWide ? 10 : 8,
                                      vertical: isWide ? 5 : 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(isWide ? 14 : 12),
                                      border: Border.all(
                                        color: tagColor.withValues(alpha: 0.35),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(tagIcon, size: isWide ? 15 : 13, color: tagColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          note.tag,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 12 : 11,
                                            fontWeight: FontWeight.w700,
                                            color: tagColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),

                                // Notu Kapat / Daralt Butonu
                                InkWell(
                                  onTap: _toggleExpanded,
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Kapat',
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 12 : 11,
                                            fontWeight: FontWeight.w600,
                                            color: borderColor,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          Icons.keyboard_arrow_up_rounded,
                                          size: isWide ? 18 : 16,
                                          color: borderColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),

                                // Aksiyon İkonları
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Kopyala
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(isWide ? 8 : 6),
                                      icon: Icon(
                                        Icons.copy_rounded,
                                        size: isWide ? 22 : 18,
                                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                                      ),
                                      tooltip: 'Panoya Kopyala',
                                      onPressed: () => _copyToClipboard(context),
                                    ),

                                    SizedBox(width: isWide ? 6 : 4),

                                    // Düzenle
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(isWide ? 8 : 6),
                                      icon: Icon(
                                        Icons.edit_note_rounded,
                                        size: isWide ? 26 : 21,
                                        color: AppColors.primaryMid,
                                      ),
                                      tooltip: 'Düzenle',
                                      onPressed: widget.onEdit,
                                    ),

                                    SizedBox(width: isWide ? 6 : 4),

                                    // Sil
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(isWide ? 8 : 6),
                                      icon: Icon(
                                        Icons.delete_outline_rounded,
                                        size: isWide ? 22 : 18,
                                        color: const Color(0xFFEF4444),
                                      ),
                                      tooltip: 'Sil',
                                      onPressed: widget.onDelete,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  Widget _buildWorkshopFlowView(String content, bool isWide) {
    final stepChunks = content.split('⬇️');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < stepChunks.length; i++) ...[
          () {
            final raw = stepChunks[i].trim();
            final titleMatch = RegExp(r'【\s*(.*?)\s*】').firstMatch(raw);
            final title = titleMatch?.group(1) ?? 'Adım ${i + 1}';
            final body = raw.replaceAll(RegExp(r'【.*?】'), '').trim();

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 14 : 10,
                vertical: isWide ? 10 : 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF059669).withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${i + 1}. Adım',
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 12 : 10.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title.replaceAll(RegExp(r'^\d+\.\s*Adım:?\s*'), ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: isWide ? 14 : 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF065F46),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 14.5 : 12.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1E293B),
                        height: 1.45,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }(),
          if (i < stepChunks.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Center(
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF059669).withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 13,
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

  Widget _buildGeneralView(String content, bool isWide) {
    return Text(
      content,
      style: GoogleFonts.inter(
        fontSize: isWide ? 16 : 13.5,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF1E293B),
        height: 1.55,
      ),
    );
  }

  Widget _buildComparisonFlowView(String content, bool isWide) {
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

      // Sadece başlık olan bloğu (içinde veri yoksa) atla
      final isHeaderOnly = bText.startsWith('KAVRAM KARŞILAŞTIRMASI') &&
          !bText.contains('•') &&
          !bText.contains('-') &&
          !bText.contains('【');
      if (isHeaderOnly) continue;

      // Özellik başlığını bul
      String featureTitle = '';
      final titleMatch = RegExp(r'【\s*Özellik:\s*(.*?)\s*】').firstMatch(bText);
      if (titleMatch != null) {
        featureTitle = titleMatch.group(1)!.trim();
      } else {
        // Eski format desteği: İlk satırdaki metni başlık yap
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

      // Satırlardaki kavram: değer çiftlerini topla
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
      return _buildGeneralView(content, isWide);
    }

    // Mobilde (isWide == false): Yatay kaydırma gerektirmeyen, özellik bazlı dikey karşılaştırma akışı
    if (!isWide) {
      return _buildMobileComparisonFlowView(concepts, featureBlocks);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final minFeatureColWidth = isWide ? 150.0 : 120.0;
        final minConceptColWidth = isWide ? 160.0 : 130.0;
        final totalNeededWidth = minFeatureColWidth + (concepts.length * minConceptColWidth);
        // Container kenar bordürleri (1.3 + 1.3 = 2.6 px) ve güvenli pay:
        final tableOuterWidth = totalNeededWidth + 6.0;
        final canFitAllInRow = constraints.maxWidth >= tableOuterWidth;

        Widget buildTable() {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                          ? Expanded(flex: 2, child: _buildCardHeaderFeatureCell(isWide))
                          : SizedBox(width: minFeatureColWidth, child: _buildCardHeaderFeatureCell(isWide)),
                      for (int cIdx = 0; cIdx < concepts.length; cIdx++)
                        canFitAllInRow
                            ? Expanded(
                                flex: 3,
                                child: _buildCardHeaderConceptCell(
                                  concepts[cIdx],
                                  cIdx,
                                  isLast: cIdx == concepts.length - 1,
                                  isWide: isWide,
                                ),
                              )
                            : SizedBox(
                                width: minConceptColWidth,
                                child: _buildCardHeaderConceptCell(
                                  concepts[cIdx],
                                  cIdx,
                                  isLast: cIdx == concepts.length - 1,
                                  isWide: isWide,
                                ),
                              ),
                    ],
                  ),
                ),

                // ── TABLO VERİ SATIRLARI (Sol tarafta Özellikler) ──
                for (int fIdx = 0; fIdx < featureBlocks.length; fIdx++)
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        canFitAllInRow
                            ? Expanded(
                                flex: 2,
                                child: _buildCardDataFeatureCell(
                                  featureBlocks[fIdx]['title'] as String,
                                  isWide,
                                  rowIdx: fIdx,
                                  isLastRow: fIdx == featureBlocks.length - 1,
                                ),
                              )
                            : SizedBox(
                                width: minFeatureColWidth,
                                child: _buildCardDataFeatureCell(
                                  featureBlocks[fIdx]['title'] as String,
                                  isWide,
                                  rowIdx: fIdx,
                                  isLastRow: fIdx == featureBlocks.length - 1,
                                ),
                              ),
                        for (int cIdx = 0; cIdx < concepts.length; cIdx++)
                          canFitAllInRow
                              ? Expanded(
                                  flex: 3,
                                  child: _buildCardDataConceptValueCell(
                                    (featureBlocks[fIdx]['values'] as Map<String, String>)[concepts[cIdx].toLowerCase()] ?? '-',
                                    cIdx,
                                    isLastCol: cIdx == concepts.length - 1,
                                    isWide: isWide,
                                    rowIdx: fIdx,
                                    isLastRow: fIdx == featureBlocks.length - 1,
                                  ),
                                )
                              : SizedBox(
                                  width: minConceptColWidth,
                                  child: _buildCardDataConceptValueCell(
                                    (featureBlocks[fIdx]['values'] as Map<String, String>)[concepts[cIdx].toLowerCase()] ?? '-',
                                    cIdx,
                                    isLastCol: cIdx == concepts.length - 1,
                                    isWide: isWide,
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Üst Kavram Rozetleri Barı
        _buildMobileComparisonConceptsBar(concepts),

        const SizedBox(height: 12),

        // 2. Özellik Kartları (Dikey Akış)
        for (int fIdx = 0; fIdx < featureBlocks.length; fIdx++) ...[
          _buildMobileComparisonFeatureCard(
            fIdx,
            featureBlocks[fIdx],
            concepts,
          ),
          if (fIdx < featureBlocks.length - 1)
            _buildMobileComparisonConnector(),
        ],
      ],
    );
  }

  Widget _buildMobileComparisonConceptsBar(List<String> concepts) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.compare_arrows_rounded,
                  size: 14,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Karşılaştırılan Kavramlar (${concepts.length})',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (int cIdx = 0; cIdx < concepts.length; cIdx++) ...[
                () {
                  final cName = concepts[cIdx];
                  final cColor = ComparisonColors.getColor(cIdx);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cColor.withValues(alpha: 0.35), width: 1.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: cColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          cName,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
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
  ) {
    final featureTitle = fb['title'] as String;
    final Map<String, String> valuesMap = fb['values'] as Map<String, String>;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Özellik Başlık Bandı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              border: Border(
                bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 13,
                    color: Color(0xFF0284C7),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    featureTitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kavramlar Dikey Listesi
          Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                for (int cIdx = 0; cIdx < concepts.length; cIdx++) ...[
                  () {
                    final cName = concepts[cIdx];
                    final val = valuesMap[cName.toLowerCase()] ?? '-';
                    final cColor = ComparisonColors.getColor(cIdx);
                    final isLastConcept = cIdx == concepts.length - 1;

                    return Container(
                      margin: EdgeInsets.only(bottom: isLastConcept ? 0 : 7),
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: cColor.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cColor.withValues(alpha: 0.25), width: 1.1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                              Expanded(
                                child: Text(
                                  cName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: cColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            val,
                            style: GoogleFonts.inter(
                              fontSize: 13,
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF0284C7).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF0284C7).withValues(alpha: 0.28),
              width: 1.1,
            ),
          ),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 15,
            color: Color(0xFF0284C7),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeaderFeatureCell(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        border: Border(
          right: BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          bottom: BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tune_rounded, size: isWide ? 14 : 12, color: const Color(0xFF0284C7)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              'Özellikler',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: isWide ? 12.5 : 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeaderConceptCell(
    String conceptName,
    int index, {
    required bool isLast,
    required bool isWide,
  }) {
    final color = ComparisonColors.getColor(index);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 10 : 6, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border(
          right: isLast ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          bottom: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isWide ? 9 : 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1.8),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.20),
              blurRadius: 4,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                conceptName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isWide ? 12 : 11,
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

  Widget _buildCardDataFeatureCell(
    String title,
    bool isWide, {
    int rowIdx = 0,
    bool isLastRow = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 10),
      decoration: BoxDecoration(
        color: rowIdx.isEven ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9),
        border: Border(
          right: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          bottom: isLastRow ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF0284C7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: isWide ? 12.5 : 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDataConceptValueCell(
    String value,
    int colIdx, {
    required bool isLastCol,
    required bool isWide,
    int rowIdx = 0,
    bool isLastRow = false,
  }) {
    final color = ComparisonColors.getColor(colIdx);
    final isNone = value == '-' || value.trim().isEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: rowIdx.isEven ? 0.045 : 0.085),
        border: Border(
          right: isLastCol ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
          bottom: isLastRow ? BorderSide.none : const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: isNone
          ? Text(
              '—',
              style: GoogleFonts.inter(
                fontSize: isWide ? 13 : 11.5,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.40),
              ),
            )
          : Text(
              value,
              style: GoogleFonts.inter(
                fontSize: isWide ? 13 : 11.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
                height: 1.4,
              ),
            ),
    );
  }
}
