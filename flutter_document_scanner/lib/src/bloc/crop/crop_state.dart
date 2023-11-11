// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

/// Controls the status when cropping the image
class CropState extends Equatable {
  /// Create an state instance
  const CropState({
    required this.area,
    this.imageCropped,
    this.areaParsed,
  });

  /// Initial state
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

  /// The area to crop the image
  final Area area;

  /// The cropped image
  final Uint8List? imageCropped;

  /// The area is parsed based on the resolution of the original image
  final Area? areaParsed;

  @override
  List<Object?> get props => [
        area,
        imageCropped,
        areaParsed,
      ];

  /// Creates a copy of this state but with the given fields replaced with
  /// the new values.
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
