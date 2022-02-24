import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/contour.dart';

abstract class CropEvent extends Equatable {}

class CropAreaInitialized extends CropEvent {
  final Contour? contour;
  final File image;
  final Size screenSize;
  final Rect positionImage;

  CropAreaInitialized({
    this.contour,
    required this.image,
    required this.screenSize,
    required this.positionImage,
  });

  @override
  List<Object?> get props => [
        contour,
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
  @override
  List<Object?> get props => [];
}
