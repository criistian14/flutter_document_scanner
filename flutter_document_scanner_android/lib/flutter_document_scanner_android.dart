// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// The Android implementation of [FlutterDocumentScannerPlatform].
class FlutterDocumentScannerAndroid extends FlutterDocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_document_scanner_android');

  /// Registers this class as the default instance
  /// of [FlutterDocumentScannerPlatform]
  static void registerWith() {
    FlutterDocumentScannerPlatform.instance = FlutterDocumentScannerAndroid();
  }

  @override
  Future<Contour> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) async {
    if (byteData.isEmpty) {
      throw InvalidByteDataError(byteData);
    }

    if (minContourArea <= 0) {
      throw InvalidMinContourAreaError(minContourArea);
    }

    final contour = await methodChannel.invokeMapMethod<String, dynamic>(
      'findContourPhoto',
      <String, Object>{
        'byteData': byteData,
        'minContourArea': minContourArea,
      },
    );

    if (contour == null) {
      throw ContourNullError();
    }

    if (!contour.containsKey('points') || contour['points'] is! List) {
      throw InvalidContourDataError(contour);
    }

    return Contour.fromMap(contour);
  }

  @override
  Future<Uint8List> adjustingPerspective({
    required Uint8List byteData,
    required Contour contour,
  }) async {
    if (byteData.isEmpty) {
      throw InvalidByteDataError(byteData);
    }

    if (contour.points.length < 4) {
      throw InsufficientContourPointsError(contour.points);
    }

    for (final point in contour.points) {
      if (point.x.isNaN || point.y.isNaN) {
        throw InvalidContourPointsError(contour.points, point);
      }
    }

    try {
      final result = await methodChannel.invokeMethod<Uint8List>(
        'adjustingPerspective',
        <String, Object>{
          'byteData': byteData,
          'points': contour.pointsAsMap,
        },
      );

      if (result == null) {
        throw PerspectiveAdjustmentNullError();
      }

      return result;
    } on PerspectiveAdjustmentNullError {
      rethrow;
    } catch (e) {
      throw PlatformError(
        'Failed to adjust perspective: $e',
      );
    }
  }

  @override
  Future<Uint8List> applyFilter({
    required Uint8List byteData,
    required FilterType filter,
  }) async {
    if (byteData.isEmpty) {
      throw InvalidByteDataError(byteData);
    }

    try {
      final result = await methodChannel.invokeMethod<Uint8List>(
        'applyFilter',
        <String, Object>{
          'byteData': byteData,
          'filter': filter.value,
        },
      );

      if (result == null) {
        throw FilterResultNullError();
      }

      return result;
    } on FilterResultNullError {
      rethrow;
    } on PlatformException catch (e) {
      if (e.code == 'UNSUPPORTED_FILTER_TYPE') {
        throw UnsupportedFilterTypeError(filter.toString());
      }

      rethrow;
    } catch (e) {
      throw FilterError('Failed to apply filter: $e');
    }
  }
}
