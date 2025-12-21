import 'package:flutter/rendering.dart';

class CustomCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFE9E9E9)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 15;
    const dashSpace = 15;
    final radius = size.width / 2;
    double startAngle = 0;

    while (startAngle < 360) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle * 0.0174533,
        dashWidth * 0.0174533,
        false,
        paint,
      );
      startAngle += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
