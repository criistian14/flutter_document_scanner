import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class CropAreaClipper extends CustomClipper<Path> {
  final Area area;

  const CropAreaClipper(this.area);

  @override
  Path getClip(Size size) {
    return Path()
      ..addPath(
        Path()
          ..moveTo(area.topLeft.x, area.topLeft.y)
          ..lineTo(area.topRight.x, area.topRight.y)
          ..lineTo(area.bottomRight.x, area.bottomRight.y)
          ..lineTo(area.bottomLeft.x, area.bottomLeft.y)
          ..close(),
        Offset.zero,
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
