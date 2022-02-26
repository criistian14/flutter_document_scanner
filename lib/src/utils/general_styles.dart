import 'package:flutter/material.dart';

@immutable
class GeneralStyles {
  final bool hideDefaultBottomNavigation;
  final bool hideDefaultDialogs;
  final Color baseColor;

  const GeneralStyles({
    this.hideDefaultBottomNavigation = false,
    this.hideDefaultDialogs = false,
    this.baseColor = Colors.white,
  });
}
