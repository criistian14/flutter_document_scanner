// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterDocumentScannerMock extends FlutterDocumentScannerPlatform {}

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
