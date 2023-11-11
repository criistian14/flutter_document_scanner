// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterDocumentScannerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterDocumentScannerPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDocumentScanner', () {
    late FlutterDocumentScannerPlatform flutterDocumentScannerPlatform;

    setUp(() {
      flutterDocumentScannerPlatform = MockFlutterDocumentScannerPlatform();
      FlutterDocumentScannerPlatform.instance = flutterDocumentScannerPlatform;
    });

    group('getPlatformName', () {
      // test('returns correct name when platform implementation exists',
      //     () async {
      //   const platformName = '__test_platform__';
      //   when(
      //     () => flutterDocumentScannerPlatform.getPlatformName(),
      //   ).thenAnswer((_) async => platformName);
      //
      //   // final actualPlatformName = await getPlatformName();
      //   // expect(actualPlatformName, equals(platformName));
      // });
      //
      // test('throws exception when platform implementation is missing',
      //     () async {
      //   when(
      //     () => flutterDocumentScannerPlatform.getPlatformName(),
      //   ).thenAnswer((_) async => null);
      //
      //   // expect(getPlatformName, throwsException);
      // });
    });
  });
}
