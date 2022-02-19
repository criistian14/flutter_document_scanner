import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class CropState extends Equatable {
  final Area area;

  const CropState({
    required this.area,
  });

  @override
  List<Object?> get props => [
        area,
      ];

  factory CropState.init() {
    return const CropState(
      area: Area(
        topRight: Point(10, 10),
        bottomLeft: Point(10, 10),
        topLeft: Point(10, 10),
        bottomRight: Point(10, 10),
      ),
    );
  }

  CropState copyWith({
    Area? area,
  }) {
    return CropState(
      area: area ?? this.area,
    );
  }
}
