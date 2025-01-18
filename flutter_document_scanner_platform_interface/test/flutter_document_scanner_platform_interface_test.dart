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

  @override
  Future<Uint8List> applyFilter({
    required Uint8List byteData,
    required FilterType filter,
  }) async {
    return byteData;
  }

  @override
  Future<Uint8List> adjustingPerspective({
    required Uint8List byteData,
    required Contour contour,
  }) async {
    return byteData;
  }
}

class FlutterDocumentScannerNotImplemented
    extends FlutterDocumentScannerPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDocumentScannerPlatformInterface', () {
    late FlutterDocumentScannerPlatform flutterDocumentScannerPlatform;

    setUp(() {
      flutterDocumentScannerPlatform = FlutterDocumentScannerMock();
      FlutterDocumentScannerPlatform.instance = flutterDocumentScannerPlatform;
    });

    test(
      'Should return expected contour when findContourPhoto is called',
      () async {
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
      },
    );

    test(
      'Should return the same byte data when applyFilter is called',
      () async {
        final tByteData = Uint8List.fromList([1, 2, 3]);
        const tFilterType = FilterType.natural;

        expect(
          await FlutterDocumentScannerPlatform.instance.applyFilter(
            byteData: tByteData,
            filter: tFilterType,
          ),
          equals(
            await flutterDocumentScannerPlatform.applyFilter(
              byteData: tByteData,
              filter: tFilterType,
            ),
          ),
        );
      },
    );

    test(
      'Should return the same byte data when adjustingPerspective is called',
      () async {
        final tByteData = Uint8List.fromList([1, 2, 3]);
        const tContour = Contour(
          points: [
            Point(10.5, 50.8),
            Point(0.2, 8),
            Point(10.5, 50.8),
            Point(0.2, 8),
          ],
        );

        expect(
          await FlutterDocumentScannerPlatform.instance.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          ),
          equals(
            await flutterDocumentScannerPlatform.adjustingPerspective(
              byteData: tByteData,
              contour: tContour,
            ),
          ),
        );
      },
    );
  });

  group('FlutterDocumentScannerNotImplemented', () {
    test(
      'Should throw UnimplementedError when findContourPhoto '
      'is called without implementation',
      () async {
        final flutterDocumentScannerPlatform =
            FlutterDocumentScannerNotImplemented();

        final tByteData = Uint8List.fromList([1, 2, 3]);
        const tMinContourArea = 100.0;

        expect(
          () async => flutterDocumentScannerPlatform.findContourPhoto(
            byteData: tByteData,
            minContourArea: tMinContourArea,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      },
    );

    test(
      'Should throw UnimplementedError when adjustingPerspective '
      'is called without implementation',
      () async {
        final flutterDocumentScannerPlatform =
            FlutterDocumentScannerNotImplemented();

        final tByteData = Uint8List.fromList([1, 2, 3]);
        const tContour = Contour(
          points: [
            Point(10.5, 50.8),
            Point(0.2, 8),
            Point(10.5, 50.8),
            Point(0.2, 8),
          ],
        );

        expect(
          () async => flutterDocumentScannerPlatform.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      },
    );

    test(
      'Should throw UnimplementedError when applyFilter '
      'is called without implementation',
      () async {
        final flutterDocumentScannerPlatform =
            FlutterDocumentScannerNotImplemented();

        final tByteData = Uint8List.fromList([1, 2, 3]);
        const tFilterType = FilterType.natural;

        expect(
          () async => flutterDocumentScannerPlatform.applyFilter(
            byteData: tByteData,
            filter: tFilterType,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      },
    );
  });
}
