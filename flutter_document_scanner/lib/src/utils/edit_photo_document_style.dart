// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

@immutable
class EditPhotoDocumentStyle {
  ///
  final bool hideAppBarDefault;

  ///
  final bool hideBottomBarDefault;

  ///
  final String textButtonSave;

  ///
  final List<Widget>? children;

  ///
  final double top;
  final double bottom;
  final double left;
  final double right;

  const EditPhotoDocumentStyle({
    this.hideAppBarDefault = false,
    this.hideBottomBarDefault = false,
    this.textButtonSave = "SAVE",
    this.children,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });
}
