import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/podcast_service.dart';

class PodcastSpeedControl extends StatefulWidget {
  final Color accentColor;
  final bool opensUpward;

  const PodcastSpeedControl({
    super.key,
    this.accentColor = Colors.cyanAccent,
    this.opensUpward = false,
  });

  @override
  State<PodcastSpeedControl> createState() => _PodcastSpeedControlState();
}

class _PodcastSpeedControlState extends State<PodcastSpeedControl> {
  double _currentSpeed = 1.0;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

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
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Popup genişliği: ekrana sığacak şekilde, max 320
    double popupWidth = screenWidth - 32;
    if (popupWidth > 320) popupWidth = 320;

    // Popup'ın sağ kenarı ekranı aşmasın
    double left = buttonPosition.dx + buttonSize.width - popupWidth;
    if (left < 16) left = 16;
    if (left + popupWidth > screenWidth - 16) left = screenWidth - popupWidth - 16;

    // Popup pozisyonu: opensUpward ise butonun hemen üzerine, değilse butonun altına
    bool opensUp;
    const popupEstimatedHeight = 130;
    double top;
    if (widget.opensUpward) {
      top = buttonPosition.dy - popupEstimatedHeight - 8;
      opensUp = true;
    } else {
      top = buttonPosition.dy + buttonSize.height + 8;
      opensUp = false;
      if (top + popupEstimatedHeight > mediaQuery.size.height - mediaQuery.padding.bottom - 16) {
        top = buttonPosition.dy - popupEstimatedHeight - 8;
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
              child: _SpeedSheet(
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
      onTap: _toggleOverlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
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
                fontWeight: FontWeight.w700,
                color: Colors.white,
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

class _SpeedSheet extends StatefulWidget {
  final double currentSpeed;
  final Color accentColor;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onClose;
  final bool opensUp;

  const _SpeedSheet({
    required this.currentSpeed,
    required this.accentColor,
    required this.onSpeedChanged,
    required this.onClose,
    this.opensUp = false,
  });

  @override
  State<_SpeedSheet> createState() => _SpeedSheetState();
}

class _SpeedSheetState extends State<_SpeedSheet> {
  late double _speed;
  final List<double> _presets = [1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _speed = widget.currentSpeed;
  }

  String _speedLabel(double speed) {
    if (speed == speed.roundToDouble() && speed < 10) {
      return '${speed.toInt()}x';
    }
    return '${speed.toStringAsFixed(2)}x';
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (_, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: 0.92 + (opacity * 0.08),
            alignment: widget.opensUp
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: const Color(0xFF0A192F).withOpacity(0.95),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Üst satır: Preset'ler + Hız göstergesi
                  Row(
                    children: [
                      // Preset butonları
                      ..._presets.map((preset) {
                        final isSelected = (_speed - preset).abs() < 0.01;
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _speed = preset);
                              widget.onSpeedChanged(preset);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? widget.accentColor.withOpacity(0.18)
                                    : Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(8),
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
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? widget.accentColor
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const Spacer(),

                      // Hız göstergesi
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _speedLabel(_speed),
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: widget.accentColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Slider satırı
                  Row(
                    children: [
                      Text(
                        '1.0',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.white24,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: widget.accentColor,
                            inactiveTrackColor: Colors.white10,
                            trackHeight: 2.5,
                            thumbColor: widget.accentColor,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5.5,
                            ),
                            overlayColor: widget.accentColor.withOpacity(0.08),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 10.0,
                            ),
                            tickMarkShape: const RoundSliderTickMarkShape(
                              tickMarkRadius: 1.8,
                            ),
                            activeTickMarkColor:
                                widget.accentColor.withOpacity(0.4),
                            inactiveTickMarkColor: Colors.white10,
                          ),
                          child: Slider(
                            min: 1.0,
                            max: 2.0,
                            divisions: 10,
                            value: _speed,
                            onChanged: (value) {
                              setState(() => _speed = value);
                              widget.onSpeedChanged(value);
                            },
                          ),
                        ),
                      ),
                      Text(
                        '2.0',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.white24,
                        ),
                      ),
                    ],
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
