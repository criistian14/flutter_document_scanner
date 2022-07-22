// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterDocumentScannerMock extends FlutterDocumentScannerPlatform {
  @override
  Future<Uint8List?> adjustingPerspective({
    required Uint8List byteData,
    required List<Map<String, double>> points,
  }) {
    // TODO: implement adjustingPerspective
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> applyFilter({
    required Uint8List byteData,
    required String filter,
  }) {
    // TODO: implement applyFilter
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>?> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) {
    // TODO: implement findContourPhoto
    throw UnimplementedError();
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

    // group('getPlatformName', () {
    //   test('returns correct name', () async {
    //     expect(
    //       await FlutterDocumentScannerPlatform.instance.getPlatformName(),
    //       equals(FlutterDocumentScannerMock.mockPlatformName),
    //     );
    //   });
    // });
  });
}
