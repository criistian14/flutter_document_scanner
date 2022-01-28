import 'package:flutter/material.dart';

@immutable
class GeneralStyles {
  final bool showDefaultBottomNavigation;
  final bool showDefaultDialogs;
  final Color baseColor;

  const GeneralStyles({
    this.showDefaultBottomNavigation = true,
    this.showDefaultDialogs = true,
    this.baseColor = Colors.white,
  });
}
