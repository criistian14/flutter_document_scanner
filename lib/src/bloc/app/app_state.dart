import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/models/filter_type.dart';
import 'package:flutter_document_scanner/src/utils/model_utils.dart';

enum AppStatus {
  initial,
  loading,
  success,
  failure,
}

enum AppPages {
  takePhoto,
  cropPhoto,
  editDocument,
}

class AppState extends Equatable {
  final AppPages currentPage;
  final AppStatus statusCamera;
  final CameraController? cameraController;
  final AppStatus statusTakePhotoPage;
  final File? pictureInitial;
  final AppStatus statusCropPhoto;
  final Area? contourInitial;
  final Uint8List? pictureCropped;
  final AppStatus statusEditPhoto;
  final FilterType currentFilterType;
  final AppStatus statusSavePhotoDocument;

  const AppState({
    this.currentPage = AppPages.takePhoto,
    this.statusCamera = AppStatus.initial,
    this.cameraController,
    this.statusTakePhotoPage = AppStatus.initial,
    this.pictureInitial,
    this.statusCropPhoto = AppStatus.initial,
    this.contourInitial,
    this.pictureCropped,
    this.statusEditPhoto = AppStatus.initial,
    this.currentFilterType = FilterType.natural,
    this.statusSavePhotoDocument = AppStatus.initial,
  });

  factory AppState.init() {
    return const AppState();
  }

  @override
  List<Object?> get props => [
        currentPage,
        statusCamera,
        cameraController,
        statusTakePhotoPage,
        pictureInitial,
        statusCropPhoto,
        contourInitial,
        pictureCropped,
        statusEditPhoto,
        currentFilterType,
        statusSavePhotoDocument,
      ];

  AppState copyWith({
    AppPages? currentPage,
    AppStatus? statusCamera,
    CameraController? cameraController,
    AppStatus? statusTakePhotoPage,
    File? pictureInitial,
    AppStatus? statusCropPhoto,
    Object? contourInitial = valueNull,
    Uint8List? pictureCropped,
    AppStatus? statusEditPhoto,
    FilterType? currentFilterType,
    AppStatus? statusSavePhotoDocument,
  }) {
    return AppState(
      currentPage: currentPage ?? this.currentPage,
      statusCamera: statusCamera ?? this.statusCamera,
      cameraController: cameraController ?? this.cameraController,
      statusTakePhotoPage: statusTakePhotoPage ?? this.statusTakePhotoPage,
      pictureInitial: pictureInitial ?? this.pictureInitial,
      statusCropPhoto: statusCropPhoto ?? this.statusCropPhoto,
      contourInitial: contourInitial == valueNull
          ? this.contourInitial
          : contourInitial as Area?,
      pictureCropped: pictureCropped ?? this.pictureCropped,
      statusEditPhoto: statusEditPhoto ?? this.statusEditPhoto,
      currentFilterType: currentFilterType ?? this.currentFilterType,
      statusSavePhotoDocument:
          statusSavePhotoDocument ?? this.statusSavePhotoDocument,
    );
  }
}
