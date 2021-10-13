import 'package:flutter/material.dart';

class BorderCropAreaPainter extends CustomPainter {
  final Rect rect;
  final Color colorBorderArea;
  final double widthBorderArea;

  const BorderCropAreaPainter({
    @required this.rect,
    this.colorBorderArea,
    this.widthBorderArea,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double defaultWithBorderArea = 5.0;
    const Color defaultColorBorderArea = Colors.white;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = widthBorderArea ?? defaultWithBorderArea
      ..color = colorBorderArea ?? defaultColorBorderArea;

    Path path = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
