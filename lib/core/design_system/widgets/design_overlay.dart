import 'package:flutter/material.dart';
import 'package:netstats_pro/core/design_system/'
    'design_overlay_settings.dart';

/// DesignOverlay — A global diagnostic tool to audit UI ergonomics and hierarchy.
///
/// Wraps the entire application and renders:
/// 1. **Thumb Zone**: Color-coded ergonomic reachability zones.
/// 2. **Z-Pattern**: A visual guide for the Z-scan visual scanning pattern.
class DesignOverlay extends StatelessWidget {
  const DesignOverlay({
    required this.child,
    required this.settings,
    super.key,
  });

  final Widget child;
  final DesignOverlaySettings settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        return Stack(
          children: [
            child,
            if (settings.showThumbZone || settings.showZPattern)
              IgnorePointer(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _OverlayPainter(
                    showThumbZone: settings.showThumbZone,
                    showZPattern: settings.showZPattern,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({
    required this.showThumbZone,
    required this.showZPattern,
  });

  final bool showThumbZone;
  final bool showZPattern;

  @override
  void paint(Canvas canvas, Size size) {
    if (showThumbZone) {
      _paintThumbZone(canvas, size);
    }
    if (showZPattern) {
      _paintZPattern(canvas, size);
    }
  }

  void _paintThumbZone(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Safely Reachable (Bottom 40%, centered)
    final easyPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Reachable (Middle 30%)
    final okPaint = Paint()
      ..color = Colors.orange.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Hard to Reach (Top 30% + Corners)
    final hardPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    // Draw Zones
    canvas
      ..drawRect(Rect.fromLTWH(0, 0, width, height * 0.3), hardPaint)
      ..drawRect(
        Rect.fromLTWH(0, height * 0.3, width, height * 0.3),
        okPaint,
      )
      ..drawRect(
        Rect.fromLTWH(0, height * 0.6, width, height * 0.4),
        easyPaint,
      );

    // Add thumb arc visualization (centered at bottom)
    final arcPaint = Paint()
      ..color = Colors.green.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Representative thumb sweep from bottom right/left
    canvas
      ..drawCircle(Offset(width, height), width * 0.8, arcPaint)
      ..drawCircle(Offset(0, height), width * 0.8, arcPaint);
  }

  void _paintZPattern(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    const padding = 40.0;

    final zPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(padding, padding) // Top Left
      ..lineTo(width - padding, padding) // Top Right
      ..lineTo(padding, height - padding) // Bottom Left
      ..lineTo(width - padding, height - padding); // Bottom Right

    // Draw the path and the dots
    canvas
      ..drawPath(path, zPaint)
      ..drawCircle(const Offset(padding, padding), 8, dotPaint)
      ..drawCircle(Offset(width - padding, padding), 8, dotPaint)
      ..drawCircle(Offset(padding, height - padding), 8, dotPaint)
      ..drawCircle(Offset(width - padding, height - padding), 8, dotPaint);

    // Add labels
    _drawLabel(canvas, '1', const Offset(padding - 5, padding - 25));
    _drawLabel(canvas, '2', Offset(width - padding - 5, padding - 25));
    _drawLabel(canvas, '3', Offset(padding - 5, height - padding + 10));
    _drawLabel(canvas, '4', Offset(width - padding - 5, height - padding + 10));
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Draw background for legibility
    final bgPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    canvas.drawRect(
      Rect.fromLTWH(
        offset.dx - 4,
        offset.dy - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      ),
      bgPaint,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    return oldDelegate.showThumbZone != showThumbZone ||
        oldDelegate.showZPattern != showZPattern;
  }
}
