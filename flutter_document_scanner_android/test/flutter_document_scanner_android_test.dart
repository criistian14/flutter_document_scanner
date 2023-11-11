// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_android/flutter_document_scanner_android.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDocumentScannerAndroid', () {
    const kPlatformName = 'Android';
    late FlutterDocumentScannerAndroid flutterDocumentScanner;
    late List<MethodCall> log;

    setUp(() async {
      flutterDocumentScanner = FlutterDocumentScannerAndroid();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(flutterDocumentScanner.methodChannel,
              (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      FlutterDocumentScannerAndroid.registerWith();
      expect(
        FlutterDocumentScannerPlatform.instance,
        isA<FlutterDocumentScannerAndroid>(),
      );
    });

    test('getPlatformName returns correct name', () async {
      // final name = await flutterDocumentScanner.getPlatformName();
      // expect(
      //   log,
      //   <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      // );
      // expect(name, equals(kPlatformName));
    });
  });
}
