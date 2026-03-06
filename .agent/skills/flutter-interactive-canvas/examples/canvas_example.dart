import 'package:flutter/material.dart';

class CourtPainter extends CustomPainter {
  final List<Offset> shotLocations;
  final Color courtLineColor;

  CourtPainter({
    required this.shotLocations,
    this.courtLineColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = courtLineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 1. Draw Court Outline
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // 2. Draw Transverse Lines
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );

    // 3. Draw Centre Circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.1,
      paint,
    );

    // 4. Draw Events (Shots)
    final shotPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    for (final loc in shotLocations) {
      // Assuming loc is a normalized offset (0.0 to 1.0)
      final actualLoc = Offset(loc.dx * size.width, loc.dy * size.height);
      canvas.drawCircle(actualLoc, 4.0, shotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return oldDelegate.shotLocations != shotLocations ||
        oldDelegate.courtLineColor != courtLineColor;
  }
}

// Usage Example Wrapper:
// GestureDetector(
//   onTapDown: (details) {
//     RenderBox box = context.findRenderObject() as RenderBox;
//     Offset localOffset = box.globalToLocal(details.globalPosition);
//     // Normalize to 0.0 - 1.0 for storage
//     double normX = localOffset.dx / box.size.width;
//     double normY = localOffset.dy / box.size.height;
//     print('Tapped at: $normX, $normY');
//   },
//   child: CustomPaint(
//     size: const Size(double.infinity, 500),
//     painter: CourtPainter(shotLocations: []),
//   ),
// )
