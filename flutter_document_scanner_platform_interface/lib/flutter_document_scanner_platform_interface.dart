// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter_document_scanner_platform_interface/src/contour.dart';
import 'package:flutter_document_scanner_platform_interface/src/filter_type.dart';
import 'package:flutter_document_scanner_platform_interface/src/method_channel_flutter_document_scanner.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'package:flutter_document_scanner_platform_interface/src/contour.dart';
export 'package:flutter_document_scanner_platform_interface/src/filter_type.dart';

/// The interface that implementations of flutter_document_scanner
/// must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `FlutterDocumentScanner`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added
///  [FlutterDocumentScannerPlatform] methods.
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
  /// class that extends [FlutterDocumentScannerPlatform] when
  /// they register themselves.
  static set instance(FlutterDocumentScannerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Get the version of the opencv library
  Future<String?> getVersionOpenCV() {
    throw UnimplementedError('getVersionOpenCV() has not been implemented.');
  }

  /// Apply filters to the image with opencv
  /// Then get the contours and return only the largest one that has four sides
  /// (this is done from native code)
  Future<Contour?> findContourPhoto({
    required Uint8List byteData,
    required double minContourArea,
  }) {
    throw UnimplementedError('findContourPhoto() has not been implemented.');
  }

  /// Based on the given [Contour.points], the perspective is created
  /// and a new image is returned [Uint8List]
  Future<Uint8List?> adjustingPerspective({
    required Uint8List byteData,
    required Contour contour,
  }) {
    throw UnimplementedError(
      'adjustingPerspective() has not been implemented.',
    );
  }

  /// Apply the selected [filter] with the opencv library
  Future<Uint8List?> applyFilter({
    required Uint8List byteData,
    required FilterType filter,
  }) {
    throw UnimplementedError('applyFilter() has not been implemented.');
  }
}
