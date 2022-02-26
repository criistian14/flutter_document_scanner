import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class BorderCropAreaPainter extends CustomPainter {
  final Area area;
  final Color? colorBorderArea;
  final double? widthBorderArea;

  const BorderCropAreaPainter({
    required this.area,
    this.colorBorderArea,
    this.widthBorderArea,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = widthBorderArea ?? 3
      ..color = colorBorderArea ?? Colors.white;

    Path path = Path()
      ..moveTo(area.topLeft.x, area.topLeft.y)
      ..lineTo(area.topRight.x, area.topRight.y)
      ..lineTo(area.bottomRight.x, area.bottomRight.y)
      ..lineTo(area.bottomLeft.x, area.bottomLeft.y)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
