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
        min(original.topRight.x + deltaX, imageRect.right),
        max(original.topRight.y + deltaY, imageRect.top),
      ),
      topLeft: Point<double>(
        max(original.topLeft.x + deltaX, imageRect.left),
        max(original.topLeft.y + deltaY, imageRect.top),
      ),
      bottomLeft: Point<double>(
        max(original.bottomLeft.x + deltaX, imageRect.left),
        min(original.bottomLeft.y + deltaY, imageRect.bottom),
      ),
      bottomRight: Point<double>(
        min(original.bottomRight.x + deltaX, imageRect.right),
        min(original.bottomRight.y + deltaY, imageRect.bottom),
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
