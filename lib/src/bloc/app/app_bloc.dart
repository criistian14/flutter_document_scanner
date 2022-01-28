import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState().init()) {
    on<AppCameraInitialized>(_cameraInitialized);
    on<AppPhotoTaken>(_photoTaken);
    on<AppPageChanged>(_pageChanged);
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
    // await Future.delayed(const Duration(seconds: 3)); // TODO: Remover

    if (_cameraController == null) {
      // TODO: agregar validacion
      return;
    }

    final appDir = await getTemporaryDirectory();
    _pictureTaken = await _cameraController!.takePicture();

    emit(state.copyWith(
      statusTakePhotoPage: AppStatus.success,
      currentPage: AppPages.cropPhoto,
    ));
  }

  Future<void> _pageChanged(
    AppPageChanged event,
    Emitter<AppState> emit,
  ) async {
    emit(state.copyWith(
      currentPage: event.newPage,
      statusTakePhotoPage: AppStatus.initial,
    ));
  }
}
