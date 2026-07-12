import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/data/terminology_data.dart';
import '../../../badges/providers/badge_provider.dart';
import 'spin_wheel_dialog.dart';
import 'terminology_quiz_screen.dart';
import '../../../../core/utils/fade_page_route.dart';

// ══════════════════════════════════════════


// ══════════════════════════════════════════
//  1. VERİ MODELİ (TERM CLASS)
// ══════════════════════════════════════════
// Term sınıfı ve veriler core/data/terminology_data.dart dosyasına taşınmıştır.

// ══════════════════════════════════════════
//  2. DEV SÖZLÜK VERİ TABANI
// ══════════════════════════════════════════
final _dictionary = terminologyData;

// ══════════════════════════════════════════
//  3. ANA SÖZLÜK EKRANI (TERMINOLOGY SCREEN)
// ══════════════════════════════════════════
class TerminologyScreen extends ConsumerStatefulWidget {
  const TerminologyScreen({super.key});

  @override
  ConsumerState<TerminologyScreen> createState() => _TerminologyScreenState();
}

class _TerminologyScreenState extends ConsumerState<TerminologyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Hepsi';
  Timer? _debounceTimer;
  late final List<String> _categories;

  // Filtre önbelleği — searchQuery veya category değişmedikçe yeniden hesaplanmaz
  String _cachedQuery = '';
  String _cachedCategory = '';
  List<Term> _cachedFiltered = const [];

  List<Term> get _filteredTerms {
    if (_searchQuery == _cachedQuery && _selectedCategory == _cachedCategory) {
      return _cachedFiltered;
    }
    _cachedQuery = _searchQuery;
    _cachedCategory = _selectedCategory;
    final lowercaseQuery = _searchQuery.trim().toLowerCase();
    _cachedFiltered = _dictionary.where((term) {
      if (_selectedCategory != 'Hepsi' && term.category != _selectedCategory) {
        return false;
      }
      if (lowercaseQuery.isEmpty) return true;
      return term.word.toLowerCase().contains(lowercaseQuery);
    }).toList();
    return _cachedFiltered;
  }

  @override
  void initState() {
    super.initState();
    _categories = ['Hepsi', ..._dictionary.map((t) => t.category).toSet()];
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            side: BorderSide(color: AppColors.divider.withValues(alpha: 0.6), width: 1.2),
          ),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          title: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: AppColors.primaryMid, size: 24),
              const SizedBox(width: 10),
              Text(
                'Sözlük Kılavuzu',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Erol Hoca'nın meslek kitaplarınızdaki kelimelerden seçerek oluşturduğu 1000'e yakın tanım ve örnek, lise döneminiz boyunca karşılaşabileceğiniz çoğu terimi kapsamaktadır.",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Terimler sözlüğünde yapabilecekleriniz şunlardır:',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryMid,
                  ),
                ),
                const SizedBox(height: 10),
                _buildGuideItem(
                  Icons.library_books_rounded,
                  'Terimleri sayfayı kaydırarak inceleyebilir ve okumak istediğiniz terime tıklayarak ilgili terimin açıklamasını ve örneğini okuyabilirsiniz.',
                ),
                _buildGuideItem(
                  Icons.search_rounded,
                  'İstediğiniz terimi arama kutucuğuna yazarak bulabilirsiniz.',
                ),
                _buildGuideItem(
                  Icons.task_alt_rounded,
                  'Terim bilginizi test eden 5 soruluk testleri çözebilirsiniz.',
                ),
                _buildGuideItem(
                  Icons.explore_rounded,
                  'Terim çarkını çevirerek rastgele kategoriden karşınıza gelecek bir terimi öğrenebilirsiniz (terim çarkını arkadaşlarınızla birlikte kullanarak oyunlaştırabilir ve daha eğlenceli hale getirebilirsiniz).',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Anladım',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: AppColors.primaryMid,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuideItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryMid.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryMid,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final filteredTerms = _filteredTerms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turizm Terimler Sözlüğü'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Sözlük Kılavuzu',
            onPressed: () => _showGuideDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Üst Arama ve Quiz Başlatma Alanı ──
          Container(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.radiusXl),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primarySeed.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // 🎯 Kendini Test Et Gradient Kartı
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.oceanGradient,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primarySeed.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          FadePageRoute(
                            child: const TerminologyQuizScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.md),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Terim Bilgini Test Et! 🎯',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Erol Hoca\'nın ipuçlarıyla 5 soruluk hızlı test',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),

                // 🎡 Terim Çarkı Butonu (İnce, şık ve genel tasarımla uyumlu)
                Container(
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.turquoiseGradient,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => SpinWheelDialog.show(context),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.explore_rounded, // Eğitim ve ahlaki değerlere uygun Keşif/Çark ikonu
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Terim Çarkını Çevir 🎡',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                // 🔍 Arama Çubuğu
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Sektörel terim ara...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),

          // ── Kategori Filtreleme Çipleri ──
          const SizedBox(height: AppSizes.sm),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSel = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                    selectedColor: AppColors.primaryMid,
                    backgroundColor: AppColors.surfaceVariant,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSel ? Colors.white : AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),

          // ── Terimler Listesi ──
          Expanded(
            child: filteredTerms.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredTerms.length,
                    itemBuilder: (context, index) {
                      final term = filteredTerms[index];
                      return _TermCard(
                        term: term,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            'Aradığınız terim bulunamadı.',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lütfen yazımı kontrol edip tekrar deneyin.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermCard extends StatefulWidget {
  final Term term;

  const _TermCard({
    required this.term,
  });

  @override
  State<_TermCard> createState() => _TermCardState();
}

class _TermCardState extends State<_TermCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: _isExpanded
                ? AppColors.primaryMid.withOpacity(0.5)
                : AppColors.divider.withValues(alpha: 0.6),
            width: _isExpanded ? 1.5 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isExpanded
                  ? AppColors.primaryMid.withOpacity(0.06)
                  : AppColors.primarySeed.withValues(alpha: 0.03),
              blurRadius: _isExpanded ? 14 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.term.word,
                          style: GoogleFonts.outfit(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w800,
                            color: _isExpanded ? AppColors.primaryMid : const Color(0xFF0F172A),
                            letterSpacing: 0.25,
                            height: 1.2,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _isExpanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: _isExpanded ? AppColors.primaryMid : AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  ClipRect(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: _isExpanded
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                const Divider(height: 1, color: AppColors.divider),
                                const SizedBox(height: 12),
                                Text(
                                  widget.term.definition,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                ),
                                if (widget.term.example.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.divider),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.school_rounded, color: AppColors.primaryBright, size: 16),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Örnekle Pekiştirelim:',
                                              style: GoogleFonts.outfit(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.primaryBright,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '"${widget.term.example}"',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
