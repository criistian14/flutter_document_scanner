// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/utils/crop_photo_document_style.dart';

/// Dots utilities
class DotUtils {
  /// Create a dot utils
  DotUtils({
    required this.minDistanceDots,
  });

  /// Minimum distance between the dots that can be
  ///
  /// Can be modified from [CropPhotoDocumentStyle.minDistanceDots]
  final int minDistanceDots;

  /// Move the entire area by the given delta values.
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
          original.topLeft.x + minDistanceDots,
        ),
        min(
          max(original.topRight.y + deltaY, imageRect.top),
          original.bottomLeft.y - minDistanceDots,
        ),
      ),
      topLeft: Point<double>(
        min(
          max(original.topLeft.x + deltaX, imageRect.left),
          original.topRight.x - minDistanceDots,
        ),
        min(
          max(original.topLeft.y + deltaY, imageRect.top),
          original.bottomLeft.y - minDistanceDots,
        ),
      ),
      bottomLeft: Point<double>(
        min(
          max(original.bottomLeft.x + deltaX, imageRect.left),
          original.bottomRight.x - minDistanceDots,
        ),
        max(
          min(original.bottomLeft.y + deltaY, imageRect.bottom),
          original.topLeft.y + minDistanceDots,
        ),
      ),
      bottomRight: Point<double>(
        max(
          min(original.bottomRight.x + deltaX, imageRect.right),
          original.bottomLeft.x + minDistanceDots,
        ),
        max(
          min(original.bottomRight.y + deltaY, imageRect.bottom),
          original.topRight.y + minDistanceDots,
        ),
      ),
    );

    return newArea;
  }

  /// Move dot top left by the given delta values.
  /// and respecting a space of [minDistanceDots] between the other dots.
  Point<double> moveTopLeft({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = min(
      max(imageRect.left, original.x + deltaX),
      originalArea.topRight.x - minDistanceDots,
    );
    final newY = min(
      max(original.y + deltaY, imageRect.top),
      originalArea.bottomLeft.y - minDistanceDots,
    );

    return Point(newX, newY);
  }

  /// Move dot top right by the given delta values
  /// and respecting a space of [minDistanceDots] between the other dots.
  Point<double> moveTopRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = max(
      min(imageRect.right, original.x + deltaX),
      originalArea.topLeft.x + minDistanceDots,
    );
    final newY = min(
      max(original.y + deltaY, imageRect.top),
      originalArea.bottomLeft.y - minDistanceDots,
    );

    return Point(newX, newY);
  }

  /// Move dot bottom left by the given delta values
  /// and respecting a space of [minDistanceDots] between the other dots.
  Point<double> moveBottomLeft({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = min(
      max(imageRect.left, original.x + deltaX),
      originalArea.bottomRight.x - minDistanceDots,
    );
    final newY = max(
      min(original.y + deltaY, imageRect.bottom),
      originalArea.topLeft.y + minDistanceDots,
    );

    return Point(newX, newY);
  }

  /// Move the bottom dot to the right by the given delta values
  /// and respecting a space of [minDistanceDots] between the other dots.
  Point<double> moveBottomRight({
    required Point<double> original,
    required double deltaX,
    required double deltaY,
    required Rect imageRect,
    required Area originalArea,
  }) {
    final newX = max(
      min(imageRect.right, original.x + deltaX),
      originalArea.bottomLeft.x + minDistanceDots,
    );
    final newY = max(
      min(original.y + deltaY, imageRect.bottom),
      originalArea.topRight.y + minDistanceDots,
    );

    return Point(newX, newY);
  }
}
