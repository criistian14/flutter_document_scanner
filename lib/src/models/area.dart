import 'dart:math';

import 'package:equatable/equatable.dart';

class Area extends Equatable {
  final Point<double> topLeft;
  final Point<double> topRight;
  final Point<double> bottomLeft;
  final Point<double> bottomRight;

  const Area({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  @override
  List<Object?> get props => [
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
      ];

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
