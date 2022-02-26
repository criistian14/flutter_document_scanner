import 'dart:async';

import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

import 'bloc/app/app_bloc.dart';
import 'bloc/app/app_event.dart';

class DocumentScannerController {
  final AppBloc _appBloc = AppBloc(
    imageUtils: ImageUtils(),
  );

  AppBloc get bloc => _appBloc;

  // * Streams
  Stream<AppStatus> get statusTakePhotoPage {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusTakePhotoPage),
      ),
    );
  }

  Stream<AppStatus> get statusCropPhoto {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusCropPhoto),
      ),
    );
  }

  Stream<AppStatus> get statusEditPhoto {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusEditPhoto),
      ),
    );
  }

  Stream<FilterType> get currentFilterType {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.currentFilterType),
      ),
    );
  }

  Stream<AppStatus> get statusSavePhotoDocument {
    return _appBloc.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusSavePhotoDocument),
      ),
    );
  }

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

  ///
  Future<void> changePage(AppPages page) async {
    _appBloc.add(AppPageChanged(page));
  }

  ///
  Future<void> cropPhoto() async {
    _appBloc.add(AppPhotoCropped());
  }

  ///
  Future<void> applyFilter(FilterType type) async {
    _appBloc.add(AppFilterApplied(filter: type));
  }

  ///
  Future<void> savePhotoDocument() async {
    _appBloc.add(AppStartedSavingDocument());
  }
}
