// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:flutter/foundation.dart';

/// Contour class
@immutable
class Contour {
  /// Create a contour instance
  const Contour({
    required this.points,
    this.height,
    this.width,
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

  /// Converts a list of points into a list of maps with 'x' and 'y' coordinates
  ///
  /// Each point is transformed into a `Map<String, double>` with:
  /// - 'x': The x-coordinate.
  /// - 'y': The y-coordinate.
  List<Map<String, double>> get pointsAsMap => points
      .map(
        (e) => {
          'x': e.x,
          'y': e.y,
        },
      )
      .toList();

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contour &&
          runtimeType == other.runtimeType &&
          height == other.height &&
          width == other.width &&
          listEquals(other.points, points) &&
          image == other.image;

  @override
  int get hashCode =>
      height.hashCode ^ width.hashCode ^ points.hashCode ^ image.hashCode;

  /// Convert the class to String
  @override
  String toString() {
    return 'Contour{'
        'height: $height, '
        'width: $width, '
        'points: $points, '
        'image: $image '
        '}';
  }
}
