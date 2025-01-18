class ContourError implements Exception {
  ContourError(this.message);

  final String message;

  @override
  String toString() => 'ContourError: $message';
}

class ContourNullError extends ContourError {
  ContourNullError() : super('Contour result is null.');
}

class InvalidContourDataError extends ContourError {
  InvalidContourDataError(this.result)
      : super('Contour result is not a valid Map.');

  final Map<String, dynamic> result;
}

class InvalidMinContourAreaError extends ContourError {
  InvalidMinContourAreaError(this.minContourArea)
      : super(
          'Invalid minContourArea value: $minContourArea. '
          'It must be greater than 0.',
        );

  final double minContourArea;
}
