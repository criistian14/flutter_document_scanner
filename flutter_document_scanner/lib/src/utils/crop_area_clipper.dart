// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

/// Clipper for the crop area
class CropAreaClipper extends CustomClipper<Path> {
  /// Create a clipper for the given [Area].
  const CropAreaClipper(this.area);

  /// The area to clip
  final Area area;

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
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
