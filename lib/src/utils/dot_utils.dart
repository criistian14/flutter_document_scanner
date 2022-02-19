import 'dart:math';

import 'package:flutter/material.dart';

class DotUtils {
  Point<double> moveTopLeft({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    double? aspectRatio,
  }) {
    final newX = max(imageRect.left, original.x + deltaX);
    final newY = max(original.y + deltaY, imageRect.top);

    return Point(newX, newY);
  }

  Point<double> moveTopRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
  }) {
    final newX = min(imageRect.right, original.x + deltaX);
    final newY = max(original.y + deltaY, imageRect.top);

    return Point(newX, newY);
  }

  Point<double> moveBottomLeft({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
  }) {
    final newX = max(imageRect.left, original.x + deltaX);
    final newY = min(original.y + deltaY, imageRect.bottom);

    return Point(newX, newY);
  }

  Point<double> moveBottomRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
  }) {
    final newX = min(imageRect.right, original.x + deltaX);
    final newY = min(original.y + deltaY, imageRect.bottom);

    return Point(newX, newY);
  }
}
