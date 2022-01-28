import 'package:flutter/material.dart';

@immutable
class TakePhotoDocumentStyle {
  ///
  final Widget onLoading;

  ///
  final List<Widget>? children;

  ///
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

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
}
