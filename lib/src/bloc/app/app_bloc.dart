import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_document_scanner/src/models/filter_type.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final ImageUtils _imageUtils;

  AppBloc({
    required ImageUtils imageUtils,
  })  : _imageUtils = imageUtils,
        super(AppState.init()) {
    on<AppCameraInitialized>(_cameraInitialized);
    on<AppPhotoTaken>(_photoTaken);
    on<AppPageChanged>(_pageChanged);
    on<AppPhotoCropped>(_photoCropped);
    on<AppLoadCroppedPhoto>(_loadCroppedPhoto);
    on<AppFilterApplied>(_filterApplied);
    on<AppNewEditedImageLoaded>(_newEditedImageLoaded);
    on<AppStartedSavingDocument>(_startedSavingDocument);
    on<AppDocumentSaved>(_documentSaved);
  }

  CameraController? _cameraController;
  XFile? _pictureTaken;

  ///
  void _cameraInitialized(
    AppCameraInitialized event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusCamera: AppStatus.loading,
    ));

    List<CameraDescription> cameras = await availableCameras();
    CameraDescription camera = cameras.firstWhere(
      (camera) => camera.lensDirection == event.cameraLensDirection,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      event.resolutionCamera,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    emit(state.copyWith(
      statusCamera: AppStatus.success,
      cameraController: _cameraController,
    ));
  }

  ///
  Future<void> _photoTaken(
    AppPhotoTaken event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusTakePhotoPage: AppStatus.loading,
    ));

    if (_cameraController == null) {
      // TODO: agregar validacion
      return;
    }

    _pictureTaken = await _cameraController!.takePicture();

    final byteData = await _pictureTaken!.readAsBytes();
    final response = await _imageUtils.findContourPhoto(
      byteData,
      minContourArea: event.minContourArea,
    );

    final fileImage = File(_pictureTaken!.path);

    emit(state.copyWith(
      statusTakePhotoPage: AppStatus.success,
      pictureInitial: fileImage,
      contourInitial: response,
    ));

    emit(state.copyWith(
      currentPage: AppPages.cropPhoto,
    ));
  }

  ///
  Future<void> _pageChanged(
    AppPageChanged event,
    Emitter<AppState> emit,
  ) async {
    switch (event.newPage) {
      case AppPages.takePhoto:
        emit(state.copyWith(
          currentPage: event.newPage,
          statusTakePhotoPage: AppStatus.initial,
          statusCropPhoto: AppStatus.initial,
          contourInitial: null,
        ));
        break;

      case AppPages.cropPhoto:
        emit(state.copyWith(
          currentPage: event.newPage,
          currentFilterType: FilterType.natural,
        ));
        break;

      case AppPages.editDocument:
        emit(state.copyWith(
          currentPage: event.newPage,
          statusEditPhoto: AppStatus.initial,
          statusSavePhotoDocument: AppStatus.initial,
        ));
        break;
    }
  }

  ///
  Future<void> _photoCropped(
    AppPhotoCropped event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusCropPhoto: AppStatus.loading,
    ));
  }

  ///
  Future<void> _loadCroppedPhoto(
    AppLoadCroppedPhoto event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusCropPhoto: AppStatus.success,
      pictureCropped: event.image,
      contourInitial: event.area,
    ));

    emit(state.copyWith(
      currentPage: AppPages.editDocument,
    ));
  }

  ///
  Future<void> _filterApplied(
    AppFilterApplied event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      currentFilterType: event.filter,
      statusEditPhoto: AppStatus.loading,
    ));
  }

  ///
  Future<void> _newEditedImageLoaded(
    AppNewEditedImageLoaded event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusEditPhoto: event.isSucces ? AppStatus.success : AppStatus.failure,
    ));
  }

  ///
  Future<void> _startedSavingDocument(
    AppStartedSavingDocument event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusSavePhotoDocument: AppStatus.loading,
    ));
  }

  ///
  Future<void> _documentSaved(
    AppDocumentSaved event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      statusSavePhotoDocument:
          event.isSucces ? AppStatus.success : AppStatus.failure,
    ));
  }
}
