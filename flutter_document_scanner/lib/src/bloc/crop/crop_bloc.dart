// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop_event.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop_state.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/utils/dot_utils.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// Control everything related to image cropping and perspective adjustment
class CropBloc extends Bloc<CropEvent, CropState> {
  /// Create an instance of the bloc
  CropBloc({
    required DotUtils dotUtils,
    required ImageUtils imageUtils,
  })  : _dotUtils = dotUtils,
        _imageUtils = imageUtils,
        super(CropState.init()) {
    on<CropAreaInitialized>(_areaInitialized);
    on<CropDotMoved>(_dotMoved);
    on<CropPhotoByAreaCropped>(_photoByAreaCropped);
  }

  final DotUtils _dotUtils;
  final ImageUtils _imageUtils;

  late Rect _imageRect;

  /// Screen size by adjusting the screen image position
  late Size newScreenSize;

  /// Position the dots according to the
  /// sent contour [CropAreaInitialized.areaInitial]
  Future<void> _areaInitialized(
    CropAreaInitialized event,
    Emitter<CropState> emit,
  ) async {
    newScreenSize = Size(
      (event.screenSize.width - event.positionImage.left) -
          event.positionImage.right,
      (event.screenSize.height - event.positionImage.top) -
          event.positionImage.bottom,
    );

    _imageRect = _imageUtils.imageRect(
      newScreenSize,
    );

    Area area = event.defaultAreaInitial;

    if (event.areaInitial != null) {
      final imageDecoded = await decodeImageFromList(
        event.image.readAsBytesSync(),
      );

      final scalingFactorY = newScreenSize.height / imageDecoded.height;
      final scalingFactorX = newScreenSize.width / imageDecoded.width;

      area = Area(
        topRight: Point(
          event.areaInitial!.topRight.x * scalingFactorX,
          event.areaInitial!.topRight.y * scalingFactorY,
        ),
        topLeft: Point(
          event.areaInitial!.topLeft.x * scalingFactorX,
          event.areaInitial!.topLeft.y * scalingFactorY,
        ),
        bottomLeft: Point(
          event.areaInitial!.bottomLeft.x * scalingFactorX,
          event.areaInitial!.bottomLeft.y * scalingFactorY,
        ),
        bottomRight: Point(
          event.areaInitial!.bottomRight.x * scalingFactorX,
          event.areaInitial!.bottomRight.y * scalingFactorY,
        ),
      );
    }

    emit(
      state.copyWith(
        area: area,
      ),
    );
  }

  /// Move dot and update cutting area
  Future<void> _dotMoved(
    CropDotMoved event,
    Emitter<CropState> emit,
  ) async {
    Area newArea;

    switch (event.dotPosition) {
      case DotPosition.topRight:
        final result = _dotUtils.moveTopRight(
          original: state.area.topRight,
          deltaX: event.deltaX,
          deltaY: event.deltaY,
          imageRect: _imageRect,
          originalArea: state.area,
        );

        newArea = state.area.copyWith(
          topRight: result,
        );
        break;

      case DotPosition.topLeft:
        final result = _dotUtils.moveTopLeft(
          original: state.area.topLeft,
          deltaX: event.deltaX,
          deltaY: event.deltaY,
          imageRect: _imageRect,
          originalArea: state.area,
        );

        newArea = state.area.copyWith(
          topLeft: result,
        );
        break;

      case DotPosition.bottomRight:
        final result = _dotUtils.moveBottomRight(
          original: state.area.bottomRight,
          deltaX: event.deltaX,
          deltaY: event.deltaY,
          imageRect: _imageRect,
          originalArea: state.area,
        );

        newArea = state.area.copyWith(
          bottomRight: result,
        );
        break;

      case DotPosition.bottomLeft:
        final result = _dotUtils.moveBottomLeft(
          original: state.area.bottomLeft,
          deltaX: event.deltaX,
          deltaY: event.deltaY,
          imageRect: _imageRect,
          originalArea: state.area,
        );

        newArea = state.area.copyWith(
          bottomLeft: result,
        );
        break;

      case DotPosition.all:
        newArea = _dotUtils.moveArea(
          original: state.area,
          deltaX: event.deltaX,
          deltaY: event.deltaY,
          imageRect: _imageRect,
        );

        break;
    }

    emit(
      state.copyWith(
        area: newArea,
      ),
    );
  }

  /// Crop the image and then adjust the perspective
  ///
  /// lastly change the page
  Future<void> _photoByAreaCropped(
    CropPhotoByAreaCropped event,
    Emitter<CropState> emit,
  ) async {
    final imageDecoded = await decodeImageFromList(
      event.image.readAsBytesSync(),
    );

    final scalingFactorY = imageDecoded.height / newScreenSize.height;
    final scalingFactorX = imageDecoded.width / newScreenSize.width;

    final area = Area(
      topRight: Point(
        state.area.topRight.x * scalingFactorX,
        state.area.topRight.y * scalingFactorY,
      ),
      topLeft: Point(
        state.area.topLeft.x * scalingFactorX,
        state.area.topLeft.y * scalingFactorY,
      ),
      bottomLeft: Point(
        state.area.bottomLeft.x * scalingFactorX,
        state.area.bottomLeft.y * scalingFactorY,
      ),
      bottomRight: Point(
        state.area.bottomRight.x * scalingFactorX,
        state.area.bottomRight.y * scalingFactorY,
      ),
    );

    final contour = Contour(
      points: [
        area.topLeft,
        area.topRight,
        area.bottomRight,
        area.bottomLeft,
      ],
    );

    final response = await _imageUtils.adjustingPerspective(
      event.image.readAsBytesSync(),
      contour,
    );

    emit(
      state.copyWith(
        imageCropped: response ?? event.image.readAsBytesSync(),
        areaParsed: area,
      ),
    );
  }
}
