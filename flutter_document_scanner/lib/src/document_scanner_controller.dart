// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

import 'bloc/app/app_bloc.dart';
import 'bloc/app/app_event.dart';

class DocumentScannerController {
  final AppBloc _appBloc = AppBloc(
    imageUtils: ImageUtils(),
  );

  AppBloc get bloc => _appBloc;

  /// Stream [AppStatus] to know the status while taking the picture
  Stream<AppStatus> get statusTakePhotoPage {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusTakePhotoPage),
      ),
    );
  }

  /// Stream [AppStatus] to know the status while the document is being cropped
  Stream<AppStatus> get statusCropPhoto {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusCropPhoto),
      ),
    );
  }

  /// Stream [AppStatus] to know the status while editing the document with filters
  Stream<AppStatus> get statusEditPhoto {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusEditPhoto),
      ),
    );
  }

  /// Stream [FilterType] the current filtering of the document
  Stream<FilterType> get currentFilterType {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.currentFilterType),
      ),
    );
  }

  /// Stream [AppStatus] to know the status while saving the document
  /// with all filters and cropping area
  Stream<AppStatus> get statusSavePhotoDocument {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusSavePhotoDocument),
      ),
    );
  }

  /// Will return the picture taken on the [TakePhotoDocumentPage].
  File? get pictureTaken => _appBloc.state.pictureInitial;

  /// Will return the picture cropped on the [CropPhotoDocumentPage].
  Uint8List? get pictureCropped => _appBloc.state.pictureCropped;

  /// Taking the photo
  ///
  /// Then find  the contour with the largest area only when it exceeds [minContourArea]
  ///
  /// [minContourArea] is default 80000.0
  Future<void> takePhoto({
    double? minContourArea,
  }) async {
    _appBloc.add(AppPhotoTaken(
      minContourArea: minContourArea,
    ));
  }

  /// Change current page by [AppPages]
  Future<void> changePage(AppPages page) async {
    _appBloc.add(AppPageChanged(page));
  }

  /// Cutting the photo and adjusting the perspective
  /// then change page to [AppPages.editDocument]
  Future<void> cropPhoto() async {
    _appBloc.add(AppPhotoCropped());
  }

  /// Apply [FilterType] using OpenCV
  Future<void> applyFilter(FilterType type) async {
    _appBloc.add(AppFilterApplied(filter: type));
  }

  /// Save the document with filter and cropping area
  /// It will return it as [Uint8List] in [DocumentScanner]
  Future<void> savePhotoDocument() async {
    _appBloc.add(AppStartedSavingDocument());
  }
}
