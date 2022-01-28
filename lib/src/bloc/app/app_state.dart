import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

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

  const AppState({
    this.currentPage = AppPages.takePhoto,
    this.statusCamera = AppStatus.initial,
    this.cameraController,
    this.statusTakePhotoPage = AppStatus.initial,
  });

  AppState init() {
    return const AppState();
  }

  AppState copyWith({
    AppPages? currentPage,
    AppStatus? statusCamera,
    CameraController? cameraController,
    AppStatus? statusTakePhotoPage,
  }) {
    return AppState(
      currentPage: currentPage ?? this.currentPage,
      statusCamera: statusCamera ?? this.statusCamera,
      cameraController: cameraController ?? this.cameraController,
      statusTakePhotoPage: statusTakePhotoPage ?? this.statusTakePhotoPage,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        statusCamera,
        cameraController,
        statusTakePhotoPage,
      ];
}
