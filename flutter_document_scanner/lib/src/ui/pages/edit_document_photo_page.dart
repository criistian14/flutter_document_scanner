// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_event.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_event.dart';
import 'package:flutter_document_scanner/src/bloc/edit/edit_state.dart';
import 'package:flutter_document_scanner/src/ui/widgets/app_bar_edit_photo.dart';
import 'package:flutter_document_scanner/src/ui/widgets/bottom_bar_edit_photo.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_document_scanner/src/utils/model_utils.dart';

/// Page to edit a photo
class EditDocumentPhotoPage extends StatelessWidget {
  /// Create a page with style
  const EditDocumentPhotoPage({
    super.key,
    required this.editPhotoDocumentStyle,
    required this.onSave,
  });

  /// Style of the page
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  /// Callback to save the photo
  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: BlocSelector<AppBloc, AppState, Uint8List?>(
        selector: (state) => state.pictureCropped,
        builder: (context, state) {
          if (state == null) {
            return const Center(
              child: Text('NO IMAGE'),
            );
          }

          return BlocProvider(
            create: (context) => EditBloc(
              imageUtils: ImageUtils(),
            )..add(EditStarted(state)),
            child: _EditView(
              editPhotoDocumentStyle: editPhotoDocumentStyle,
              onSave: onSave,
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    await context
        .read<DocumentScannerController>()
        .changePage(AppPages.cropPhoto);
    return false;
  }
}

class _EditView extends StatelessWidget {
  const _EditView({
    required this.editPhotoDocumentStyle,
    required this.onSave,
  });

  final EditPhotoDocumentStyle editPhotoDocumentStyle;
  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              current.currentFilterType != previous.currentFilterType,
          listener: (context, state) {
            context
                .read<EditBloc>()
                .add(EditFilterChanged(state.currentFilterType));
          },
        ),
        BlocListener<AppBloc, AppState>(
          listenWhen: (previous, current) =>
              current.statusSavePhotoDocument !=
              previous.statusSavePhotoDocument,
          listener: (context, state) {
            if (state.statusSavePhotoDocument == AppStatus.loading) {
              final image = context.read<EditBloc>().state.image;
              if (image == null) {
                context.read<AppBloc>().add(
                      AppDocumentSaved(
                        isSuccess: false,
                      ),
                    );
                return;
              }

              context.read<AppBloc>().add(
                    AppDocumentSaved(
                      isSuccess: true,
                    ),
                  );
              onSave(image);
            }
          },
        ),
        BlocListener<EditBloc, EditState>(
          listenWhen: (previous, current) =>
              current.image != previous.image && previous.image != null,
          listener: (context, state) {
            if (state.image != null) {
              context.read<AppBloc>().add(
                    AppNewEditedImageLoaded(
                      isSuccess: true,
                    ),
                  );
            }
          },
        ),
      ],
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: editPhotoDocumentStyle.top,
            left: editPhotoDocumentStyle.left,
            right: editPhotoDocumentStyle.right,
            bottom: editPhotoDocumentStyle.bottom,
            child: BlocSelector<EditBloc, EditState, Uint8List?>(
              selector: (state) => state.image,
              builder: (context, image) {
                if (image == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Image.memory(
                  image,
                );
              },
            ),
          ),

          // * Default App Bar
          AppBarEditPhoto(
            editPhotoDocumentStyle: editPhotoDocumentStyle,
          ),

          // * Default Bottom Bar
          BottomBarEditPhoto(
            editPhotoDocumentStyle: editPhotoDocumentStyle,
          ),

          // * children
          if (editPhotoDocumentStyle.children != null)
            ...editPhotoDocumentStyle.children!,
        ],
      ),
    );
  }
}
