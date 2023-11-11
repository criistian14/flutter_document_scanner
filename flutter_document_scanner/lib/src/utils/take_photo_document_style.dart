// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// The style of the take photo document.
@immutable
class TakePhotoDocumentStyle {
  /// Create a instance of [TakePhotoDocumentStyle].
  const TakePhotoDocumentStyle({
    this.onLoading = const Center(
      child: CircularProgressIndicator(),
    ),
    this.children,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.hideDefaultButtonTakePicture = false,
  });

  /// Widget to be displayed while loading the camera
  final Widget onLoading;

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

  /// Hide the default button to take picture
  final bool hideDefaultButtonTakePicture;
}
