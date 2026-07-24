import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Dönen neon gradyan çerçeveli ve ışıltılı dış gölgeli premium kart widget'ı.
/// Cam morfizması tasarımlar için harika bir çerçeve efekti sunar.
class GlowingBorderCard extends StatefulWidget {
  final Widget child;
  final List<Color> glowColors;
  final double borderRadius;
  final double borderWidth;
  final Duration duration;

  const GlowingBorderCard({
    super.key,
    required this.child,
    this.glowColors = const [
      Colors.cyanAccent,
      Color(0xFF8B5CF6), // Purple
      Color(0xFFFF6B6B), // Coral
      Colors.cyanAccent,
    ],
    this.borderRadius = 24.0,
    this.borderWidth = 2.0,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<GlowingBorderCard> createState() => _GlowingBorderCardState();
}

class _GlowingBorderCardState extends State<GlowingBorderCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: _GlowingBorderPainter(
              animationValue: _controller.value,
              glowColors: widget.glowColors,
              borderRadius: widget.borderRadius,
              borderWidth: widget.borderWidth,
            ),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: widget.child,
      ),
    );
  }
}

class _GlowingBorderPainter extends CustomPainter {
  final double animationValue;
  final List<Color> glowColors;
  final double borderRadius;
  final double borderWidth;

  _GlowingBorderPainter({
    required this.animationValue,
    required this.glowColors,
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Dış ışıltı gölgesi (Neon aura efekti)
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth + 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    // Keskin gradyan çerçeve çizgisi
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Dönen SweepGradient
    final double angle = animationValue * 2 * math.pi;
    final gradient = SweepGradient(
      center: Alignment.center,
      colors: glowColors,
      transform: GradientRotation(angle),
    );

    glowPaint.shader = gradient.createShader(rect);
    borderPaint.shader = gradient.createShader(rect);

    // Önce neon yayılım gölgesini çiziyoruz
    canvas.drawRRect(rrect, glowPaint);
    // Sonra kartın sınırlarını belirleyen keskin kenarlığı çiziyoruz
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowingBorderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.glowColors != glowColors ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth;
  }
}
