import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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

  const CropPhotoDocumentStyle({
    this.hideAppBarDefault = false,
    this.textButtonSave = "SAVE",
    this.children,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.maskColor,
    this.maskFilter,
    this.dotSize = 18,
    this.dotRadius = 30,
  });
}
