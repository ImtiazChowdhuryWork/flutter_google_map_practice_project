import 'package:flutter/material.dart';

class RulerStroke extends StatelessWidget {
  final Color lineColor;
  final double strokeWidth;
  final double linePercentage;
  final double height;
  final Alignment alignment; // Add alignment parameter

  const RulerStroke({
    super.key,
    this.lineColor = Colors.black,
    this.strokeWidth = 2.0,
    this.linePercentage = 0.4,
    this.height = 10,
    this.alignment = Alignment.centerLeft, // Default to left alignment
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RulerStrokePainter(
        lineColor: lineColor,
        strokeWidth: strokeWidth,
        linePercentage: linePercentage,
        alignment: alignment,
      ),
      size: Size.fromHeight(height),
    );
  }
}

class RulerStrokePainter extends CustomPainter {
  final Color lineColor;
  final double strokeWidth;
  final double linePercentage;
  final Alignment alignment;

  const RulerStrokePainter({
    required this.lineColor,
    required this.strokeWidth,
    required this.linePercentage,
    required this.alignment,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth;

    // Calculate start and end points based on alignment
    double startX;
    double endX;

    if (alignment == Alignment.centerLeft) {
      // Line starts from left
      startX = 0;
      endX = size.width * linePercentage;
    } else {
      // Line starts from right
      startX = size.width * (1 - linePercentage);
      endX = size.width;
    }

    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(endX, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RulerStrokePainter oldDelegate) {
    return lineColor != oldDelegate.lineColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        linePercentage != oldDelegate.linePercentage ||
        alignment != oldDelegate.alignment;
  }
}
