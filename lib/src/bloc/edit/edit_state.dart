import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class EditState extends Equatable {
  final Uint8List? image;

  const EditState({
    this.image,
  });

  @override
  List<Object?> get props => [
        image,
      ];

  factory EditState.init() {
    return const EditState();
  }

  EditState copyWith({
    Uint8List? image,
  }) {
    return EditState(
      image: image ?? this.image,
    );
  }
}
