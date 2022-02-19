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
    // _imageRect = Rect.fromLTWH(
    //   event.positionImage.left,
    //   event.positionImage.top,
    //   event.screenSize.width -
    //       (event.positionImage.left + event.positionImage.right),
    //   event.screenSize.height -
    //       (event.positionImage.top + event.positionImage.bottom),
    // );

    final imageDecoded = await decodeImageFromList(
      event.image.readAsBytesSync(),
    );

    _imageRect = _imageUtils.imageRect(
      event.screenSize,
      imageDecoded.width,
      imageDecoded.height,
    );

    // Area area = Area(
    //   topLeft: const Point(
    //     90,
    //     170,
    //   ),
    //   topRight: Point(
    //     event.screenSize.width - 60,
    //     120,
    //   ),
    //   bottomLeft: Point(
    //     60,
    //     event.screenSize.height - 100,
    //   ),
    //   bottomRight: Point(
    //     event.screenSize.width - 170,
    //     event.screenSize.height - 100,
    //   ),
    // );

    Area area = Area(
      topLeft: const Point(0, 0),
      topRight: Point(event.screenSize.width, 0),
      bottomLeft: Point(0, event.screenSize.height),
      bottomRight: Point(event.screenSize.width, event.screenSize.height),
    );

    if (event.area != null) {
      final imageRatio = imageDecoded.width / imageDecoded.height;
      final imageScreenWidth = event.screenSize.height * imageRatio;
      final left = (event.screenSize.width - imageScreenWidth) / 2;
      final right = left + imageScreenWidth;

      // y = 4
      // x =
      print(left);
      print(right);
      print(imageScreenWidth);

      // area = Area(
      //   topLeft: null,
      //   bottomRight: null,
      //   bottomLeft: null,
      //   topRight: null,
      // );
    }

    // final rect = imageRect(
    //   screenSize,
    //   imageDecoded.width,
    //   imageDecoded.height,
    // );

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
