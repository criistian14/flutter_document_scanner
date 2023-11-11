// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Contour class
class Contour extends Equatable {
  /// Create a contour instance
  const Contour({
    this.height,
    this.width,
    required this.points,
    this.image,
  });

  /// Construct class from the json map
  factory Contour.fromMap(Map<String, dynamic> map) {
    return Contour(
      height: map['height'] as int?,
      width: map['width'] as int?,
      points: (map['points'] as List)
          .map(
            (e) => Point(
              Map<String, double>.from(e as Map)['x']!,
              Map<String, double>.from(e)['y']!,
            ),
          )
          .toList(),
      image: map['image'] as Uint8List?,
    );
  }

  /// image [height]
  final int? height;

  /// image [width]
  final int? width;

  /// list of contour points (coordinates)
  final List<Point<double>> points;

  /// bytes of the returned image (maybe eliminated in the future)
  final Uint8List? image;

  @override
  List<Object?> get props => [
        height,
        width,
        points,
        image,
      ];

  /// Creates a copy of this Contour but with the given fields replaced with
  /// the new values.
  Contour copyWith({
    int? height,
    int? width,
    List<Point<double>>? points,
    Uint8List? image,
  }) {
    return Contour(
      height: height ?? this.height,
      width: width ?? this.width,
      points: points ?? this.points,
      image: image ?? this.image,
    );
  }

  /// Convert the class to String
  @override
  String toString() {
    return 'Contour(height: $height, width: $width, points: $points, image: $image)';
  }
}
