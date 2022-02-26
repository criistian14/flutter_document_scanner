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
        max(
          min(original.topRight.x + deltaX, imageRect.right),
          original.topLeft.x + 30,
        ),
        min(
          max(original.topRight.y + deltaY, imageRect.top),
          original.bottomLeft.y - 30,
        ),
      ),
      topLeft: Point<double>(
        min(
          max(original.topLeft.x + deltaX, imageRect.left),
          original.topRight.x - 30,
        ),
        min(
          max(original.topLeft.y + deltaY, imageRect.top),
          original.bottomLeft.y - 30,
        ),
      ),
      bottomLeft: Point<double>(
        min(
          max(original.bottomLeft.x + deltaX, imageRect.left),
          original.bottomRight.x - 30,
        ),
        max(
          min(original.bottomLeft.y + deltaY, imageRect.bottom),
          original.topLeft.y + 30,
        ),
      ),
      bottomRight: Point<double>(
        max(
          min(original.bottomRight.x + deltaX, imageRect.right),
          original.bottomLeft.x + 30,
        ),
        max(
          min(original.bottomRight.y + deltaY, imageRect.bottom),
          original.topRight.y + 30,
        ),
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
