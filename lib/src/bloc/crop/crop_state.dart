import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

class CropState extends Equatable {
  final Area area;
  final Uint8List? imageCropped;
  final Area? areaParsed;

  const CropState({
    required this.area,
    this.imageCropped,
    this.areaParsed,
  });

  @override
  List<Object?> get props => [
        area,
        imageCropped,
        areaParsed,
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
    Uint8List? imageCropped,
    Area? areaParsed,
  }) {
    return CropState(
      area: area ?? this.area,
      imageCropped: imageCropped ?? this.imageCropped,
      areaParsed: areaParsed ?? this.areaParsed,
    );
  }
}
