import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/podcast_service.dart';

class PodcastSpeedControl extends StatefulWidget {
  final Color accentColor;
  final bool opensUpward;
  final VoidCallback? onTapOverride;
  final GlobalKey? targetAlignKey;

  const PodcastSpeedControl({
    super.key,
    this.accentColor = Colors.cyanAccent,
    this.opensUpward = false,
    this.onTapOverride,
    this.targetAlignKey,
  });

  @override
  State<PodcastSpeedControl> createState() => _PodcastSpeedControlState();
}

class _PodcastSpeedControlState extends State<PodcastSpeedControl> {
  double _currentSpeed = 1.0;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final GlobalKey<PodcastSpeedSheetState> _sheetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentSpeed = PodcastService().playbackSpeed;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _setSpeed(double speed) {
    setState(() {
      _currentSpeed = speed;
    });
    PodcastService().setPlaybackSpeed(speed);
  }

  String _speedLabel(double speed) {
    if (speed == speed.roundToDouble() && speed < 10) {
      return '${speed.toInt()}x';
    }
    return '${speed.toStringAsFixed(2)}x';
  }

  void _removeOverlay() {
    if (_overlayEntry == null) return;
    
    final sheetState = _sheetKey.currentState;
    if (sheetState != null) {
      sheetState.animateClose().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    // Varsayılan hizalama kutusu butonun kendisidir
    RenderBox? alignBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    
    // Eğer dışarıdan bir hedef hizalama anahtarı verilmişse onu kullan
    if (widget.targetAlignKey != null && widget.targetAlignKey!.currentContext != null) {
      alignBox = widget.targetAlignKey!.currentContext!.findRenderObject() as RenderBox?;
    }

    if (alignBox == null) return;

    final alignPosition = alignBox.localToGlobal(Offset.zero);
    final alignSize = alignBox.size;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Hız panelinin genişliği: Referans alınan alanın genişliğinin tam %90'ı!
    // Hem sağdan hem soldan eşit (%5'er) boşluk kalacak şekilde ortalanır.
    double popupWidth = alignSize.width * 0.9;
    if (popupWidth < 220) popupWidth = 220;
    if (popupWidth > screenWidth - 32) popupWidth = screenWidth - 32;

    // Yatayda referans alınan alanın merkezine ortala
    double left = alignPosition.dx + (alignSize.width / 2) - (popupWidth / 2);
    if (left < 16) left = 16;
    if (left + popupWidth > screenWidth - 16) left = screenWidth - popupWidth - 16;

    // Dikeyde tam referans alınan alanın bitiş sınırından başlasın (4px milimetrik boşlukla)
    bool opensUp;
    const popupHeight = 76; // Yükseklik %10 azaltılarak 76px'e düşürüldü
    double top;
    if (widget.opensUpward) {
      top = alignPosition.dy - popupHeight - 4;
      opensUp = true;
    } else {
      top = alignPosition.dy + alignSize.height + 4;
      opensUp = false;
      if (top + popupHeight > mediaQuery.size.height - mediaQuery.padding.bottom - 16) {
        top = alignPosition.dy - popupHeight - 4;
        opensUp = true;
      }
    }

    _overlayEntry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Arka plan tıklamasıyla kapat
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Hız paneli
          Positioned(
            left: left,
            top: top,
            child: Material(
              color: Colors.transparent,
              child: PodcastSpeedSheet(
                key: _sheetKey,
                width: popupWidth,
                currentSpeed: _currentSpeed,
                accentColor: widget.accentColor,
                onSpeedChanged: _setSpeed,
                onClose: _removeOverlay,
                opensUp: opensUp,
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: widget.onTapOverride ?? _toggleOverlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: widget.accentColor.withOpacity(0.07),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: widget.accentColor.withOpacity(0.26),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.speed_rounded,
              size: 14,
              color: widget.accentColor,
            ),
            const SizedBox(width: 5),
            Text(
              _speedLabel(_currentSpeed),
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.95),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  COMPACT SPEED SHEET — Dropdown Style
// ═══════════════════════════════════════════

class PodcastSpeedSheet extends StatefulWidget {
  final double width;
  final double currentSpeed;
  final Color accentColor;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onClose;
  final bool opensUp;

  const PodcastSpeedSheet({
    super.key,
    required this.width,
    required this.currentSpeed,
    required this.accentColor,
    required this.onSpeedChanged,
    required this.onClose,
    this.opensUp = false,
  });

  @override
  State<PodcastSpeedSheet> createState() => PodcastSpeedSheetState();
}

class PodcastSpeedSheetState extends State<PodcastSpeedSheet> with SingleTickerProviderStateMixin {
  late double _speed;
  final List<double> _presets = [1.0, 1.25, 1.50, 1.75, 2.0];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _speed = widget.currentSpeed;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> animateClose() async {
    await _animationController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInQuad,
    );
  }

  String _speedLabel(double speed) {
    if (speed == speed.roundToDouble() && speed < 10) {
      return '${speed.toInt()}x';
    }
    return '${speed.toStringAsFixed(2)}x';
  }

  @override
  Widget build(BuildContext context) {
    const double buttonWidth = 36; // Buton genişliği biraz daha daraltıldı

    bool isPresetSelected(double preset) {
      return (_speed - preset).abs() < 0.01;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: widget.opensUp ? Alignment.bottomCenter : Alignment.topCenter,
        child: Container(
          width: widget.width,
          height: 76, // Yükseklik %10 kısaltılarak 76px yapıldı
          decoration: BoxDecoration(
            // Dark-Neon standartlarında 0.65 şeffaflığında premium glassmorphic cam paneli
            color: const Color(0xFF0A192F).withOpacity(0.65),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: kIsWeb ? 0 : 12, sigmaY: kIsWeb ? 0 : 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), // Dikey padding azaltıldı
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Satır: Preset Butonları
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _presets.map((preset) {
                        final isSelected = isPresetSelected(preset);
                        return GestureDetector(
                          onTap: () {
                            setState(() => _speed = preset);
                            widget.onSpeedChanged(preset);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: buttonWidth,
                            height: 22, // Buton yüksekliği 22px'e düşürüldü
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.accentColor.withOpacity(0.18)
                                  : Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? widget.accentColor.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.06),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _speedLabel(preset),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: isSelected
                                    ? widget.accentColor
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 2), // Boşluk azaltıldı

                    // 2. Satır: 20 Bölmeli (0.05 adımlı) Geometrik Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: buttonWidth / 2),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: widget.accentColor,
                          inactiveTrackColor: Colors.white10,
                          trackHeight: 1.8, // Track kalınlığı azaltıldı
                          thumbColor: widget.accentColor,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 4.5, // Thumb küçültüldü
                          ),
                          overlayColor: widget.accentColor.withOpacity(0.08),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 8.0,
                          ),
                          tickMarkShape: const RoundSliderTickMarkShape(
                            tickMarkRadius: 1.0, // Noktalar küçültüldü
                          ),
                          activeTickMarkColor: widget.accentColor.withOpacity(0.25),
                          inactiveTickMarkColor: Colors.white10,
                        ),
                        child: Slider(
                          min: 1.0,
                          max: 2.0,
                          divisions: 20,
                          value: _speed,
                          onChanged: (value) {
                            final steppedValue = (value * 20).roundToDouble() / 20;
                            setState(() => _speed = steppedValue);
                            widget.onSpeedChanged(steppedValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
