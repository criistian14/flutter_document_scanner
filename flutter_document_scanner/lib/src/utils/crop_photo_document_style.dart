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

@immutable
class CropPhotoDocumentStyle {
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
  });

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
}
