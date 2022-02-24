import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class DotUtils {
  Area moveArea({
    required Area original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
  }) {
    final newArea = Area(
      topRight: Point<double>(
        original.topRight.x + deltaX,
        original.topRight.y + deltaY,
      ),
      topLeft: Point<double>(
        original.topLeft.x + deltaX,
        original.topLeft.y + deltaY,
      ),
      bottomLeft: Point<double>(
        original.bottomLeft.x + deltaX,
        original.bottomLeft.y + deltaY,
      ),
      bottomRight: Point<double>(
        original.bottomRight.x + deltaX,
        original.bottomRight.y + deltaY,
      ),
    );

    return newArea;
  }

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
