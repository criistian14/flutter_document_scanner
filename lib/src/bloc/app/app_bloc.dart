import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
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
  }

  CameraController? _cameraController;
  XFile? _pictureTaken;

  @override
  Future<void> close() {
    print("CLOSE APP BLOC");
    return super.close();
  }

  @override
  void onChange(Change<AppState> change) {
    print(change.nextState.statusCropPhoto);
    print(change.nextState.pictureCropped);
    super.onChange(change);
  }

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

    await Future.delayed(const Duration(seconds: 3)); // TODO: Remover

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
    final response = await _imageUtils.findContourPhoto(byteData);

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
    emit(state.copyWith(
      currentPage: event.newPage,
      statusTakePhotoPage: AppStatus.initial,
      statusCropPhoto: AppStatus.initial,
    ));
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
}
