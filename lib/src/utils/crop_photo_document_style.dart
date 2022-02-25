import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

@immutable
class CropPhotoDocumentStyle {
  ///
  final bool hideAppBarDefault;

  ///
  final String textButtonSave;

  ///
  final List<Widget>? children;

  ///
  final double top;
  final double bottom;
  final double left;
  final double right;

  ///
  final Color? maskColor;

  ///
  final ui.ImageFilter? maskFilter;

  ///
  final double dotSize;
  final double dotRadius;

  ///
  final Area defaultAreaInitial;

  const CropPhotoDocumentStyle({
    this.hideAppBarDefault = false,
    this.textButtonSave = "CROP",
    this.children,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.maskColor,
    this.maskFilter,
    this.dotSize = 18,
    this.dotRadius = 30,
    this.defaultAreaInitial = const Area(
      topRight: Point(300.0, 80.0),
      topLeft: Point(40.0, 80.0),
      bottomLeft: Point(40.0, 450.0),
      bottomRight: Point(300.0, 450.0),
    ),
  });
}
