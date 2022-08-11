// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_event.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_state.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

/// Control image editing and filter application
class EditBloc extends Bloc<EditEvent, EditState> {
  /// Create an instance of the bloc
  EditBloc({
    required ImageUtils imageUtils,
  })  : _imageUtils = imageUtils,
        super(EditState.init()) {
    on<EditStarted>(_started);
    on<EditFilterChanged>(_filterChanged);
  }

  final ImageUtils _imageUtils;

  /// Base image in case of undoing a filter
  late Uint8List imageBase;

  /// Load cropped image from previous page
  Future<void> _started(
    EditStarted event,
    Emitter<EditState> emit,
  ) async {
    imageBase = event.image;

    emit(
      state.copyWith(
        image: event.image,
      ),
    );
  }

  /// Apply [FilterType] with OpenCV library
  Future<void> _filterChanged(
    EditFilterChanged event,
    Emitter<EditState> emit,
  ) async {
    final newImage = await _imageUtils.applyFilter(imageBase, event.filter);

    emit(
      state.copyWith(
        image: newImage,
      ),
    );
  }
}
