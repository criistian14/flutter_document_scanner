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
    required Area originalArea,
  }) {
    final newX = min(
      max(imageRect.left, original.x + deltaX),
      originalArea.topRight.x - 30,
    );
    final newY = min(
      max(original.y + deltaY, imageRect.top),
      originalArea.bottomLeft.y - 30,
    );

    return Point(newX, newY);
  }

  Point<double> moveTopRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = max(
      min(imageRect.right, original.x + deltaX),
      originalArea.topLeft.x + 30,
    );
    final newY = min(
      max(original.y + deltaY, imageRect.top),
      originalArea.bottomLeft.y - 30,
    );

    return Point(newX, newY);
  }

  Point<double> moveBottomLeft({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = min(
      max(imageRect.left, original.x + deltaX),
      originalArea.bottomRight.x - 30,
    );
    final newY = max(
      min(original.y + deltaY, imageRect.bottom),
      originalArea.topLeft.y + 30,
    );

    return Point(newX, newY);
  }

  Point<double> moveBottomRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = max(
      min(imageRect.right, original.x + deltaX),
      originalArea.bottomLeft.x + 30,
    );
    final newY = max(
      min(original.y + deltaY, imageRect.bottom),
      originalArea.topRight.y + 30,
    );

    return Point(newX, newY);
  }
}
