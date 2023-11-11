// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

/// The style of the crop photo document.
@immutable
class CropPhotoDocumentStyle {
  /// Create a instance of [CropPhotoDocumentStyle].
  const CropPhotoDocumentStyle({
    this.hideAppBarDefault = false,
    this.textButtonSave = 'CROP',
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
      topRight: Point(300, 80),
      topLeft: Point(40, 80),
      bottomLeft: Point(40, 450),
      bottomRight: Point(300, 450),
    ),
    this.minDistanceDots = 30,
    this.colorBorderArea = Colors.white,
    this.widthBorderArea = 3,
  });

  /// Hide the app bar default.
  final bool hideAppBarDefault;

  /// Text of save button
  final String textButtonSave;

  /// Widget to be displayed on the page
  final List<Widget>? children;

  /// The distance that the top edge of the image is inserted from
  /// the top of the stack.
  final double top;

  /// The distance that the bottom edge of the image is inserted from
  /// the bottom of the stack.
  final double bottom;

  /// The distance that the left edge of the image is inserted from
  /// the left of the stack.
  final double left;

  /// The distance that the right edge of the image is inserted from
  /// the right of the stack.
  final double right;

  /// Mask color shown for cropping
  final Color? maskColor;

  /// Mask filter shown for cropping
  final ui.ImageFilter? maskFilter;

  /// Size of the dots
  final double dotSize;

  /// Radius of the dots
  final double dotRadius;

  /// Default area to be occupied by the mask when cropping the image
  final Area defaultAreaInitial;

  /// Minimum distance between the 4 dots
  final int minDistanceDots;

  /// Color of the border covering the clipping mask
  final Color colorBorderArea;

  /// Width of the border covering the clipping mask
  final double widthBorderArea;
}
