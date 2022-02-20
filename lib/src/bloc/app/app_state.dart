import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/contour.dart';

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
  final Contour? contourInitial;

  const AppState({
    this.currentPage = AppPages.takePhoto,
    this.statusCamera = AppStatus.initial,
    this.cameraController,
    this.statusTakePhotoPage = AppStatus.initial,
    this.pictureInitial,
    this.statusCropPhoto = AppStatus.initial,
    this.contourInitial,
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
        contourInitial,
      ];

  AppState copyWith({
    AppPages? currentPage,
    AppStatus? statusCamera,
    CameraController? cameraController,
    AppStatus? statusTakePhotoPage,
    File? pictureInitial,
    AppStatus? statusCropPhoto,
    Contour? contourInitial,
  }) {
    return AppState(
      currentPage: currentPage ?? this.currentPage,
      statusCamera: statusCamera ?? this.statusCamera,
      cameraController: cameraController ?? this.cameraController,
      statusTakePhotoPage: statusTakePhotoPage ?? this.statusTakePhotoPage,
      pictureInitial: pictureInitial ?? this.pictureInitial,
      statusCropPhoto: statusCropPhoto ?? this.statusCropPhoto,
      contourInitial: contourInitial ?? this.contourInitial,
    );
  }
}
