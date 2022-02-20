import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Contour extends Equatable {
  /// image [height]
  final int height;

  /// image [width]
  final int width;

  /// list of contour points (coordinates)
  final List<Point<double>> points;

  /// bytes of the returned image (maybe eliminated in the future)
  final Uint8List image;

  const Contour({
    required this.height,
    required this.width,
    required this.points,
    required this.image,
  });

  @override
  List<Object?> get props => [
        height,
        width,
        points,
        image,
      ];

  factory Contour.fromMap(Map<String, dynamic> map) {
    return Contour(
      height: map['height'] as int,
      width: map['width'] as int,
      points: (map['points'] as List)
          .map(
            (e) => Point(
              Map<String, double>.from(e)["x"]!,
              Map<String, double>.from(e)["y"]!,
            ),
          )
          .toList(),
      image: map['image'] as Uint8List,
    );
  }
}
