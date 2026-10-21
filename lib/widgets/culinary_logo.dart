import 'package:flutter/material.dart';

class CulinaryLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const CulinaryLogo({
    super.key,
    this.size = 72,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? const Color(0xFFDE5D26);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CulinaryLogoPainter(color: logoColor),
      ),
    );
  }
}

class _CulinaryLogoPainter extends CustomPainter {
  final Color color;

  _CulinaryLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // 1. Draw Bowl
    // Bowl occupies y: 0.52 * h to 0.95 * h
    final bowlPath = Path();
    final topY = h * 0.52;
    final bottomY = h * 0.92;
    final leftX = w * 0.12;
    final rightX = w * 0.88;

    bowlPath.moveTo(leftX, topY);
    bowlPath.lineTo(rightX, topY);
    // Curve down to right bottom
    bowlPath.cubicTo(
      rightX,
      bottomY,
      w * 0.75,
      bottomY,
      w * 0.5,
      bottomY,
    );
    // Curve up to left
    bowlPath.cubicTo(
      w * 0.25,
      bottomY,
      leftX,
      bottomY,
      leftX,
      topY,
    );
    bowlPath.close();

    canvas.drawPath(bowlPath, paintFill);

    // 2. Draw 3 Steams (Left, Center, Right)
    // Steam 1: Left
    _drawSteam(
      canvas: canvas,
      paint: paintStroke,
      startX: w * 0.35,
      startY: h * 0.44,
      endX: w * 0.37,
      endY: h * 0.15,
      curveWidth: w * 0.05,
    );

    // Steam 2: Center (taller)
    _drawSteam(
      canvas: canvas,
      paint: paintStroke,
      startX: w * 0.50,
      startY: h * 0.44,
      endX: w * 0.52,
      endY: h * 0.08,
      curveWidth: w * 0.05,
    );

    // Steam 3: Right
    _drawSteam(
      canvas: canvas,
      paint: paintStroke,
      startX: w * 0.65,
      startY: h * 0.44,
      endX: w * 0.67,
      endY: h * 0.15,
      curveWidth: w * 0.05,
    );
  }

  void _drawSteam({
    required Canvas canvas,
    required Paint paint,
    required double startX,
    required double startY,
    required double endX,
    required double endY,
    required double curveWidth,
  }) {
    final path = Path();
    path.moveTo(startX, startY);

    final midY = (startY + endY) / 2;
    path.cubicTo(
      startX - curveWidth,
      startY - (startY - midY) * 0.5,
      startX + curveWidth,
      midY + (midY - endY) * 0.5,
      endX,
      endY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CulinaryLogoPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
