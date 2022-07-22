// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_document_scanner/src/models/filter_type.dart';

abstract class EditEvent extends Equatable {}

class EditStarted extends EditEvent {
  final Uint8List image;

  EditStarted(this.image);

  @override
  List<Object?> get props => [
        image,
      ];
}

class EditFilterChanged extends EditEvent {
  final FilterType filter;

  EditFilterChanged(this.filter);

  @override
  List<Object?> get props => [
        filter,
      ];
}
