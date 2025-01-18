import 'dart:math';

class PerspectiveError implements Exception {
  PerspectiveError(this.message);
  final String message;

  @override
  String toString() => 'PerspectiveError: $message';
}

class InsufficientContourPointsError extends PerspectiveError {
  InsufficientContourPointsError(this.points)
      : super(
          'The contour must contain exactly 4 points to adjust perspective.',
        );

  final List<Point> points;
}

class InvalidContourPointsError extends PerspectiveError {
  InvalidContourPointsError(this.points, this.errorPoint)
      : super('One or more points in the contour are invalid.');

  final List<Point> points;
  final Point errorPoint;
}

class PerspectiveAdjustmentNullError extends PerspectiveError {
  PerspectiveAdjustmentNullError()
      : super('The result of adjusting perspective is null.');
}
