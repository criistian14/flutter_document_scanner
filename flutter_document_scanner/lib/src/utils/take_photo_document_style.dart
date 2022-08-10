// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

@immutable
class TakePhotoDocumentStyle {
  const TakePhotoDocumentStyle({
    this.onLoading = const Center(
      child: CircularProgressIndicator(),
    ),
    this.children,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  ///
  final Widget onLoading;

  ///
  final List<Widget>? children;

  ///
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
}
