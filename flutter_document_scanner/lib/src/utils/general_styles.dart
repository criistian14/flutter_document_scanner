// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// The style of the document scanner.
@immutable
class GeneralStyles {
  /// Create a instance of [GeneralStyles].
  const GeneralStyles({
    this.hideDefaultBottomNavigation = false,
    this.hideDefaultDialogs = false,
    this.baseColor = Colors.white,
  });

  /// Hide the default bottom navigation.
  final bool hideDefaultBottomNavigation;

  /// Hide the default dialogs of the app.
  final bool hideDefaultDialogs;

  /// The base color of the app.
  final Color baseColor;
}
