// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// The style of the edit photo document.
@immutable
class EditPhotoDocumentStyle {
  /// Create a instance of [EditPhotoDocumentStyle].
  const EditPhotoDocumentStyle({
    this.hideAppBarDefault = false,
    this.hideBottomBarDefault = false,
    this.textButtonSave = 'SAVE',
    this.children,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  /// Hide the app bar default
  final bool hideAppBarDefault;

  /// Hide the bottom bar default
  final bool hideBottomBarDefault;

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
}
