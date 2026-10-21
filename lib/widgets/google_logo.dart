import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;
    final strokeWidth = w * 0.22;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Red arc (Top)
    canvas.drawArc(rect, -0.9 * math.pi, 0.75 * math.pi, false, redPaint);

    // Blue arc (Right)
    canvas.drawArc(rect, -0.15 * math.pi, 0.45 * math.pi, false, bluePaint);

    // Green arc (Bottom)
    canvas.drawArc(rect, 0.3 * math.pi, 0.5 * math.pi, false, greenPaint);

    // Yellow arc (Left)
    canvas.drawArc(rect, 0.8 * math.pi, 0.55 * math.pi, false, yellowPaint);

    // Blue crossbar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.46,
        h * 0.40,
        w * 0.50,
        h * 0.20,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
