// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_document_scanner/src/bloc/app/app.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// Controls interactions throughout the application by means
/// of the [DocumentScannerController]
class AppBloc extends Bloc<AppEvent, AppState> {
  /// Create instance AppBloc
  AppBloc({
    required ImageUtils imageUtils,
  })  : _imageUtils = imageUtils,
        super(AppState.init()) {
    on<AppCameraInitialized>(_cameraInitialized);
    on<AppPhotoTaken>(_photoTaken);
    on<AppExternalImageContoursFound>(_externalImageContoursFound);
    on<AppPageChanged>(_pageChanged);
    on<AppPhotoCropped>(_photoCropped);
    on<AppLoadCroppedPhoto>(_loadCroppedPhoto);
    on<AppFilterApplied>(_filterApplied);
    on<AppNewEditedImageLoaded>(_newEditedImageLoaded);
    on<AppStartedSavingDocument>(_startedSavingDocument);
    on<AppDocumentSaved>(_documentSaved);
  }

  final ImageUtils _imageUtils;

  CameraController? _cameraController;
  late XFile? _pictureTaken;

  /// Initialize [CameraController]
  /// based on the parameters sent by [AppCameraInitialized]
  ///
  /// [AppCameraInitialized.cameraLensDirection] for [CameraLensDirection]
  /// [AppCameraInitialized.resolutionCamera] for the [ResolutionPreset] camera
  Future<void> _cameraInitialized(
    AppCameraInitialized event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusCamera: AppStatus.loading,
      ),
    );

    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == event.cameraLensDirection,
      orElse: () => cameras.first,
    );

    if (_cameraController != null) {
      await _cameraController?.dispose();
      _cameraController = null;
    }

    _cameraController = CameraController(
      camera,
      event.resolutionCamera,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    emit(
      state.copyWith(
        statusCamera: AppStatus.success,
        cameraController: _cameraController,
      ),
    );
  }

  /// Take a photo with the [CameraController.takePicture]
  ///
  /// Then [ImageUtils.findContourPhoto] with the largest area by
  /// [AppPhotoTaken.minContourArea] in the image
  Future<void> _photoTaken(
    AppPhotoTaken event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusTakePhotoPage: AppStatus.loading,
      ),
    );

    if (_cameraController == null) {
      // TODO(bloc): add validation and error handling
      return;
    }

    _pictureTaken = await _cameraController!.takePicture();

    final byteData = await _pictureTaken!.readAsBytes();
    final response = await _imageUtils.findContourPhoto(
      byteData,
      minContourArea: event.minContourArea,
    );

    final fileImage = File(_pictureTaken!.path);

    emit(
      state.copyWith(
        statusTakePhotoPage: AppStatus.success,
        pictureInitial: fileImage,
        contourInitial: response,
      ),
    );

    emit(
      state.copyWith(
        currentPage: AppPages.cropPhoto,
      ),
    );
  }

  /// Find the contour from an external image like gallery
  Future<void> _externalImageContoursFound(
    AppExternalImageContoursFound event,
    Emitter<AppState> emit,
  ) async {
    final externalImage = event.image;

    final byteData = await externalImage.readAsBytes();
    final response = await _imageUtils.findContourPhoto(
      byteData,
      minContourArea: event.minContourArea,
    );

    emit(
      state.copyWith(
        pictureInitial: externalImage,
        contourInitial: response,
      ),
    );

    emit(
      state.copyWith(
        currentPage: AppPages.cropPhoto,
      ),
    );
  }

  /// When changing the page, the state will be initialized.
  Future<void> _pageChanged(
    AppPageChanged event,
    Emitter<AppState> emit,
  ) async {
    switch (event.newPage) {
      case AppPages.takePhoto:
        emit(
          state.copyWith(
            currentPage: event.newPage,
            statusTakePhotoPage: AppStatus.initial,
            statusCropPhoto: AppStatus.initial,
            contourInitial: null,
          ),
        );
        break;

      case AppPages.cropPhoto:
        emit(
          state.copyWith(
            currentPage: event.newPage,
            currentFilterType: FilterType.natural,
          ),
        );
        break;

      case AppPages.editDocument:
        emit(
          state.copyWith(
            currentPage: event.newPage,
            statusEditPhoto: AppStatus.initial,
            statusSavePhotoDocument: AppStatus.initial,
          ),
        );
        break;
    }
  }

  /// It will change the state and
  /// execute the event [CropPhotoByAreaCropped] to crop the image that is in
  /// the [CropBloc].
  Future<void> _photoCropped(
    AppPhotoCropped event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusCropPhoto: AppStatus.loading,
      ),
    );
  }

  /// It will change the state and then change page to [AppPages.editDocument]
  Future<void> _loadCroppedPhoto(
    AppLoadCroppedPhoto event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusCropPhoto: AppStatus.success,
        pictureCropped: event.image,
        contourInitial: event.area,
      ),
    );

    emit(
      state.copyWith(
        currentPage: AppPages.editDocument,
      ),
    );
  }

  /// It will change the state and
  /// execute the event [EditFilterChanged] to crop the image that is
  /// in the [EditBloc].
  Future<void> _filterApplied(
    AppFilterApplied event,
    Emitter<AppState> emit,
  ) async {
    if (event.filter == state.currentFilterType) return;

    emit(
      state.copyWith(
        currentFilterType: event.filter,
        statusEditPhoto: AppStatus.loading,
      ),
    );
  }

  /// It is called when the image filter changes
  Future<void> _newEditedImageLoaded(
    AppNewEditedImageLoaded event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusEditPhoto:
            event.isSuccess ? AppStatus.success : AppStatus.failure,
      ),
    );
  }

  /// It will change the state and
  /// validate if image edited is valid.
  Future<void> _startedSavingDocument(
    AppStartedSavingDocument event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusSavePhotoDocument: AppStatus.loading,
      ),
    );
  }

  /// Change state after saved the document
  Future<void> _documentSaved(
    AppDocumentSaved event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        statusSavePhotoDocument:
            event.isSuccess ? AppStatus.success : AppStatus.failure,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _cameraController?.dispose();
    return super.close();
  }
}
