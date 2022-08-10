// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

@immutable
class GeneralStyles {
  const GeneralStyles({
    this.hideDefaultBottomNavigation = false,
    this.hideDefaultDialogs = false,
    this.baseColor = Colors.white,
  });

  final bool hideDefaultBottomNavigation;
  final bool hideDefaultDialogs;
  final Color baseColor;
}
