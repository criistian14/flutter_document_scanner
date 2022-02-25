import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';

abstract class CropEvent extends Equatable {}

class CropAreaInitialized extends CropEvent {
  final Area? areaInitial;
  final Area defaultAreaInitial;
  final File image;
  final Size screenSize;
  final Rect positionImage;

  CropAreaInitialized({
    this.areaInitial,
    required this.image,
    required this.screenSize,
    required this.positionImage,
    required this.defaultAreaInitial,
  });

  @override
  List<Object?> get props => [
        areaInitial,
        image,
        screenSize,
        positionImage,
      ];
}

enum DotPosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
  all,
}

class CropDotMoved extends CropEvent {
  final double deltaX;
  final double deltaY;
  final DotPosition dotPosition;

  CropDotMoved({
    required this.deltaX,
    required this.deltaY,
    required this.dotPosition,
  });

  @override
  List<Object?> get props => [
        deltaX,
        deltaY,
        dotPosition,
      ];
}

class CropPhotoByAreaCropped extends CropEvent {
  final File image;

  CropPhotoByAreaCropped(this.image);

  @override
  List<Object?> get props => [image];
}
