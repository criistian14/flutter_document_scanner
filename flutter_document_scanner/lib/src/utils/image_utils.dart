// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

/// ImageUtils class
class ImageUtils {
  FlutterDocumentScannerPlatform get _platform =>
      FlutterDocumentScannerPlatform.instance;

  /// Calculates the rect of the image
  Rect imageRect(Size screenSize) {
    return Rect.fromLTWH(
      0,
      0,
      screenSize.width,
      screenSize.height,
    );
  }

  /// Apply filters to the image with opencv
  /// Then get the contours and return only the largest one that has four sides
  /// (this is done from native code)
  ///
  /// The [Contour.points] are sorted and returned [Area]
  Future<Area?> findContourPhoto(
    Uint8List byteData, {
    double? minContourArea,
  }) async {
    try {
      final contour = await _platform.findContourPhoto(
        byteData: byteData,
        minContourArea: minContourArea ?? 80000.0,
      );
      if (contour == null) return null;

      // final contourParsed = Contour.fromMap(contour);
      if (contour.points.isEmpty) return null;
      if (contour.points.length != 4) return null;

      // Identify each side of the contour
      int numTopFound = 0;
      int numBottomFound = 0;

      Point<double> top1 = const Point<double>(0, 0);
      Point<double> top2 = const Point<double>(0, 0);

      Point<double> bottom1 = const Point<double>(0, 0);
      Point<double> bottom2 = const Point<double>(0, 0);

      Point<double> lastTopFound = const Point<double>(0, 1000000);
      Point<double> lastBottomFound = const Point<double>(0, 0);

      for (int i = 0; i < 4; i++) {
        for (final point in contour.points) {
          if (point.y > lastBottomFound.y) {
            if (bottom1.y == 0 || point.y != bottom1.y) {
              lastBottomFound = point;
            }
          }

          if (point.y < lastTopFound.y) {
            if (top1.y == 0 || point.y != top1.y) {
              lastTopFound = point;
            }
          }
        }

        if (numTopFound <= 2) {
          if (numTopFound == 0) {
            top1 = lastTopFound;
          } else {
            top2 = lastTopFound;
          }
        }

        if (numBottomFound <= 2) {
          if (numBottomFound == 0) {
            bottom1 = lastBottomFound;
          } else {
            bottom2 = lastBottomFound;
          }
        }

        numTopFound++;
        numBottomFound++;
        lastTopFound = const Point(0, 1000000);
        lastBottomFound = const Point(0, 0);
      }

      Point<double> topLeft = const Point<double>(0, 0);
      Point<double> topRight = const Point<double>(0, 0);

      Point<double> bottomLeft = const Point<double>(0, 0);
      Point<double> bottomRight = const Point<double>(0, 0);

      if (top1.x < top2.x) {
        topLeft = top1;
        topRight = top2;
      } else {
        topRight = top1;
        topLeft = top2;
      }

      if (bottom1.x < bottom2.x) {
        bottomLeft = bottom1;
        bottomRight = bottom2;
      } else {
        bottomRight = bottom1;
        bottomLeft = bottom2;
      }

      final anyEqualPoints = topRight == topLeft ||
          topRight == bottomLeft ||
          topRight == bottomRight ||
          topLeft == bottomLeft ||
          topLeft == bottomRight ||
          bottomLeft == bottomRight;
      if (anyEqualPoints) {
        return null;
      }

      return Area(
        topRight: topRight,
        topLeft: topLeft,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      );
    } catch (e) {
      // TODO(utils): add error handler
      return null;
    }
  }

  /// Based on the given [Contour.points], the perspective is created
  /// and a new image is returned [Uint8List]
  Future<Uint8List?> adjustingPerspective(
    Uint8List byteData,
    Contour contour,
  ) async {
    try {
      final newImage = await _platform.adjustingPerspective(
        byteData: byteData,
        contour: contour,
      );

      return newImage;
    } catch (e) {
      // TODO(utils): add error handler
      return null;
    }
  }

  /// Apply the selected [filter] with the opencv library
  Future<Uint8List> applyFilter(
    Uint8List byteData,
    FilterType filter,
  ) async {
    try {
      final newImage = await _platform.applyFilter(
        byteData: byteData,
        filter: filter,
      );

      if (newImage == null) {
        return byteData;
      }

      return newImage;
    } catch (e) {
      // TODO(utils): add error handler
      // print(e);
      return byteData;
    }
  }
}
