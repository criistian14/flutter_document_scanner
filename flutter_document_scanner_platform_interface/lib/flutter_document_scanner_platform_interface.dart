// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter_document_scanner_platform_interface/src/method_channel_flutter_document_scanner.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of flutter_document_scanner must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `FlutterDocumentScanner`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [FlutterDocumentScannerPlatform] methods.
abstract class FlutterDocumentScannerPlatform extends PlatformInterface {
  /// Constructs a FlutterDocumentScannerPlatform.
  FlutterDocumentScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterDocumentScannerPlatform _instance =
      MethodChannelFlutterDocumentScanner();

  /// The default instance of [FlutterDocumentScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterDocumentScanner].
  static FlutterDocumentScannerPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterDocumentScannerPlatform] when they register themselves.
  static set instance(FlutterDocumentScannerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<Map<String, dynamic>?> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  });

  Future<Uint8List?> adjustingPerspective({
    required Uint8List byteData,
    required List<Map<String, double>> points,
  });

  Future<Uint8List?> applyFilter({
    required Uint8List byteData,
    required String filter,
  });
}