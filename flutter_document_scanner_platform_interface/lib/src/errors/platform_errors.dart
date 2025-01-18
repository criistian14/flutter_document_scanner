import 'package:flutter/foundation.dart';

class PlatformError implements Exception {
  PlatformError(this.message);
  final String message;

  @override
  String toString() => 'PlatformError: $message';
}

class InvalidByteDataError extends PlatformError {
  InvalidByteDataError(
    this.byteData,
  ) : super('Byte data provided is invalid or empty.');

  final Uint8List byteData;
}

class PlatformNotSupportedError extends PlatformError {
  PlatformNotSupportedError()
      : super('The current platform does not support this functionality.');
}
