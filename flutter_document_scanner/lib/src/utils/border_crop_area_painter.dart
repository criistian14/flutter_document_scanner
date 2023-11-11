// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/utils/crop_photo_document_style.dart';

/// Border
class BorderCropAreaPainter extends CustomPainter {
  /// Create a painter for the given [Area].
  const BorderCropAreaPainter({
    required this.area,
    required this.colorBorderArea,
    required this.widthBorderArea,
  });

  /// The area to paint
  final Area area;

  /// Color of the border covering the clipping mask
  ///
  /// Can be modified from [CropPhotoDocumentStyle.colorBorderArea]
  final Color colorBorderArea;

  /// Width of the border covering the clipping mask
  ///
  /// Can be modified from [CropPhotoDocumentStyle.widthBorderArea]
  final double widthBorderArea;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = widthBorderArea
      ..color = colorBorderArea;

    final path = Path()
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
