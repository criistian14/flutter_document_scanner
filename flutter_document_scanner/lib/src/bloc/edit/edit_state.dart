// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class EditState extends Equatable {
  const EditState({
    this.image,
  });

  factory EditState.init() {
    return const EditState();
  }

  final Uint8List? image;

  @override
  List<Object?> get props => [
        image,
      ];

  /// Creates a copy of this state but with the given fields replaced with
  /// the new values.
  EditState copyWith({
    Uint8List? image,
  }) {
    return EditState(
      image: image ?? this.image,
    );
  }
}
