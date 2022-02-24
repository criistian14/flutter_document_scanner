import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/utils/dot_utils.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

import 'crop_event.dart';
import 'crop_state.dart';

class CropBloc extends Bloc<CropEvent, CropState> {
  final DotUtils _dotUtils;
  final ImageUtils _imageUtils;

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

  late Rect _imageRect;

  ///
  Future<void> _areaInitialized(
    CropAreaInitialized event,
    Emitter<CropState> emit,
  ) async {
    final newScreenSize = Size(
      (event.screenSize.width - event.positionImage.left) -
          event.positionImage.right,
      (event.screenSize.height - event.positionImage.top) -
          event.positionImage.bottom,
    );

    _imageRect = _imageUtils.imageRect(
      newScreenSize,
    );

    Area area = Area(
      topLeft: const Point(
        90,
        170,
      ),
      topRight: Point(
        newScreenSize.width - 60,
        120,
      ),
      bottomLeft: Point(
        60,
        newScreenSize.height - 100,
      ),
      bottomRight: Point(
        newScreenSize.width - 170,
        newScreenSize.height - 100,
      ),
    );

    if (event.contour != null) {
      final imageDecoded = await decodeImageFromList(
        event.image.readAsBytesSync(),
      );

      final scalingFactorY = newScreenSize.height / imageDecoded.height;
      final scalingFactorX = newScreenSize.width / imageDecoded.width;

      area = Area(
        topRight: Point(
          event.contour!.points[0].x * scalingFactorX,
          event.contour!.points[0].y * scalingFactorY,
        ),
        topLeft: Point(
          event.contour!.points[1].x * scalingFactorX,
          event.contour!.points[1].y * scalingFactorY,
        ),
        bottomLeft: Point(
          event.contour!.points[2].x * scalingFactorX,
          event.contour!.points[2].y * scalingFactorY,
        ),
        bottomRight: Point(
          event.contour!.points[3].x * scalingFactorX,
          event.contour!.points[3].y * scalingFactorY,
        ),
      );
    }

    emit(state.copyWith(
      area: area,
    ));
  }

  ///
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

  ///
  Future<void> _photoByAreaCropped(
    CropPhotoByAreaCropped event,
    Emitter<CropState> emit,
  ) async {}
}
