import 'dart:io';
import 'dart:convert';
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
    final dialogWidth = math.min(size.width * 0.92, 390.0);
    final dialogHeight = math.min(size.height * 0.80, 565.0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ── Üst Başlık ve Kapatma Butonu ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.explore_rounded, // Casino yerine Keşif/Pusula ikonu
                      color: AppColors.primaryMid,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Terim Çarkı',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const Divider(color: AppColors.divider, height: 16),

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
                        child: const CustomPaint(
                          size: Size(200, 200),
                          painter: _WheelPainter(
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
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                            ),
                          ],
                          border: Border.all(color: AppColors.primaryMid, width: 3),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: AppColors.primaryMid,
                          ),
                        ),
                      ),
                      
                      // Çark Pointerı (Üstte Sabit Duran Ok)
                      Positioned(
                        top: 0,
                        child: CustomPaint(
                          size: const Size(24, 20),
                          painter: _PointerPainter(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                      child: _buildStateWidget(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── Aksiyon Butonu ──
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _state == 'spinning' ? null : _spinWheel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMid,
                  disabledBackgroundColor: AppColors.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
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
                    fontSize: 14,
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

  Widget _buildStateWidget() {
    if (_state == 'idle') {
      return Container(
        key: const ValueKey('idle_state'),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rastgele Bir Terim Keşfet!',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Çarkı çevirerek sözlükten rastgele bir turizm terimini detaylarıyla öğrenebilirsiniz.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
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
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Çark dönüyor, yeni bir bilgi yolda...',
              style: GoogleFonts.inter(
                fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryMid,
                ),
              ),
              const SizedBox(height: 4),
              
              // Tanım
              Text(
                term.definition,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              
              // Örnek Cümle (Varsa)
              if (term.example.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.school_rounded, color: AppColors.primaryBright, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Örnekle Pekiştirelim:',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBright,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '"${term.example}"',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textSecondary,
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

      final textPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.3,
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
