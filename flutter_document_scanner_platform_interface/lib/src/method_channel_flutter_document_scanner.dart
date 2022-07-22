// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// An implementation of [FlutterDocumentScannerPlatform] that uses method channels.
class MethodChannelFlutterDocumentScanner
    extends FlutterDocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_document_scanner');

  @override
  Future<Map<String, dynamic>?> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) async {
    final contour = await methodChannel.invokeMethod('findContourPhoto', {
      'byteData': byteData,
      'minContourArea': minContourArea,
    });

    if (contour is Map) {
      return Map<String, dynamic>.from(contour);
    }

    return null;
  }

  @override
  Future<Uint8List?> adjustingPerspective({
    required Uint8List byteData,
    required List<Map<String, double>> points,
  }) async {
    final newImage = await methodChannel.invokeMethod('adjustingPerspective', {
      'byteData': byteData,
      'points': points,
    });

    if (newImage is Uint8List) {
      return newImage;
    }

    return null;
  }

  @override
  Future<Uint8List?> applyFilter({
    required Uint8List byteData,
    required String filter,
  }) async {
    final newImage = await methodChannel.invokeMethod('applyFilter', {
      'byteData': byteData,
      'filter': filter,
    });

    if (newImage is Uint8List) {
      return newImage;
    }

    return null;
  }
}
