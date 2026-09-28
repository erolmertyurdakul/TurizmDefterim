import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/data/terminology_data.dart';
import '../../../../core/providers/sound_provider.dart';
import '../../../../core/utils/sfx_synthesizer.dart';
import '../../../badges/providers/badge_provider.dart';

class SpinWheelDialog extends ConsumerStatefulWidget {
  const SpinWheelDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const SpinWheelDialog(),
    );
  }

  @override
  ConsumerState<SpinWheelDialog> createState() => _SpinWheelDialogState();
}

class _SpinWheelDialogState extends ConsumerState<SpinWheelDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  
  // Çark durumu: 'idle' (başlangıç), 'spinning' (dönüyor), 'result' (durdu, sonuç gösteriliyor)
  String _state = 'idle';
  Term? _selectedTerm;
  double _currentRotation = 0.0;

  // ── Ses Sistemi (Tek Seferlik Tınlama Mimarisi) ──
  // Kullanıcının kasmadan çalışan kesin çözüm isteği üzerine:
  // Her dilimde değil, çark dönmeye başlarken tek bir büyülü uzun ses çalar.
  final AudioPlayer _spinPlayer = AudioPlayer();
  final AudioPlayer _resultPlayer = AudioPlayer();
  
  late final Uint8List _spinBytes;
  late final Uint8List _resultBytes;
  bool _isAudioReady = false;
  bool _isDisposed = false;

  // Çark dilimlerindeki eğitim kelimeleri (T.C. ahlaki ve eğitim değerlerine uygun, turizm odaklı)
  static const List<String> _wheelWords = [
    'Konaklama',
    'Seyahat',
    'Rehberlik',
    'Coğrafya',
    'Gastronomi',
    'Etkinlik',
    'Dijital',
    'Kültür',
  ];

  // Okyanus temasıyla uyumlu 8 dilim rengi
  static const List<Color> _sliceColors = [
    Color(0xFF0A2647), // Derin Okyanus Koyu
    Color(0xFF0E918C), // Turkuaz
    Color(0xFFE8AA42), // Kumsal Altını
    Color(0xFF205295), // Okyanus Mavisi
    Color(0xFFE07A3A), // Mercan Sıcak
    Color(0xFF144272), // Koyu Mavi
    Color(0xFF17B5B0), // Açık Turkuaz
    Color(0xFF2C74B3), // Parlak Mavi
  ];

  @override
  void initState() {
    super.initState();
    
    // Sesleri önceden sentezle
    _spinBytes = SfxSynthesizer.getWheelSpinResonance();
    _resultBytes = SfxSynthesizer.getWheelResult();

    _initAudio();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _playResultSound();
        });
        // Terim Çarkı Ustası rozet sayacını artır
        ref.read(badgeProgressProvider.notifier).incrementWheelSpins();
        setState(() {
          _state = 'result';
          _currentRotation = _animation.value;
        });
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      await _spinPlayer.setVolume(0.5);
      await _resultPlayer.setVolume(0.7);

      if (kIsWeb) {
        await _spinPlayer.setReleaseMode(ReleaseMode.stop);
        await _resultPlayer.setReleaseMode(ReleaseMode.stop);
        if (mounted) setState(() { _isAudioReady = true; });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final spinFilePath = '${tempDir.path}/wheel_spin_resonance.wav';
      final resultFilePath = '${tempDir.path}/wheel_result_opt.wav';

      final sFile = File(spinFilePath);
      final rFile = File(resultFilePath);

      await sFile.writeAsBytes(_spinBytes, flush: true);
      await rFile.writeAsBytes(_resultBytes, flush: true);

      if (_isDisposed) return;
      
      await _spinPlayer.setReleaseMode(ReleaseMode.stop);
      await _resultPlayer.setReleaseMode(ReleaseMode.stop);

      await _spinPlayer.setSourceDeviceFile(spinFilePath);
      await _resultPlayer.setSourceDeviceFile(resultFilePath);
      
      if (mounted) setState(() { _isAudioReady = true; });
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  void _playSpinSound() async {
    if (_isDisposed || !_isAudioReady) return;
    if (!ref.read(soundSettingsProvider)) return;
    try {
      if (kIsWeb) {
        await _spinPlayer.stop();
        await _spinPlayer.play(BytesSource(_spinBytes, mimeType: 'audio/wav'), volume: 0.5);
        return;
      }
      await _spinPlayer.stop();
      await _spinPlayer.seek(Duration.zero);
      if (_isDisposed) return;
      await _spinPlayer.resume();
    } catch (e) {
      debugPrint('Play spin error: $e');
    }
  }

  void _playResultSound() async {
    if (_isDisposed || !_isAudioReady) return;
    if (!ref.read(soundSettingsProvider)) return;
    try {
      if (kIsWeb) {
        await _resultPlayer.stop();
        await _resultPlayer.play(BytesSource(_resultBytes, mimeType: 'audio/wav'), volume: 0.7);
        return;
      }
      await _resultPlayer.stop();
      await _resultPlayer.seek(Duration.zero);
      if (_isDisposed) return;
      await _resultPlayer.resume();
    } catch (e) {
      debugPrint('Play result error: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    try {
      _spinPlayer.dispose();
      _resultPlayer.dispose();
    } catch (_) {}
    super.dispose();
  }

  int _getCategoryIndex(String category) {
    switch (category) {
      case 'Konaklama ve Misafirperverlik Hizmetleri':
        return 0;
      case 'Seyahat Acenteciliği ve Ulaştırma':
        return 1;
      case 'Tur Operatörlüğü ve Rehberlik':
        return 2;
      case 'Turizm Coğrafyası ve Çevre':
        return 3;
      case 'Gastronomi ve Yiyecek-İçecek':
        return 4;
      case 'Kongre ve Etkinlik Yönetimi':
        return 5;
      case 'Dijital Turizm ve Sosyal Medya':
        return 6;
      case 'Kültür Mirası ve Rekreasyon':
        return 7;
      default:
        return 0;
    }
  }

  void _spinWheel() async {
    if (_state == 'spinning') return;

    final random = math.Random();
    
    // Sözlükten rastgele bir terim seç
    if (terminologyData.isNotEmpty) {
      _selectedTerm = terminologyData[random.nextInt(terminologyData.length)];
    }

    if (_selectedTerm == null) return;

    // Seçilen terimin kategorisine göre hangi dilimde duracağını hesapla
    final int targetIndex = _getCategoryIndex(_selectedTerm!.category);
    final int count = _wheelWords.length;
    final double sweepAngle = 2 * math.pi / count;
    
    // Çarkın dilimi pointer (12 yönü) altına gelsin
    final double baseTarget = - (targetIndex * sweepAngle + sweepAngle / 2);
    final double extraSpins = (5 + random.nextInt(4)) * 2 * math.pi;
    
    // Mevcut rotasyonun üzerine en az 5 tam tur ekle ve hedef dilim açısına hizala
    final double currentMod = _currentRotation % (2 * math.pi);
    double angleDiff = baseTarget - currentMod;
    if (angleDiff <= 0) {
      angleDiff += 2 * math.pi;
    }
    final double targetRotation = _currentRotation + extraSpins + angleDiff;

    _playSpinSound();

    setState(() {
      _state = 'spinning';
      _animation = Tween<double>(
        begin: _currentRotation,
        end: targetRotation,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 768;
    final dialogWidth = isWide ? 760.0 : math.min(size.width * 0.94, 440.0);
    final dialogHeight = isWide ? 790.0 : math.min(size.height * 0.88, 620.0);
    final wheelSize = isWide ? 300.0 : 220.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWide ? 28 : AppSizes.radiusXl),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: EdgeInsets.all(isWide ? 26.0 : 16.0),
        child: Column(
          children: [
            // ── Üst Başlık ve Kapatma Butonu ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.explore_rounded,
                      color: AppColors.primaryMid,
                      size: isWide ? 32 : 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Terim Çarkı',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 26 : 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: AppColors.textSecondary, size: isWide ? 28 : 22),
                  splashRadius: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            Divider(color: AppColors.divider, height: isWide ? 22 : 16),

            // ── Çark Alanı (Çark + Pointer) ──
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Çarkın Kendisi (GPU Ön Belleklenmiş 60 FPS Akıcı Mimarisi)
                      AnimatedBuilder(
                        animation: _animation,
                        child: CustomPaint(
                          size: Size(wheelSize, wheelSize),
                          painter: const _WheelPainter(
                            words: _wheelWords,
                            colors: _sliceColors,
                          ),
                        ),
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value,
                            child: child,
                          );
                        },
                      ),
                      
                      // Çarkın Göbeği (Merkez Daire)
                      Container(
                        width: isWide ? 50 : 36,
                        height: isWide ? 50 : 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                            ),
                          ],
                          border: Border.all(color: AppColors.primaryMid, width: isWide ? 3.5 : 3),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: isWide ? 22 : 14,
                            color: AppColors.primaryMid,
                          ),
                        ),
                      ),
                      
                      // Çark Pointerı (Üstte Sabit Duran Ok)
                      Positioned(
                        top: 0,
                        child: CustomPaint(
                          size: Size(isWide ? 32 : 24, isWide ? 28 : 20),
                          painter: _PointerPainter(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isWide ? 20 : 16),

                  // ── Sonuç Alanı / Durum Bilgisi ──
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _buildStateWidget(isWide),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Aksiyon Butonu ──
            SizedBox(
              width: double.infinity,
              height: isWide ? 58 : 48,
              child: ElevatedButton(
                onPressed: _state == 'spinning' ? null : _spinWheel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMid,
                  disabledBackgroundColor: AppColors.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isWide ? 16 : AppSizes.radiusMd),
                  ),
                ),
                child: Text(
                  _state == 'spinning'
                      ? 'Çark Dönüyor...'
                      : _state == 'result'
                          ? 'Tekrar Çevir 🔄'
                          : 'Çarkı Çevir! 🎯',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: isWide ? 19 : 14.5,
                    color: _state == 'spinning' ? AppColors.textHint : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateWidget(bool isWide) {
    if (_state == 'idle') {
      return Container(
        key: const ValueKey('idle_state'),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rastgele Bir Kavram Keşfet!',
              style: GoogleFonts.outfit(
                fontSize: isWide ? 23 : 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Çarkı çevirerek sözlükten rastgele bir turizm kavramını detaylarıyla öğrenebilirsiniz.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: isWide ? 17 : 12.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      );
    } else if (_state == 'spinning') {
      return Container(
        key: const ValueKey('spinning_state'),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isWide ? 36 : 24,
              height: isWide ? 36 : 24,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: isWide ? 16 : 12),
            Text(
              'Çark dönüyor, yeni bir bilgi yolda...',
              style: GoogleFonts.inter(
                fontSize: isWide ? 17 : 12.5,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    } else {
      // Result State
      final term = _selectedTerm;
      if (term == null) return const SizedBox.shrink();

      return Container(
        key: const ValueKey('result_state'),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12, vertical: isWide ? 16 : 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(isWide ? 20 : AppSizes.radiusLg),
          border: Border.all(color: AppColors.divider),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terim İsmi ve Kategorisi
              Text(
                term.word,
                style: GoogleFonts.outfit(
                  fontSize: isWide ? 26 : 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryMid,
                ),
              ),
              SizedBox(height: isWide ? 6 : 4),
              
              // Tanım
              Text(
                term.definition,
                style: GoogleFonts.inter(
                  fontSize: isWide ? 18.5 : 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              
              // Örnek Cümle (Varsa)
              if (term.example.isNotEmpty) ...[
                SizedBox(height: isWide ? 12 : 6),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 16 : 10, vertical: isWide ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isWide ? 12 : 8),
                    border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.school_rounded, color: AppColors.primaryBright, size: isWide ? 20 : 13),
                          const SizedBox(width: 6),
                          Text(
                            'Örnekle Pekiştirelim:',
                            style: GoogleFonts.outfit(
                              fontSize: isWide ? 16 : 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBright,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"${term.example}"',
                        style: GoogleFonts.inter(
                          fontSize: isWide ? 17 : 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }
}

// ── CustomPainter: Çark Çizimi ──
class _WheelPainter extends CustomPainter {
  final List<String> words;
  final List<Color> colors;

  const _WheelPainter({required this.words, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final int count = words.length;
    final double sweepAngle = 2 * math.pi / count;

    // Dış Halka Çerçeve Çizimi
    final Paint borderPaint = Paint()
      ..color = AppColors.primaryMid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final double startAngle = i * sweepAngle - math.pi / 2;
      
      // Dilim Boyama
      fillPaint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        fillPaint,
      );

      // Dilimin Üzerine Metin Ekleme
      canvas.save();
      
      // Metin Açısı
      final double textAngle = startAngle + sweepAngle / 2;
      canvas.translate(center.dx, center.dy);
      canvas.rotate(textAngle);

      final double calculatedFontSize = (radius * 0.098).clamp(13.0, 18.0);

      final textPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: calculatedFontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      
      // Metni dış çerçeve (radius - 12) ile iç göbek (18) arasındaki alana ortala
      final double innerRadius = 18.0;
      final double outerRadius = radius - 12.0;
      final double midRadius = (innerRadius + outerRadius) / 2;
      final double textStartOffset = midRadius - (textPainter.width / 2);
      
      canvas.translate(textStartOffset, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }

    // Dış Çerçeve Çizimi
    canvas.drawCircle(center, radius, borderPaint);
    
    // Küçük Dış Halka Detay Çizgisi
    final Paint innerBorderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 6, innerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── CustomPainter: Pointer (Üçgen Ok) Çizimi ──
class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentWarm
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    // Gölge Ekleme
    canvas.drawPath(
      path.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
