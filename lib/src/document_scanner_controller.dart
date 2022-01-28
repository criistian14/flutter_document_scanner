import 'dart:async';

import 'package:flutter_document_scanner/src/bloc/app/app_state.dart';

import 'bloc/app/app_bloc.dart';
import 'bloc/app/app_event.dart';

class DocumentScannerController {
  AppBloc? _appBloc;

  set bloc(AppBloc bloc) => _appBloc = bloc;

  // * Streams
  Stream<AppStatus> get statusTakePhotoPage {
    if (_appBloc == null) return const Stream.empty();

    return _appBloc!.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data.statusTakePhotoPage),
      ),
    );
  }

  ///
  Future<void> takePhoto() async {
    _appBloc!.add(AppPhotoTaken());
  }

  ///
  Future<void> changePage(AppPages page) async {
    _appBloc!.add(AppPageChanged(page));
  }
}
