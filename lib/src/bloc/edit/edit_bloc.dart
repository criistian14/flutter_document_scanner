import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  final ImageUtils _imageUtils;

  EditBloc({
    required ImageUtils imageUtils,
  })  : _imageUtils = imageUtils,
        super(EditState.init()) {
    on<EditStarted>(_started);
    on<EditFilterChanged>(_filterChanged);
  }

  late Uint8List imageBase;

  ///
  Future<void> _started(
    EditStarted event,
    Emitter<EditState> emit,
  ) async {
    imageBase = event.image;

    emit(state.copyWith(
      image: event.image,
    ));
  }

  ///
  Future<void> _filterChanged(
    EditFilterChanged event,
    Emitter<EditState> emit,
  ) async {
    final newImage = await _imageUtils.applyFilter(imageBase, event.filter);

    emit(state.copyWith(
      image: newImage,
    ));
  }
}
