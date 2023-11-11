// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_ios/flutter_document_scanner_ios.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterDocumentScannerIOS', () {
    const kPlatformName = 'iOS';
    late FlutterDocumentScannerIOS flutterDocumentScanner;
    late List<MethodCall> log;

    setUp(() async {
      flutterDocumentScanner = FlutterDocumentScannerIOS();

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
      FlutterDocumentScannerIOS.registerWith();
      expect(
        FlutterDocumentScannerPlatform.instance,
        isA<FlutterDocumentScannerIOS>(),
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
