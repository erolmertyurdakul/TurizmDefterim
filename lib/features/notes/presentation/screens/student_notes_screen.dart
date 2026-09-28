import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/providers/course_provider.dart';
import '../../data/models/course_note_model.dart';
import '../../data/models/note_template.dart';
import '../../../badges/providers/badge_provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card_widget.dart';
import '../widgets/note_editor_dialog.dart';

enum NotesEntrySource {
  mainMenu,      // Sınıflar menüsü / Ana menüden girildi -> "Menüye Dön"
  courseDetail,  // Ders ekranından girildi -> "Ders Ekranına Dön"
  learningUnit,  // Öğrenme birimi / Ders notundan girildi -> "Öğrenme Birimine Dön"
}

class StudentNotesScreen extends ConsumerStatefulWidget {
  final String? initialGrade;
  final String? initialCourseId;
  final String? initialCourseTitle;
  final int? initialUnitIndex;
  final String? initialUnitTitle;
  final List<Color>? gradient;
  final NotesEntrySource? entrySource;

  const StudentNotesScreen({
    super.key,
    this.initialGrade,
    this.initialCourseId,
    this.initialCourseTitle,
    this.initialUnitIndex,
    this.initialUnitTitle,
    this.gradient,
    this.entrySource,
  });

  @override
  ConsumerState<StudentNotesScreen> createState() => _StudentNotesScreenState();
}

class _StudentNotesScreenState extends ConsumerState<StudentNotesScreen> {
  // Aktif Gezinme Durumları
  late String? _currentGrade;
  late String? _currentCourseId;
  late String? _currentCourseTitle;
  late int? _currentUnitIndex;
  late String? _currentUnitTitle;

  // Filtreler & Arama
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGradeFilter = 'Tümü'; // 'Tümü', '9', '10', '11', '12'
  String _selectedTagFilter = 'Tümü'; // 'Tümü', 'Önemli', 'Sınav', 'Tanım', vb.
  int? _lastSyncedNotesCount;

  @override
  void initState() {
    super.initState();
    _currentGrade = widget.initialGrade;
    _currentCourseId = widget.initialCourseId;
    _currentCourseTitle = widget.initialCourseTitle;
    _currentUnitIndex = widget.initialUnitIndex;
    _currentUnitTitle = widget.initialUnitTitle;

    // Eğer grade verilmemişse ancak courseId verilmişse otomatik çöz
    if (_currentGrade == null && _currentCourseId != null) {
      final cId = _currentCourseId!.toLowerCase();
      if (cId.startsWith('9_') || cId.contains('mesleki_gelisim') || cId.contains('genel_turizm')) {
        _currentGrade = '9';
      } else if (cId.startsWith('10_') || cId.contains('konuk_giris') || cId.contains('rezervasyon')) {
        _currentGrade = '10';
      } else if (cId.startsWith('11_') || cId.contains('kat_hizmetleri') || cId.contains('camasirhane') || cId.contains('kuru_temizleme') || cId.contains('dunya_kahvalti')) {
        _currentGrade = '11';
      } else {
        _currentGrade = '12';
      }
    }

    if (_currentGrade != null) {
      _selectedGradeFilter = _currentGrade!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeCourseId(String title, String grade) {
    if (title == 'Kat Hizmetleri Atölyesi') {
      return '${grade}_kat_hizmetleri_atolyesi';
    }
    switch (title) {
      case 'Ön Büro Hizmetleri Atölyesi': return 'on_buro_hizmetleri_atolyesi';
      case 'Ön Büroda Rezervasyon': return 'on_buro_rezervasyon';
      case 'Konuk Giriş Çıkış İşlemleri': return 'konuk_giris_cikis_islemleri';
      case 'Konaklama İşletmeciliği': return 'konaklama_isletmeciligi';
      case 'Sürdürülebilir Turizm': return 'surdurulebilir_turizm';
      case 'Alternatif Turizm': return 'alternatif_turizm';
      case 'Kuru Temizleme İşlemleri': return 'kuru_temizleme_islemleri';
      case 'Çamaşırhane İşlemleri': return 'camasirhane_islemleri';
      case 'Dünya Seyahat ve Turizm Coğrafyası': return 'dunya_seyahat_ve_turizm_cografyasi';
      case 'Dünya Kültürleri': return 'dunya_kulturleri';
      case 'Kongre ve Etkinlik Turizmi': return 'kongre_ve_etkinlik_turizmi';
      case 'Gastronomi Turizmi': return 'gastronomi_turizmi';
      case 'Tur Operasyonu': return 'tur_operasyonu';
      case 'Transfer Operasyonu': return 'transfer_operasyonu';
      case 'Sosyal Medya': return 'sosyal_medya';
      case 'Mesleki Gelişim Atölyesi': return 'mesleki_gelisim_atolyesi';
      case 'Genel Turizm': return 'genel_turizm';
      case 'Otelcilik ve Seyahat Hizmetleri': return 'otelcilik_ve_seyahat_hizmetleri';
      default:
        return title.toLowerCase()
            .replaceAll(' ', '_')
            .replaceAll('ö', 'o')
            .replaceAll('ü', 'u')
            .replaceAll('ı', 'i')
            .replaceAll('ş', 's')
            .replaceAll('ç', 'c')
            .replaceAll('ğ', 'g');
    }
  }

  List<Color> _getActiveGradient() {
    if (widget.gradient != null) return widget.gradient!;
    if (_currentGrade == '9') return AppColors.grade9Gradient;
    if (_currentGrade == '10') return AppColors.grade10Gradient;
    if (_currentGrade == '11') return AppColors.grade11Gradient;
    if (_currentGrade == '12') return AppColors.grade12Gradient;
    return AppColors.oceanGradient;
  }

  // ── Giriş Kaynağı ve Çıkış Butonu Başlığı ──
  NotesEntrySource get _effectiveEntrySource {
    if (widget.entrySource != null) return widget.entrySource!;
    if (widget.initialUnitIndex != null) return NotesEntrySource.learningUnit;
    if (widget.initialCourseId != null) return NotesEntrySource.courseDetail;
    return NotesEntrySource.mainMenu;
  }

  String get _exitButtonLabel {
    switch (_effectiveEntrySource) {
      case NotesEntrySource.learningUnit:
        return 'Öğrenme Birimine Dön';
      case NotesEntrySource.courseDetail:
        return 'Ders Ekranına Dön';
      case NotesEntrySource.mainMenu:
        return 'Menüye Dön';
    }
  }

  // ── Sol Üst Geri Butonu: Doğrudan Ders Seçim Ekranına / Üst Menüye Dönüş (Filtreye takılmaz) ──
  void _goToCourseDirectory() {
    setState(() {
      _currentCourseId = null;
      _currentCourseTitle = null;
      _currentGrade = null;
      _currentUnitIndex = null;
      _currentUnitTitle = null;
      _selectedGradeFilter = 'Tümü';
    });
  }

  // ── Çıkış Butonu Mantığı (Doğrudan Çıkış) ──
  void _handleExit() {
    Navigator.pop(context);
  }

  void _confirmDeleteNote(CourseNoteModel note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 10),
            Text(
              'Notu Sil',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          '“${note.title}” başlıklı notunuzu silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Vazgeç', style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(notesProvider.notifier).deleteNote(note.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Not başarıyla silindi.',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Evet, Sil', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _openNoteEditor({
    CourseNoteModel? noteToEdit,
    String? initialTag,
    NoteTemplateType? initialTemplateType,
  }) {
    final effectiveUnitIndex = (_currentUnitIndex != null && _currentUnitIndex! >= 0) ? _currentUnitIndex : null;
    final effectiveUnitTitle = (_currentUnitIndex != null && _currentUnitIndex! >= 0) ? _currentUnitTitle : null;

    NoteEditorDialog.show(
      context,
      noteToEdit: noteToEdit,
      initialGrade: _currentGrade,
      initialCourseId: _currentCourseId,
      initialCourseTitle: _currentCourseTitle,
      initialUnitIndex: effectiveUnitIndex,
      initialUnitTitle: effectiveUnitTitle,
      initialTag: initialTag ?? (_selectedTagFilter != 'Tümü' ? _selectedTagFilter : null),
      initialTemplateType: initialTemplateType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allNotes = ref.watch(notesProvider);
    final isWide = MediaQuery.of(context).size.width >= 768;
    final gradient = _getActiveGradient();

    // ── Not Filtreleme Mantığı ──
    var filteredNotes = allNotes;

    // 1. Ders veya Ünite filtreleri
    if (_currentCourseId != null) {
      filteredNotes = filteredNotes.where((n) => n.courseId == _currentCourseId).toList();
      if (_currentUnitIndex == -2) {
        // Sadece genel ders notları (öğrenme birimi seçilmemiş, derse özel notlar)
        filteredNotes = filteredNotes.where((n) => n.unitIndex == null).toList();
      } else if (_currentUnitIndex != null) {
        filteredNotes = filteredNotes.where((n) => n.unitIndex == _currentUnitIndex).toList();
      }
    } else if (_selectedGradeFilter != 'Tümü') {
      filteredNotes = filteredNotes.where((n) => n.grade == _selectedGradeFilter).toList();
    }

    // 2. Etiket Filtresi
    if (_selectedTagFilter != 'Tümü') {
      filteredNotes = filteredNotes.where((n) => n.tag == _selectedTagFilter).toList();
    }

    // 3. Arama Sorgusu
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      filteredNotes = filteredNotes.where((n) {
        return n.title.toLowerCase().contains(q) ||
            n.content.toLowerCase().contains(q) ||
            n.courseTitle.toLowerCase().contains(q) ||
            (n.unitTitle != null && n.unitTitle!.toLowerCase().contains(q)) ||
            n.tag.toLowerCase().contains(q);
      }).toList();
    }

    return PopScope(
      canPop: _currentCourseId == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentCourseId != null) {
          _goToCourseDirectory();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
          children: [
            // ── ÜST APPBAR (Geri + Başlık + Çıkış) ──
            _buildAppBar(context, gradient, isWide),

            // ── BREADCRUMB (Hiyerarşi Çubuğu) ──
            _buildBreadcrumbBar(isWide),

            // ── İÇERİK GÖVDE ALANI ──
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Arama ve Filtre Kontrolleri
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 36.0 : AppSizes.screenPadding,
                        16,
                        isWide ? 36.0 : AppSizes.screenPadding,
                        10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Arama Çubuğu
                          _buildSearchBar(isWide),

                          const SizedBox(height: 12),

                          // ── Açılır Filtre Butonları (Yan Yana: Birim/Sınıf + Etiket) ──
                          _buildFilterDropdownsRow(ref, gradient.first, isWide),
                        ],
                      ),
                    ),
                  ),

                  // Ders Seçim Kartları (Eğer Ders Seçilmemişse ve Tüm Dersler modundaysa)
                  if (_currentCourseId == null && _searchQuery.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 36.0 : AppSizes.screenPadding,
                          vertical: 8,
                        ),
                        child: _buildCourseDirectory(ref, isWide),
                      ),
                    ),

                  // Notlar Başlığı ve Sayaç
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 36.0 : AppSizes.screenPadding,
                        16,
                        isWide ? 36.0 : AppSizes.screenPadding,
                        12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                _currentCourseTitle != null ? 'Ders Notları' : 'Tüm Not Akışı',
                                style: GoogleFonts.outfit(
                                  fontSize: isWide ? 20 : 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: gradient.first.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${filteredNotes.length} Not',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: gradient.first,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _openNoteEditor(),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 14 : 10,
                                vertical: isWide ? 7 : 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: gradient.first.withValues(alpha: 0.35)),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient.first.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.auto_awesome_rounded, size: isWide ? 16 : 14, color: gradient.first),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Not Şablonları',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 13 : 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: gradient.first,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Not Listesi veya Boş Durum
                  if (filteredNotes.isEmpty)
                    SliverToBoxAdapter(
                      child: _buildEmptyState(isWide, gradient.first),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        isWide ? 36.0 : AppSizes.screenPadding,
                        4,
                        isWide ? 36.0 : AppSizes.screenPadding,
                        100, // FAB için alt boşluk
                      ),
                      sliver: MediaQuery.of(context).size.width >= 900
                          ? SliverToBoxAdapter(
                              child: _buildMasonryNotes(context, filteredNotes),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final note = filteredNotes[index];
                                  return NoteCardWidget(
                                    note: note,
                                    onEdit: () => _openNoteEditor(noteToEdit: note),
                                    onDelete: () => _confirmDeleteNote(note),
                                  );
                                },
                                childCount: filteredNotes.length,
                              ),
                            ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── FAB: YENİ NOT EKLE / NOT DEFTERİM BUTONU ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(),
        elevation: 4,
        highlightElevation: 8,
        backgroundColor: gradient.first,
        icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 24),
        label: Text(
          _currentUnitIndex == -2
              ? 'Genel Not Ekle'
              : (_currentUnitIndex != null ? 'Bu Birime Not Al' : 'Yeni Not Ekle'),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

  // ══════════════════════════════════════════
  // ══════════════════════════════════════════
  //  GENİŞ EKRANLAR İÇİN DİNAMİK MASONRY NOT DÜZENİ
  //  (Sabit en-boy oranı kullanmaz, kartlar kendi içeriği kadar uzar, ASLA taşma yapmaz)
  // ══════════════════════════════════════════
  Widget _buildMasonryNotes(BuildContext context, List<CourseNoteModel> notes) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxColumns = screenWidth >= 1350 ? 3 : 2;
    final columnCount = (notes.length < maxColumns ? notes.length : maxColumns).clamp(1, 3);

    // Tek not varsa ortalı ve okunaklı genişlikte göster
    if (columnCount <= 1) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: notes.map((note) {
              return NoteCardWidget(
                note: note,
                onEdit: () => _openNoteEditor(noteToEdit: note),
                onDelete: () => _confirmDeleteNote(note),
              );
            }).toList(),
          ),
        ),
      );
    }

    final columns = List.generate(columnCount, (_) => <CourseNoteModel>[]);
    for (int i = 0; i < notes.length; i++) {
      columns[i % columnCount].add(notes[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnCount, (colIndex) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: colIndex == 0 ? 0 : 9,
              right: colIndex == columnCount - 1 ? 0 : 9,
            ),
            child: Column(
              children: columns[colIndex].map((note) {
                return NoteCardWidget(
                  note: note,
                  onEdit: () => _openNoteEditor(noteToEdit: note),
                  onDelete: () => _confirmDeleteNote(note),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  // ══════════════════════════════════════════
  //  ÜST APPBAR: Geri + Başlık + Çıkış
  // ══════════════════════════════════════════
  Widget _buildAppBar(BuildContext context, List<Color> gradient, bool isWide) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 1200;

    if (isWide) {
      // ── PC / GENİŞ EKRAN / TAM EKRAN: Prestijli, Dengeli ve Belirgin Düzen ──
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 32 : 24,
          vertical: isLargeScreen ? 14 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            bottom: BorderSide(color: AppColors.divider, width: 1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sol Buton: Ders Seçim Ekranına Dön
            if (_currentCourseId != null) ...[
              InkWell(
                onTap: _goToCourseDirectory,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 16 : 13,
                    vertical: isLargeScreen ? 10 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: isLargeScreen ? 20 : 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        screenWidth >= 980 ? 'Ders Seçim Ekranına Dön' : 'Dersler',
                        style: GoogleFonts.inter(
                          fontSize: isLargeScreen ? 13.5 : 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: isLargeScreen ? 20 : 14),
            ],

            // Sol / Orta Başlık Bloğu (Büyük ekranda belirgin ve prestijli)
            Expanded(
              child: Row(
                children: [
                  // Defter İkon Amblemi
                  Container(
                    width: isLargeScreen ? 48 : 42,
                    height: isLargeScreen ? 48 : 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [gradient.first, gradient.last],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(isLargeScreen ? 14 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: isLargeScreen ? 25 : 22,
                    ),
                  ),
                  SizedBox(width: isLargeScreen ? 16 : 12),

                  // Başlık ve Rozetler
                  Expanded(
                    child: isLargeScreen
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Ana Ders Başlığı (Büyük ekranda prestijli ve belirgin)
                              Text(
                                _currentCourseTitle ?? 'Ders Seçimi & Not Akışı',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Sınıf ve Not Defterim Rozetleri (Ders isminin sağında, ferah ve yatay hizada)
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Sınıf Rozeti
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: gradient.first.withValues(alpha: 0.14),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: gradient.first.withValues(alpha: 0.45),
                                            width: 1.1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.school_rounded,
                                              size: 15,
                                              color: gradient.first,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              _currentGrade != null ? '${_currentGrade!}. Sınıf' : 'Tüm Sınıflar',
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: gradient.first,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Not Defterim Rozeti
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.edit_note_rounded,
                                              size: 17,
                                              color: Color(0xFF0F172A),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Not Defterim',
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Öğrenme Birimi (varsa)
                                      if (_currentUnitTitle != null && _currentUnitTitle!.trim().isNotEmpty) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.bookmark_rounded, size: 14, color: AppColors.primaryMid),
                                              const SizedBox(width: 4),
                                              Text(
                                                _currentUnitTitle!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Üst Rozet Satırı: Sınıf + Not Defterim (Telefon ekranlarında dikey hiyerarşi)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Sınıf Rozeti
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: gradient.first.withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: gradient.first.withValues(alpha: 0.45),
                                          width: 1.1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.school_rounded,
                                            size: 13,
                                            color: gradient.first,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            _currentGrade != null ? '${_currentGrade!}. Sınıf' : 'Tüm Sınıflar',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: gradient.first,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Not Defterim Rozeti
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.edit_note_rounded,
                                            size: 15,
                                            color: Color(0xFF0F172A),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Not Defterim',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Öğrenme Birimi (varsa)
                                    if (_currentUnitTitle != null && _currentUnitTitle!.trim().isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.bookmark_rounded, size: 14, color: AppColors.primaryMid),
                                            const SizedBox(width: 4),
                                            Text(
                                              _currentUnitTitle!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 3),

                              // Ana Ders Başlığı (Telefon ekranı)
                              Text(
                                _currentCourseTitle ?? 'Ders Seçimi & Not Akışı',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Sağ Üst Çıkış Butonu
            InkWell(
              onTap: _handleExit,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 16 : 14,
                  vertical: isLargeScreen ? 10 : 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFECACA), width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _exitButtonLabel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFDC2626),
                        fontSize: isLargeScreen ? 13.5 : 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.close_rounded,
                      color: const Color(0xFFDC2626),
                      size: isLargeScreen ? 19 : 17,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── MOBİL GÖRÜNÜM: Üstte Navigasyon Butonları, Altta Başlık ──
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Üst Navigasyon Satırı (Geri ve Çıkış butonları)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol Üst Buton (Yalnızca bir ders seçiliyken görünür, sınıf/ders seçim ekranında gizlidir)
              if (_currentCourseId != null)
                Flexible(
                  child: InkWell(
                    onTap: _goToCourseDirectory,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 15),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Ders Seçim Ekranına Dön',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),

              if (_currentCourseId != null) const SizedBox(width: 8),

              // Sağ Üst Çıkış Butonu (Giriş kaynağına göre net metin + Çarpı ikonu)
              InkWell(
                onTap: _handleExit,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _exitButtonLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFDC2626),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.close_rounded, color: Color(0xFFDC2626), size: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 2. Başlık ve Sınıf Rozeti
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: gradient.first.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _currentGrade != null ? '${_currentGrade!}. Sınıf' : 'Tüm Dersler',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: gradient.first,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Not Defterim',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            _currentCourseTitle ?? 'Ders Seçimi & Not Akışı',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════
  //  BREADCRUMB (Ekmek Kırıntısı Çubuğu)
  // ══════════════════════════════════════════
  Widget _buildBreadcrumbBar(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 36 : AppSizes.screenPadding,
        vertical: 8,
      ),
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Kök: Tüm Dersler
            InkWell(
              onTap: () {
                setState(() {
                  _currentCourseId = null;
                  _currentCourseTitle = null;
                  _currentGrade = null;
                  _currentUnitIndex = null;
                  _currentUnitTitle = null;
                  _selectedGradeFilter = 'Tümü';
                });
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 14,
                      color: _currentCourseId == null ? AppColors.primaryMid : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tüm Dersler',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: _currentCourseId == null ? FontWeight.w800 : FontWeight.w600,
                        color: _currentCourseId == null ? AppColors.primaryMid : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_currentCourseTitle != null) ...[
              const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textHint),
              InkWell(
                onTap: () {
                  setState(() {
                    _currentUnitIndex = null;
                    _currentUnitTitle = null;
                  });
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    _currentCourseTitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryMid,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  ARAMA ÇUBUĞU
  // ══════════════════════════════════════════
  Widget _buildSearchBar(bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: GoogleFonts.inter(fontSize: 14),
        decoration: InputDecoration(
          hintText: _currentCourseTitle != null
              ? '${_currentCourseTitle!} içindeki notlarda ara...'
              : 'Tüm notlarda anahtar kelime, konu veya terim ara...',
          hintStyle: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textHint),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  //  AÇILIR FİLTRE BUTONLARI (Geniş Ekranda Yan Yana, Kompakt ve Belirgin)
  // ══════════════════════════════════════════
  Widget _buildFilterDropdownsRow(WidgetRef ref, Color accentColor, bool isWide) {
    final unitButton = _currentCourseId != null
        ? _buildUnitDropdownButton(ref, accentColor, isWide)
        : _buildGradeDropdownButton(accentColor, isWide);
    final tagButton = _buildTagDropdownButton(isWide);

    if (isWide) {
      return Wrap(
        spacing: 14,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // 1. Sol Buton: Öğrenme Birimi veya Sınıf Seçici
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 340,
            ),
            child: unitButton,
          ),

          // 2. Sağ Buton: Etiket Filtresi
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 170,
              maxWidth: 240,
            ),
            child: tagButton,
          ),
        ],
      );
    }

    // Mobil ekranda satırı orantılı paylaşsınlar
    return Row(
      children: [
        Expanded(flex: 6, child: unitButton),
        const SizedBox(width: 10),
        Expanded(flex: 4, child: tagButton),
      ],
    );
  }

  // ── Öğrenme Birimi Açılır Butonu ──
  Widget _buildUnitDropdownButton(WidgetRef ref, Color accentColor, bool isWide) {
    String? grade = _currentGrade;
    Course? course;

    if (grade != null) {
      final courses = ref.watch(coursesProvider(grade));
      try {
        course = courses.firstWhere(
          (c) => _normalizeCourseId(c.title, grade!) == _currentCourseId || c.title == _currentCourseTitle,
        );
      } catch (_) {}
    }

    if (course == null) {
      for (final g in ['10', '9', '11', '12']) {
        final courses = ref.watch(coursesProvider(g));
        for (final c in courses) {
          if (_normalizeCourseId(c.title, g) == _currentCourseId || c.title == _currentCourseTitle) {
            course = c;
            grade = g;
            break;
          }
        }
        if (course != null) break;
      }
    }

    if (course == null) return const SizedBox.shrink();

    final units = course.learningUnits;
    final isFiltered = _currentUnitIndex != null;

    final String displayText;
    if (_currentUnitIndex == -2) {
      displayText = 'Genel Ders Notları';
    } else if (isFiltered && _currentUnitIndex! >= 0 && _currentUnitIndex! < units.length) {
      displayText = '${_currentUnitIndex! + 1}. Birim: ${units[_currentUnitIndex!].title}';
    } else if (isFiltered && _currentUnitTitle != null) {
      displayText = _currentUnitTitle!;
    } else {
      displayText = 'Tüm Öğrenme Birimleri';
    }

    return PopupMenuButton<int>(
      tooltip: 'Öğrenme Birimi Seç',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 52),
      onSelected: (int selectedVal) {
        setState(() {
          if (selectedVal == -1) {
            _currentUnitIndex = null;
            _currentUnitTitle = null;
          } else if (selectedVal == -2) {
            _currentUnitIndex = -2;
            _currentUnitTitle = 'Genel Ders Notları';
          } else if (selectedVal >= 0 && selectedVal < units.length) {
            _currentUnitIndex = selectedVal;
            _currentUnitTitle = '${selectedVal + 1}. Birim: ${units[selectedVal].title}';
          }
        });
      },
      itemBuilder: (context) {
        return [
          // 1. Tüm Öğrenme Birimleri
          PopupMenuItem<int>(
            value: -1,
            child: Row(
              children: [
                Icon(
                  Icons.layers_rounded,
                  size: isWide ? 20 : 18,
                  color: _currentUnitIndex == null ? accentColor : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tüm Öğrenme Birimleri',
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 14 : 13,
                      fontWeight: _currentUnitIndex == null ? FontWeight.w800 : FontWeight.w500,
                      color: _currentUnitIndex == null ? accentColor : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (_currentUnitIndex == null)
                  Icon(Icons.check_rounded, size: isWide ? 20 : 18, color: accentColor),
              ],
            ),
          ),
          // 2. Genel Ders Notları (Hemen Tüm Öğrenme Birimleri altında)
          PopupMenuItem<int>(
            value: -2,
            child: Row(
              children: [
                Icon(
                  Icons.push_pin_rounded,
                  size: isWide ? 20 : 18,
                  color: _currentUnitIndex == -2 ? accentColor : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Genel Ders Notları',
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 14 : 13,
                      fontWeight: _currentUnitIndex == -2 ? FontWeight.w800 : FontWeight.w500,
                      color: _currentUnitIndex == -2 ? accentColor : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (_currentUnitIndex == -2)
                  Icon(Icons.check_rounded, size: isWide ? 20 : 18, color: accentColor),
              ],
            ),
          ),
          const PopupMenuDivider(),
          // 3. Öğrenme Birimleri
          ...List.generate(units.length, (idx) {
            final isSel = _currentUnitIndex == idx;
            return PopupMenuItem<int>(
              value: idx,
              child: Row(
                children: [
                  Container(
                    width: isWide ? 26 : 22,
                    height: isWide ? 26 : 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSel ? accentColor : AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${idx + 1}',
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 12 : 11,
                        fontWeight: FontWeight.w700,
                        color: isSel ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      units[idx].title,
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 14 : 13,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                        color: isSel ? accentColor : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isSel)
                    Icon(Icons.check_rounded, size: isWide ? 20 : 18, color: accentColor),
                ],
              ),
            );
          }),
        ];
      },
      child: Container(
        height: isWide ? 50 : 46,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 12),
        decoration: BoxDecoration(
          color: isFiltered ? accentColor.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFiltered ? accentColor : AppColors.textSecondary.withValues(alpha: 0.35),
            width: isFiltered ? 2.0 : 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: isFiltered
                  ? accentColor.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isFiltered
                    ? accentColor.withValues(alpha: 0.2)
                    : AppColors.primarySeed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                _currentUnitIndex == -2
                    ? Icons.push_pin_rounded
                    : (isFiltered ? Icons.bookmark_rounded : Icons.layers_rounded),
                size: isWide ? 18 : 16,
                color: isFiltered ? accentColor : AppColors.primarySeed,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: isWide ? 14.5 : 13,
                  fontWeight: FontWeight.w700,
                  color: isFiltered ? accentColor : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isFiltered)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentUnitIndex = null;
                    _currentUnitTitle = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, size: isWide ? 15 : 13, color: accentColor),
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: isWide ? 22 : 18,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  // ── Sınıf Açılır Butonu (Tüm Dersler Modunda) ──
  Widget _buildGradeDropdownButton(Color accentColor, bool isWide) {
    final grades = ['Tümü', '9', '10', '11', '12'];
    final isFiltered = _selectedGradeFilter != 'Tümü';

    return PopupMenuButton<String>(
      tooltip: 'Sınıf Seç',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 52),
      onSelected: (String g) {
        setState(() {
          _selectedGradeFilter = g;
        });
      },
      itemBuilder: (context) {
        return grades.map((g) {
          final isSel = _selectedGradeFilter == g;
          return PopupMenuItem<String>(
            value: g,
            child: Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  size: isWide ? 20 : 18,
                  color: isSel ? AppColors.primarySeed : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    g == 'Tümü' ? 'Tüm Sınıflar' : '$g. Sınıf Dersleri',
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 14 : 13,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                      color: isSel ? AppColors.primarySeed : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSel)
                  Icon(Icons.check_rounded, size: isWide ? 20 : 18, color: AppColors.primarySeed),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        height: isWide ? 50 : 46,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 12),
        decoration: BoxDecoration(
          color: isFiltered ? AppColors.primarySeed.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFiltered ? AppColors.primarySeed : AppColors.textSecondary.withValues(alpha: 0.35),
            width: isFiltered ? 2.0 : 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: isFiltered
                  ? AppColors.primarySeed.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isFiltered
                    ? AppColors.primarySeed.withValues(alpha: 0.2)
                    : AppColors.primarySeed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                Icons.school_rounded,
                size: isWide ? 18 : 16,
                color: AppColors.primarySeed,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _selectedGradeFilter == 'Tümü' ? 'Tüm Sınıflar' : '$_selectedGradeFilter. Sınıf',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: isWide ? 14.5 : 13,
                  fontWeight: FontWeight.w700,
                  color: isFiltered ? AppColors.primarySeed : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isFiltered)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGradeFilter = 'Tümü';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySeed.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, size: isWide ? 15 : 13, color: AppColors.primarySeed),
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: isWide ? 22 : 18,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  // ── Etiket Açılır Butonu ──
  Widget _buildTagDropdownButton(bool isWide) {
    final tags = ['Tümü', 'Önemli', 'Sınav', 'Tanım', 'Ödev', 'İpucu', 'Kişisel'];
    final isFiltered = _selectedTagFilter != 'Tümü';
    final tagColor = isFiltered ? _getTagColor(_selectedTagFilter) : const Color(0xFF475569);

    return PopupMenuButton<String>(
      tooltip: 'Etiket Seç',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      offset: const Offset(0, 52),
      onSelected: (String tag) {
        setState(() {
          _selectedTagFilter = tag;
        });
      },
      itemBuilder: (context) {
        return tags.map((tag) {
          final isSel = _selectedTagFilter == tag;
          final color = tag == 'Tümü' ? AppColors.primaryMid : _getTagColor(tag);
          final icon = tag == 'Tümü' ? Icons.tag_rounded : _getTagIcon(tag);

          return PopupMenuItem<String>(
            value: tag,
            child: Row(
              children: [
                Icon(icon, size: isWide ? 20 : 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tag == 'Tümü' ? 'Tüm Etiketler' : '#$tag',
                    style: GoogleFonts.inter(
                      fontSize: isWide ? 14 : 13,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                      color: isSel ? color : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (isSel)
                  Icon(Icons.check_rounded, size: isWide ? 20 : 18, color: color),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        height: isWide ? 50 : 46,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 12),
        decoration: BoxDecoration(
          color: isFiltered ? tagColor.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFiltered ? tagColor : AppColors.textSecondary.withValues(alpha: 0.35),
            width: isFiltered ? 2.0 : 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: isFiltered
                  ? tagColor.withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isFiltered
                    ? tagColor.withValues(alpha: 0.2)
                    : const Color(0xFF64748B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                isFiltered ? _getTagIcon(_selectedTagFilter) : Icons.tag_rounded,
                size: isWide ? 18 : 16,
                color: isFiltered ? tagColor : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isFiltered ? '#$_selectedTagFilter' : 'Tüm Etiketler',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: isWide ? 14.5 : 13,
                  fontWeight: FontWeight.w700,
                  color: isFiltered ? tagColor : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isFiltered)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTagFilter = 'Tümü';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded, size: isWide ? 15 : 13, color: tagColor),
                ),
              )
            else
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: isWide ? 22 : 18,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
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

  Color _getGradeColor(String grade) {
    switch (grade) {
      case '9': return const Color(0xFF2563EB); // Kraliyet Mavisi
      case '10': return const Color(0xFF0D9488); // Teal / Zümrüt
      case '11': return const Color(0xFFEA580C); // Sıcak Turuncu
      case '12': return const Color(0xFF7C3AED); // Asil Mor
      default: return AppColors.primarySeed;
    }
  }

  // ══════════════════════════════════════════
  //  DERS REHBERİ (Tüm Derslerin Belirgin Hızlı Seçim Butonları)
  // ══════════════════════════════════════════
  Widget _buildCourseDirectory(WidgetRef ref, bool isWide) {
    final gradesToDisplay = _selectedGradeFilter == 'Tümü'
        ? ['9', '10', '11', '12']
        : [_selectedGradeFilter];

    final allNotes = ref.watch(notesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isUltraWide = screenWidth >= 1200;
    final columnCount = isUltraWide ? 3 : (isWide ? 2 : 1);

    // Etiket veya arama filtresi aktifse, herhangi bir derste eşleşen not var mı kontrol et
    final bool isTagOrSearchActive = _selectedTagFilter != 'Tümü' || _searchQuery.trim().isNotEmpty;
    if (isTagOrSearchActive) {
      final hasAnyMatch = gradesToDisplay.any((grade) {
        final allGradeCourses = ref.watch(coursesProvider(grade));
        return allGradeCourses.any((course) {
          final courseId = _normalizeCourseId(course.title, grade);
          return allNotes.any((n) {
            if (n.courseId != courseId) return false;
            if (_selectedTagFilter != 'Tümü' && n.tag != _selectedTagFilter) return false;
            if (_searchQuery.trim().isNotEmpty) {
              final q = _searchQuery.toLowerCase().trim();
              return n.title.toLowerCase().contains(q) ||
                  n.content.toLowerCase().contains(q) ||
                  (n.unitTitle != null && n.unitTitle!.toLowerCase().contains(q)) ||
                  n.tag.toLowerCase().contains(q);
            }
            return true;
          });
        });
      });

      // Hiçbir derste bu etiket/arama ile not yoksa rehberi gizle, aşağıdaki zengin _buildEmptyState açıklasın
      if (!hasAnyMatch) {
        return const SizedBox.shrink();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWide)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTagFilter != 'Tümü'
                    ? '#$_selectedTagFilter Etiketli Dersler'
                    : 'Dersler ve Not Defterleri',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _selectedTagFilter != 'Tümü'
                      ? _getTagColor(_selectedTagFilter)
                      : AppColors.textPrimary,
                ),
              ),
              Text(
                _selectedTagFilter != 'Tümü'
                    ? 'Yalnızca bu etikette not bulunan dersler'
                    : 'Derse tıklayarak birim notlarını incele',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedTagFilter != 'Tümü'
                    ? '#$_selectedTagFilter Etiketli Dersler'
                    : 'Dersler ve Not Defterleri',
                style: GoogleFonts.outfit(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w800,
                  color: _selectedTagFilter != 'Tümü'
                      ? _getTagColor(_selectedTagFilter)
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _selectedTagFilter != 'Tümü'
                    ? 'Yalnızca bu etikette not bulunan dersler'
                    : 'Derse tıklayarak birim notlarını incele',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        SizedBox(height: isWide ? 14 : 10),
        ...gradesToDisplay.map((grade) {
          final allCourses = ref.watch(coursesProvider(grade));
          if (allCourses.isEmpty) return const SizedBox.shrink();
          final gradeColor = _getGradeColor(grade);

          // Etiket veya arama varsa sadece eşleşen not barındıran dersleri filtrele
          final courses = allCourses.where((c) {
            if (!isTagOrSearchActive) return true;
            final courseId = _normalizeCourseId(c.title, grade);
            return allNotes.any((n) {
              if (n.courseId != courseId) return false;
              if (_selectedTagFilter != 'Tümü' && n.tag != _selectedTagFilter) return false;
              if (_searchQuery.trim().isNotEmpty) {
                final q = _searchQuery.toLowerCase().trim();
                return n.title.toLowerCase().contains(q) ||
                    n.content.toLowerCase().contains(q) ||
                    (n.unitTitle != null && n.unitTitle!.toLowerCase().contains(q)) ||
                    n.tag.toLowerCase().contains(q);
              }
              return true;
            });
          }).toList();

          if (courses.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sınıf Başlığı (Renkli Rozet ve Çizgiyle Belirgin)
              Padding(
                padding: EdgeInsets.only(top: isWide ? 16 : 10, bottom: isWide ? 10 : 6),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 12 : 9,
                        vertical: isWide ? 4.5 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: gradeColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: gradeColor.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded, size: isWide ? 16 : 13, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            '$grade. Sınıf',
                            style: GoogleFonts.inter(
                              fontSize: isWide ? 13 : 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Alana Ait Meslek Dersleri',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 17 : 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 1.5,
                        color: AppColors.divider.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Ders Butonları Grid'i (Ders Rengine Uyumlu Aydınlık Gradyan Arka Plan)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: isWide ? 14 : 10,
                  mainAxisSpacing: isWide ? 14 : 10,
                  mainAxisExtent: isWide ? 104 : 86,
                ),
                itemBuilder: (context, idx) {
                  final course = courses[idx];
                  final courseId = _normalizeCourseId(course.title, grade);
                  
                  // Eşleşen not sayısı hesabı
                  final matchingNotes = allNotes.where((n) {
                    if (n.courseId != courseId) return false;
                    if (_selectedTagFilter != 'Tümü' && n.tag != _selectedTagFilter) return false;
                    if (_searchQuery.trim().isNotEmpty) {
                      final q = _searchQuery.toLowerCase().trim();
                      return n.title.toLowerCase().contains(q) ||
                          n.content.toLowerCase().contains(q) ||
                          (n.unitTitle != null && n.unitTitle!.toLowerCase().contains(q)) ||
                          n.tag.toLowerCase().contains(q);
                    }
                    return true;
                  }).toList();
                  final noteCount = matchingNotes.length;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _currentGrade = grade;
                        _currentCourseId = courseId;
                        _currentCourseTitle = course.title;
                        _currentUnitIndex = null;
                        _currentUnitTitle = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(isWide ? 18 : 14),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 16 : 12,
                        vertical: isWide ? 14 : 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            gradeColor.withValues(alpha: 0.11),
                            gradeColor.withValues(alpha: 0.04),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(isWide ? 18 : 14),
                        border: Border.all(
                          color: _selectedTagFilter != 'Tümü'
                              ? _getTagColor(_selectedTagFilter).withValues(alpha: 0.5)
                              : gradeColor.withValues(alpha: 0.38),
                          width: _selectedTagFilter != 'Tümü' ? 2.0 : 1.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradeColor.withValues(alpha: 0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Sol: Belirgin İkon Kutusu
                          Container(
                            width: isWide ? 56 : 46,
                            height: isWide ? 56 : 46,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  gradeColor.withValues(alpha: 0.22),
                                  gradeColor.withValues(alpha: 0.10),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(isWide ? 14 : 10),
                              border: Border.all(
                                color: gradeColor.withValues(alpha: 0.30),
                                width: 1.2,
                              ),
                            ),
                            child: Icon(
                              course.icon,
                              size: isWide ? 28 : 22,
                              color: gradeColor,
                            ),
                          ),
                          SizedBox(width: isWide ? 14 : 10),

                          // Orta: Büyük Ders Başlığı ve Detay Bilgileri
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  course.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 16.5 : 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: isWide ? 6 : 4),
                                Row(
                                  children: [
                                    if (noteCount > 0)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 8 : 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedTagFilter != 'Tümü'
                                              ? _getTagColor(_selectedTagFilter).withValues(alpha: 0.14)
                                              : const Color(0xFFDCFCE7),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: _selectedTagFilter != 'Tümü'
                                                ? _getTagColor(_selectedTagFilter).withValues(alpha: 0.4)
                                                : const Color(0xFF86EFAC),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _selectedTagFilter != 'Tümü'
                                                  ? _getTagIcon(_selectedTagFilter)
                                                  : Icons.edit_note_rounded,
                                              size: isWide ? 14 : 12,
                                              color: _selectedTagFilter != 'Tümü'
                                                  ? _getTagColor(_selectedTagFilter)
                                                  : const Color(0xFF16A34A),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              _selectedTagFilter != 'Tümü'
                                                  ? '$noteCount Not (#$_selectedTagFilter)'
                                                  : '$noteCount Not Alındı',
                                              style: GoogleFonts.inter(
                                                fontSize: isWide ? 11.5 : 10,
                                                fontWeight: FontWeight.w700,
                                                color: _selectedTagFilter != 'Tümü'
                                                    ? _getTagColor(_selectedTagFilter)
                                                    : const Color(0xFF15803D),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isWide ? 8 : 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: gradeColor.withValues(alpha: 0.22),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.note_add_outlined,
                                              size: isWide ? 13 : 11,
                                              color: gradeColor.withValues(alpha: 0.7),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              'Henüz not yok',
                                              style: GoogleFonts.inter(
                                                fontSize: isWide ? 11 : 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(width: isWide ? 8 : 6),
                                    Text(
                                      '• ${course.learningUnits.length} Birim',
                                      style: GoogleFonts.inter(
                                        fontSize: isWide ? 11.5 : 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: isWide ? 10 : 6),

                          // Sağ: İleri Buton İkonu
                          Container(
                            width: isWide ? 34 : 26,
                            height: isWide ? 34 : 26,
                            decoration: BoxDecoration(
                              color: gradeColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: isWide ? 18 : 13,
                              color: gradeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: isWide ? 16 : 10),
            ],
          );
        }),
      ],
    );
  }

  // ══════════════════════════════════════════
  //  BOŞ DURUM (Empty State - Açıklayıcı ve Rehberlik Eden)
  // ══════════════════════════════════════════
  Widget _buildEmptyState(bool isWide, Color accentColor) {
    final bool isTagFiltered = _selectedTagFilter != 'Tümü';
    final bool isSearchActive = _searchQuery.trim().isNotEmpty;
    final bool isGenelDersNotu = _currentUnitIndex == -2;
    final bool isUnitFiltered = _currentUnitIndex != null && _currentUnitIndex! >= 0;

    final IconData emptyIcon;
    final Color iconColor;
    final String title;
    final String subtitle;
    final String actionLabel;
    final VoidCallback onAction;
    final String? secondaryActionLabel;
    final VoidCallback? onSecondaryAction;

    if (isTagFiltered) {
      emptyIcon = _getTagIcon(_selectedTagFilter);
      iconColor = _getTagColor(_selectedTagFilter);
      title = '#$_selectedTagFilter Etiketli Not Bulunamadı';

      if (isUnitFiltered) {
        subtitle = '#$_selectedTagFilter etiketiyle bir filtreleme yaptınız. Bu öğrenme biriminde #$_selectedTagFilter etiketine sahip notunuz bulunmamaktadır. Filtreleri değiştirerek diğer notlarınızı kontrol edebilir veya yeni not ekleyebilirsiniz.';
      } else if (_currentCourseTitle != null) {
        subtitle = '#$_selectedTagFilter etiketiyle bir filtreleme yaptınız. Bu derste #$_selectedTagFilter etiketine sahip notunuz bulunmamaktadır. Filtreleri değiştirerek diğer notlarınızı kontrol edebilir veya yeni not ekleyebilirsiniz.';
      } else {
        subtitle = '#$_selectedTagFilter etiketiyle bir filtreleme yaptınız. Herhangi bir sınıf veya derste #$_selectedTagFilter etiketine sahip notunuz bulunmamaktadır. Filtreleri değiştirerek diğer notlarınızı kontrol edebilir veya yeni not ekleyebilirsiniz.';
      }
      actionLabel = 'Filtreyi Temizle';
      onAction = () {
        setState(() {
          _selectedTagFilter = 'Tümü';
        });
      };
      secondaryActionLabel = 'Bu Etiketle Not Ekle';
      onSecondaryAction = () => _openNoteEditor(initialTag: _selectedTagFilter);
    } else if (isGenelDersNotu) {
      emptyIcon = Icons.push_pin_rounded;
      iconColor = accentColor;
      title = 'Henüz Genel Ders Notu Yok';
      subtitle = 'Bu derse ait öğrenme birimlerinden bağımsız genel bir ders notu henüz eklenmemiş. Ders genelinde önemli konuları ve sınav hatırlatmalarını buraya kaydedebilirsiniz.';
      actionLabel = 'Genel Ders Notu Ekle';
      onAction = () => _openNoteEditor();
      secondaryActionLabel = 'Tüm Notları Göster';
      onSecondaryAction = () {
        setState(() {
          _currentUnitIndex = null;
          _currentUnitTitle = null;
        });
      };
    } else if (isSearchActive) {
      emptyIcon = Icons.search_off_rounded;
      iconColor = AppColors.textSecondary;
      title = 'Aramayla Eşleşen Not Bulunamadı';
      subtitle = '“$_searchQuery” arama terimine uygun not bulunamadı. Arama kelimelerinizi kontrol edebilir veya filtreleri sıfırlayabilirsiniz.';
      actionLabel = 'Aramayı Temizle';
      onAction = () {
        _searchController.clear();
        setState(() => _searchQuery = '');
      };
      secondaryActionLabel = null;
      onSecondaryAction = null;
    } else {
      emptyIcon = Icons.menu_book_rounded;
      iconColor = accentColor;
      if (isUnitFiltered) {
        title = 'Bu Öğrenme Biriminde Henüz Not Yok';
        subtitle = 'Bu birimde işlenen önemli konuları, terimleri ve kişisel hatırlatmalarını Not Defterim ile kolayca kaydedebilirsin.';
      } else if (_currentCourseTitle != null) {
        title = 'Bu Derste Henüz Not Yok';
        subtitle = 'Sınavda çıkabilecek yerleri, önemli terimleri ve kişisel hatırlatmalarını Not Defterim ile kolayca kaydedebilirsin.';
      } else {
        title = 'Henüz Hiç Not Almadın';
        subtitle = 'Derslerinize ve öğrenme birimlerine ait önemli bilgileri kaydederek sınava hazırlık sürecini hızlandırabilirsin.';
      }
      actionLabel = 'İlk Notunu Ekle';
      onAction = () => _openNoteEditor();
      secondaryActionLabel = null;
      onSecondaryAction = null;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 580),
          padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 20, vertical: isWide ? 36 : 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor.withValues(alpha: 0.25), width: 1.5),
                ),
                child: Icon(emptyIcon, size: isWide ? 44 : 38, color: iconColor),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isWide ? 21 : 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isWide ? 14.5 : 13.0,
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: onAction,
                    icon: Icon(
                      isTagFiltered || isSearchActive ? Icons.filter_alt_off_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      actionLabel,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                  if (secondaryActionLabel != null && onSecondaryAction != null)
                    OutlinedButton.icon(
                      onPressed: onSecondaryAction,
                      icon: Icon(
                        isGenelDersNotu ? Icons.layers_rounded : Icons.add_rounded,
                        color: iconColor,
                        size: 18,
                      ),
                      label: Text(
                        secondaryActionLabel,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: iconColor,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: iconColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
