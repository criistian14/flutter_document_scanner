// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:equatable/equatable.dart';

/// Area composed of 4 points
class Area extends Equatable {
  /// Create a new area
  const Area({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  /// The top left dot
  final Point<double> topLeft;

  /// The top right dot
  final Point<double> topRight;

  /// The bottom left dot
  final Point<double> bottomLeft;

  /// The bottom right dot
  final Point<double> bottomRight;

  @override
  List<Object?> get props => [
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
      ];

  /// Creates a copy of this Area but with the given fields replaced with
  /// the new values.
  Area copyWith({
    Point<double>? topLeft,
    Point<double>? topRight,
    Point<double>? bottomLeft,
    Point<double>? bottomRight,
  }) {
    return Area(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
    );
  }
}
