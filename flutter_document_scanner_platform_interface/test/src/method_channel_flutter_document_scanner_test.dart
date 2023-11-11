// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // const kPlatformName = 'platformName';

  // group('$MethodChannelFlutterDocumentScanner', () {
  //   late MethodChannelFlutterDocumentScanner
  //       methodChannelFlutterDocumentScanner;
  //   final log = <MethodCall>[];
  //
  //   setUp(() async {
  //     methodChannelFlutterDocumentScanner =
  //         MethodChannelFlutterDocumentScanner()
  //           ..methodChannel
  //               .setMockMethodCallHandler((MethodCall methodCall) async {
  //             log.add(methodCall);
  //             switch (methodCall.method) {
  //               case 'getPlatformName':
  //                 return kPlatformName;
  //               default:
  //                 return null;
  //             }
  //           });
  //   });
  //
  //   tearDown(log.clear);
  //
  //   test('getPlatformName', () async {
  //     final platformName =
  //         await methodChannelFlutterDocumentScanner.getPlatformName();
  //     expect(
  //       log,
  //       <Matcher>[isMethodCall('getPlatformName', arguments: null)],
  //     );
  //     expect(platformName, equals(kPlatformName));
  //   });
  // });
}
