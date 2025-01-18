// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterDocumentScannerMock extends FlutterDocumentScannerPlatform {
  @override
  Future<Contour> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) async {
    return const Contour(
      points: [
        Point(10.5, 50.8),
        Point(0.2, 8),
        Point(10.5, 50.8),
        Point(0.2, 8),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDocumentScannerPlatformInterface', () {
    late FlutterDocumentScannerPlatform flutterDocumentScannerPlatform;

    setUp(() {
      flutterDocumentScannerPlatform = FlutterDocumentScannerMock();
      FlutterDocumentScannerPlatform.instance = flutterDocumentScannerPlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        final tByteData = Uint8List(1);
        const tMinContourArea = 120.0;

        expect(
          await FlutterDocumentScannerPlatform.instance.findContourPhoto(
            byteData: tByteData,
            minContourArea: tMinContourArea,
          ),
          equals(
            await flutterDocumentScannerPlatform.findContourPhoto(
              byteData: tByteData,
              minContourArea: tMinContourArea,
            ),
          ),
        );
      });
    });
  });
}
