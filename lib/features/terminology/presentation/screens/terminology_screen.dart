import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/terminology_data.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingPath;

  void _playAudio(String assetPath) async {
    try {
      if (_currentlyPlayingPath == assetPath && _audioPlayer.playing) {
        await _audioPlayer.pause();
        setState(() {
          _currentlyPlayingPath = null;
        });
        return;
      }
      setState(() {
        _currentlyPlayingPath = assetPath;
      });
      await _audioPlayer.setAudioSource(
        AudioSource.asset(
          assetPath,
          tag: MediaItem(
            id: assetPath,
            title: 'Sözlük Terimi',
          ),
        ),
      );
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted)
            setState(() {
              _currentlyPlayingPath = null;
            });
        }
      });
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
      if (mounted)
        setState(() {
          _currentlyPlayingPath = null;
        });
    }
  }

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
    _audioPlayer.dispose();
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
            side: BorderSide(
              color: AppColors.divider.withValues(alpha: 0.6),
              width: 1.2,
            ),
          ),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          title: Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: AppColors.primaryMid,
                size: 24,
              ),
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
            child: Icon(icon, color: AppColors.primaryMid, size: 18),
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
    final filteredTerms = _filteredTerms;

    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Turizm Sözlüğü',
          style: GoogleFonts.outfit(
            fontSize: isWide ? 22 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded, size: isWide ? 28 : 24),
            tooltip: 'Sözlük Kılavuzu',
            onPressed: () => _showGuideDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Üst Arama ve Quiz Başlatma Alanı ──
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 36 : AppSizes.screenPadding,
              vertical: isWide ? 20 : AppSizes.screenPadding,
            ),
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 1650 : double.infinity),
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
                              FadePageRoute(child: const TerminologyQuizScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          child: Padding(
                            padding: EdgeInsets.all(isWide ? 20 : AppSizes.md),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isWide ? 12 : 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    color: AppColors.accent,
                                    size: isWide ? 30 : 24,
                                  ),
                                ),
                                SizedBox(width: isWide ? 18 : 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kavram Bilgini Test Et! 🎯',
                                        style: GoogleFonts.outfit(
                                          fontSize: isWide ? 21 : 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Kavram bilginizi sınayabileceğiniz beş soruluk test',
                                        style: GoogleFonts.inter(
                                          fontSize: isWide ? 15 : 12,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: isWide ? 20 : 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isWide ? 12 : AppSizes.sm),

                    // 🎡 Terim Çarkı Butonu (İnce, şık ve genel tasarımla uyumlu)
                    Container(
                      width: double.infinity,
                      height: isWide ? 50 : 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.turquoiseGradient,
                        ),
                        borderRadius: BorderRadius.circular(isWide ? AppSizes.radiusLg : AppSizes.radiusMd),
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
                          borderRadius: BorderRadius.circular(isWide ? AppSizes.radiusLg : AppSizes.radiusMd),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.explore_rounded,
                                  color: Colors.white,
                                  size: isWide ? 22 : 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Terim Çarkını Çevir 🎡',
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 16 : 13,
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
                    SizedBox(height: isWide ? 16 : AppSizes.md),

                    // 🔍 Arama Çubuğu ve Filtreleme Butonu
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Sektörel terim ara...',
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textSecondary,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        color: AppColors.textSecondary,
                                      ),
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
                        ),
                        const SizedBox(width: 12),
                        // 🎯 Açılır Filtreler Butonu
                        InkWell(
                          onTap: () => _showCategoryFilterDialog(context, isWide),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 52,
                            padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 14),
                            decoration: BoxDecoration(
                              color: _selectedCategory != 'Hepsi'
                                  ? AppColors.primaryMid
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedCategory != 'Hepsi'
                                    ? AppColors.primaryMid
                                    : AppColors.divider.withValues(alpha: 0.8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.filter_list_rounded,
                                  color: _selectedCategory != 'Hepsi'
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  size: isWide ? 22 : 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedCategory == 'Hepsi' ? 'Filtreler' : _selectedCategory,
                                  style: GoogleFonts.outfit(
                                    fontSize: isWide ? 15 : 13,
                                    fontWeight: FontWeight.w700,
                                    color: _selectedCategory != 'Hepsi'
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: _selectedCategory != 'Hepsi'
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Terimler Listesi (PC'de 2 Sütun, Mobilde Tek Sütun) ──
          Expanded(
            child: filteredTerms.isEmpty
                ? _buildEmptyState()
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 1650 : double.infinity),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 36 : AppSizes.screenPadding,
                          vertical: isWide ? 20 : AppSizes.screenPadding,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: isWide
                            ? (filteredTerms.length / 2).ceil()
                            : filteredTerms.length,
                        itemBuilder: (context, index) {
                          if (!isWide) {
                            final term = filteredTerms[index];
                            return _TermCard(
                              term: term,
                              isPlaying: _currentlyPlayingPath == term.audioPath,
                              onPlayAudio: term.audioPath != null
                                  ? () => _playAudio(term.audioPath!)
                                  : null,
                            );
                          }

                          // ── PC: Satır Başına 2 Terim Kartı ──
                          final firstIndex = index * 2;
                          final secondIndex = firstIndex + 1;
                          final term1 = filteredTerms[firstIndex];
                          final term2 = secondIndex < filteredTerms.length
                              ? filteredTerms[secondIndex]
                              : null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _TermCard(
                                    term: term1,
                                    isPlaying: _currentlyPlayingPath == term1.audioPath,
                                    onPlayAudio: term1.audioPath != null
                                        ? () => _playAudio(term1.audioPath!)
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: term2 != null
                                      ? _TermCard(
                                          term: term2,
                                          isPlaying: _currentlyPlayingPath == term2.audioPath,
                                          onPlayAudio: term2.audioPath != null
                                              ? () => _playAudio(term2.audioPath!)
                                              : null,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Şık Açılır Kategori Filtresi Penceresi ──
  void _showCategoryFilterDialog(BuildContext context, bool isWide) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isWide ? 28 : 20),
                side: BorderSide(color: AppColors.divider.withValues(alpha: 0.6), width: 1.2),
              ),
              titlePadding: EdgeInsets.fromLTRB(isWide ? 28 : 20, isWide ? 24 : 18, isWide ? 28 : 20, 12),
              contentPadding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 20),
              actionsPadding: EdgeInsets.fromLTRB(isWide ? 28 : 20, 12, isWide ? 28 : 20, isWide ? 20 : 16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMid.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.tune_rounded, color: AppColors.primaryMid, size: isWide ? 24 : 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Kategoriye Göre Filtrele',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: isWide ? 520 : 340,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      final count = cat == 'Hepsi'
                          ? _dictionary.length
                          : _dictionary.where((t) => t.category == cat).length;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            setDialogState(() {});
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: isWide ? 18 : 14, vertical: isWide ? 14 : 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryMid.withValues(alpha: 0.08) : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryMid : AppColors.divider.withValues(alpha: 0.6),
                                width: isSelected ? 1.8 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  color: isSelected ? AppColors.primaryMid : AppColors.textHint,
                                  size: isWide ? 22 : 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    cat,
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 16.5 : 13.5,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? AppColors.primaryMid : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primaryMid.withValues(alpha: 0.15) : AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$count',
                                    style: GoogleFonts.inter(
                                      fontSize: isWide ? 13 : 11,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? AppColors.primaryMid : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  height: isWide ? 50 : 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMid,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Tamam',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 17 : 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textHint,
          ),
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
  final bool isPlaying;
  final VoidCallback? onPlayAudio;

  const _TermCard({
    required this.term,
    this.isPlaying = false,
    this.onPlayAudio,
  });

  @override
  State<_TermCard> createState() => _TermCardState();
}

class _TermCardState extends State<_TermCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: isWide ? 16 : AppSizes.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isWide ? AppSizes.radiusXl : AppSizes.radiusLg),
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
            borderRadius: BorderRadius.circular(isWide ? AppSizes.radiusXl : AppSizes.radiusLg),
            child: Padding(
              padding: EdgeInsets.all(isWide ? 20 : AppSizes.md),
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
                            fontSize: isWide ? 24.0 : 17.5,
                            fontWeight: FontWeight.w800,
                            color: _isExpanded
                                ? AppColors.primaryMid
                                : const Color(0xFF0F172A),
                            letterSpacing: 0.25,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (widget.term.audioPath != null) ...[
                        IconButton(
                          onPressed: widget.onPlayAudio,
                          icon: Icon(
                            widget.isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.volume_up_rounded,
                            color: widget.isPlaying
                                ? AppColors.primaryMid
                                : AppColors.primaryBright,
                            size: isWide ? 30 : 26,
                          ),
                          tooltip: 'Sesli Dinle',
                          splashRadius: 24,
                        ),
                        const SizedBox(width: 4),
                      ],
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _isExpanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: _isExpanded
                              ? AppColors.primaryMid
                              : AppColors.textSecondary,
                          size: isWide ? 26 : 22,
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
                                SizedBox(height: isWide ? 16 : 12),
                                const Divider(
                                  height: 1,
                                  color: AppColors.divider,
                                ),
                                SizedBox(height: isWide ? 16 : 12),
                                Text(
                                  widget.term.definition,
                                  style: GoogleFonts.inter(
                                    fontSize: isWide ? 19.0 : 14.5,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                if (widget.term.example.isNotEmpty) ...[
                                  SizedBox(height: isWide ? 14 : 10),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(isWide ? 14 : 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(isWide ? 12 : 10),
                                      border: Border.all(
                                        color: AppColors.divider,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.school_rounded,
                                              color: AppColors.primaryBright,
                                              size: isWide ? 20 : 16,
                                            ),
                                            SizedBox(width: isWide ? 8 : 6),
                                            Text(
                                              'Örnekle Pekiştirelim:',
                                              style: GoogleFonts.outfit(
                                                fontSize: isWide ? 16.0 : 11.5,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.primaryBright,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isWide ? 6 : 4),
                                        Text(
                                          '"${widget.term.example}"',
                                          style: GoogleFonts.inter(
                                            fontSize: isWide ? 17.5 : 12.5,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.textPrimary,
                                            height: 1.45,
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
