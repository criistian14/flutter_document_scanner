// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_event.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_state.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';
import 'package:flutter_document_scanner/src/utils/crop_photo_document_style.dart';
import 'package:flutter_document_scanner/src/utils/dialogs.dart';
import 'package:flutter_document_scanner/src/utils/edit_photo_document_style.dart';
import 'package:flutter_document_scanner/src/utils/general_styles.dart';
import 'package:flutter_document_scanner/src/utils/model_utils.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

import 'crop_photo_document_page.dart';
import 'edit_document_photo_page.dart';
import 'take_photo_document_page.dart';

class DocumentScanner extends StatelessWidget {
  const DocumentScanner({
    super.key,
    this.controller,
    this.generalStyles = const GeneralStyles(),
    this.pageTransitionBuilder,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.resolutionCamera = ResolutionPreset.high,
    this.takePhotoDocumentStyle = const TakePhotoDocumentStyle(),
    this.cropPhotoDocumentStyle = const CropPhotoDocumentStyle(),
    this.editPhotoDocumentStyle = const EditPhotoDocumentStyle(),
    required this.onSave,
  });

  /// Controller to execute the different functionalities using the [DocumentScannerController]
  final DocumentScannerController? controller;

  /// [generalStyles] is the [GeneralStyles] that will be used to style the
  /// [DocumentScanner] widget.
  final GeneralStyles generalStyles;

  /// To change the animation performed when switching between screens
  /// by using the [AnimatedSwitcherTransitionBuilder]
  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;

  /// Config Camera
  final CameraLensDirection initialCameraLensDirection;
  final ResolutionPreset resolutionCamera;

  /// It is used to change the style of the [TakePhotoDocumentPage] page
  /// using the [TakePhotoDocumentStyle] class.
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  /// It is used to change the style of the [CropPhotoDocumentPage] page
  /// using the [CropPhotoDocumentStyle] class.
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  /// It is used to change the style of the [EditDocumentPhotoPage] page
  /// using the [EditPhotoDocumentStyle] class.
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  /// After performing the whole process of capturing the document
  /// It will return it as [Uint8List].
  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    final Dialogs dialogs = Dialogs();

    DocumentScannerController _controller = DocumentScannerController();
    if (controller != null) {
      _controller = controller!;
    }

    return BlocProvider(
      create: (BuildContext context) => _controller.bloc
        ..add(
          AppCameraInitialized(
            cameraLensDirection: initialCameraLensDirection,
            resolutionCamera: resolutionCamera,
          ),
        ),
      child: RepositoryProvider<DocumentScannerController>(
        create: (context) => _controller,
        child: MultiBlocListener(
          listeners: [
            // ? Show default dialogs in Take Photo
            BlocListener<AppBloc, AppState>(
              listenWhen: (previous, current) =>
                  current.statusTakePhotoPage != previous.statusTakePhotoPage,
              listener: (context, state) {
                if (generalStyles.hideDefaultDialogs) return;

                if (state.statusTakePhotoPage == AppStatus.loading) {
                  dialogs.defaultDialog(context, 'Taking picture');
                }

                if (state.statusTakePhotoPage == AppStatus.success) {
                  Navigator.pop(context);
                }
              },
            ),

            // ? Show default dialogs in Crop Photo
            BlocListener<AppBloc, AppState>(
              listenWhen: (previous, current) =>
                  current.statusCropPhoto != previous.statusCropPhoto,
              listener: (context, state) {
                if (generalStyles.hideDefaultDialogs) return;

                if (state.statusCropPhoto == AppStatus.loading) {
                  dialogs.defaultDialog(context, 'Cropping picture');
                }

                if (state.statusCropPhoto == AppStatus.success) {
                  Navigator.pop(context);
                }
              },
            ),

            // ? Show default dialogs in Edit Photo
            BlocListener<AppBloc, AppState>(
              listenWhen: (previous, current) =>
                  current.statusEditPhoto != previous.statusEditPhoto,
              listener: (context, state) {
                if (generalStyles.hideDefaultDialogs) return;

                if (state.statusEditPhoto == AppStatus.loading) {
                  dialogs.defaultDialog(context, 'Editing picture');
                }

                if (state.statusEditPhoto == AppStatus.success) {
                  Navigator.pop(context);
                }
              },
            ),

            // ? Show default dialogs in Save Photo Document
            BlocListener<AppBloc, AppState>(
              listenWhen: (previous, current) =>
                  current.statusSavePhotoDocument !=
                  previous.statusSavePhotoDocument,
              listener: (context, state) {
                if (generalStyles.hideDefaultDialogs) return;

                if (state.statusSavePhotoDocument == AppStatus.loading) {
                  dialogs.defaultDialog(context, 'Saving Document');
                }

                if (state.statusSavePhotoDocument == AppStatus.success) {
                  Navigator.pop(context);
                  dialogs.defaultDialog(context, 'Saved Document');
                }
              },
            ),
          ],
          child: ColoredBox(
            color: generalStyles.baseColor,
            child: _View(
              pageTransitionBuilder: pageTransitionBuilder,
              takePhotoDocumentStyle: takePhotoDocumentStyle,
              cropPhotoDocumentStyle: cropPhotoDocumentStyle,
              editPhotoDocumentStyle: editPhotoDocumentStyle,
              onSave: onSave,
            ),
          ),
        ),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({
    super.key,
    this.pageTransitionBuilder,
    required this.takePhotoDocumentStyle,
    required this.cropPhotoDocumentStyle,
    required this.editPhotoDocumentStyle,
    required this.onSave,
  });

  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;
  final TakePhotoDocumentStyle takePhotoDocumentStyle;
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;
  final EditPhotoDocumentStyle editPhotoDocumentStyle;
  final OnSave onSave;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, AppPages>(
      selector: (state) => state.currentPage,
      builder: (context, state) {
        Widget page = TakePhotoDocumentPage(
          takePhotoDocumentStyle: takePhotoDocumentStyle,
        );

        switch (state) {
          case AppPages.takePhoto:
            page = TakePhotoDocumentPage(
              takePhotoDocumentStyle: takePhotoDocumentStyle,
            );
            break;

          case AppPages.cropPhoto:
            page = CropPhotoDocumentPage(
              cropPhotoDocumentStyle: cropPhotoDocumentStyle,
            );
            break;

          case AppPages.editDocument:
            page = EditDocumentPhotoPage(
              editPhotoDocumentStyle: editPhotoDocumentStyle,
              onSave: onSave,
            );
            break;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: pageTransitionBuilder ??
              (child, animation) {
                const begin = Offset(-1, 0);
                const end = Offset.zero;
                final tween = Tween(begin: begin, end: end);

                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              },
          child: page,
        );
      },
    );
  }
}
