// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// An implementation of [FlutterDocumentScannerPlatform]
/// that uses method channels.
class MethodChannelFlutterDocumentScanner
    extends FlutterDocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_document_scanner');

  @override
  Future<Contour?> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) async {
    final contour = await methodChannel.invokeMapMethod<String, dynamic>(
      'findContourPhoto',
      <String, Object>{
        'byteData': byteData,
        'minContourArea': minContourArea,
      },
    );

    if (contour != null) {
      return Contour.fromMap(contour);
    }

    return null;
  }

  @override
  Future<Uint8List?> adjustingPerspective({
    required Uint8List byteData,
    required Contour contour,
  }) async {
    return methodChannel.invokeMethod<Uint8List>(
      'adjustingPerspective',
      <String, Object>{
        'byteData': byteData,
        'points': contour.points
            .map(
              (e) => {
                'x': e.x,
                'y': e.y,
              },
            )
            .toList(),
      },
    ).then((value) => value);
  }

  @override
  Future<Uint8List?> applyFilter({
    required Uint8List byteData,
    required FilterType filter,
  }) async {
    return methodChannel.invokeMethod<Uint8List>(
      'applyFilter',
      <String, Object>{
        'byteData': byteData,
        'filter': filter.value,
      },
    ).then((value) => value);
  }
}
