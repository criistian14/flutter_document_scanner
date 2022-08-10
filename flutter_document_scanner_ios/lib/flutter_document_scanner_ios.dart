// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// The iOS implementation of [FlutterDocumentScannerPlatform].
class FlutterDocumentScannerIOS extends FlutterDocumentScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_document_scanner_ios');

  /// Registers this class as the default instance of [FlutterDocumentScannerPlatform]
  static void registerWith() {
    FlutterDocumentScannerPlatform.instance = FlutterDocumentScannerIOS();
  }
}
