// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_state.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';

/// Class to create events
abstract class AppEvent extends Equatable {}

/// Event to initialize the app
class AppCameraInitialized extends AppEvent {
  /// Create an event instance
  AppCameraInitialized({
    required this.cameraLensDirection,
    required this.resolutionCamera,
  });

  /// Camera library [CameraLensDirection]
  final CameraLensDirection cameraLensDirection;

  /// Camera library [ResolutionPreset]
  final ResolutionPreset resolutionCamera;

  @override
  List<Object?> get props => [
        cameraLensDirection,
        resolutionCamera,
      ];
}

/// Event to take a photo
class AppPhotoTaken extends AppEvent {
  /// Create an event instance
  AppPhotoTaken({
    this.minContourArea,
  });

  /// Minimum area to detect a contour
  final double? minContourArea;

  @override
  List<Object?> get props => [
        minContourArea,
      ];
}

/// Event when an image is passed to it
class AppExternalImageContoursFound extends AppEvent {
  /// Create an event instance
  AppExternalImageContoursFound({
    required this.image,
    this.minContourArea,
  });

  /// Image to find contours
  final File image;

  /// Minimum area to detect a contour
  final double? minContourArea;

  @override
  List<Object?> get props => [
        image,
        minContourArea,
      ];
}

/// Event to change the page
class AppPageChanged extends AppEvent {
  /// Create an event instance
  AppPageChanged(this.newPage);

  /// New page to show
  final AppPages newPage;

  @override
  List<Object?> get props => [
        newPage,
      ];
}

/// Event to crop the photo
class AppPhotoCropped extends AppEvent {
  /// Create an event instance
  AppPhotoCropped();

  @override
  List<Object?> get props => [];
}

/// Event to load the cropped photo in page [AppPages.editDocument]
class AppLoadCroppedPhoto extends AppEvent {
  /// Create an event instance
  AppLoadCroppedPhoto({
    required this.image,
    required this.area,
  });

  /// Image to load
  final Uint8List image;

  ///
  final Area area;

  @override
  List<Object?> get props => [
        image,
        area,
      ];
}

/// Event to change the filter type in page [AppPages.editDocument]
class AppFilterApplied extends AppEvent {
  /// Create an event instance
  AppFilterApplied({
    required this.filter,
  });

  /// Filter type to apply
  ///
  /// default: [FilterType.natural]
  final FilterType filter;

  @override
  List<Object?> get props => [
        filter,
      ];
}

///
class AppNewEditedImageLoaded extends AppEvent {
  /// Create an event instance
  AppNewEditedImageLoaded({
    required this.isSuccess,
  });

  ///
  final bool isSuccess;

  @override
  List<Object?> get props => [
        isSuccess,
      ];
}

///
class AppStartedSavingDocument extends AppEvent {
  /// Create an event instance
  AppStartedSavingDocument();

  @override
  List<Object?> get props => [];
}

///
class AppDocumentSaved extends AppEvent {
  /// Create an event instance
  AppDocumentSaved({
    required this.isSuccess,
  });

  ///
  final bool isSuccess;

  @override
  List<Object?> get props => [
        isSuccess,
      ];
}
