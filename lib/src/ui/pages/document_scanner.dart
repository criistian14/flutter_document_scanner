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
  ///
  final DocumentScannerController? controller;

  ///
  final GeneralStyles generalStyles;

  ///
  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;

  /// Config Camera
  final CameraLensDirection initialCameraLensDirection;
  final ResolutionPreset resolutionCamera;

  ///
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  ///
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  ///
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  ///
  final OnSave onSave;

  const DocumentScanner({
    Key? key,
    this.controller,
    this.generalStyles = const GeneralStyles(),
    this.pageTransitionBuilder,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.resolutionCamera = ResolutionPreset.high,
    this.takePhotoDocumentStyle = const TakePhotoDocumentStyle(),
    this.cropPhotoDocumentStyle = const CropPhotoDocumentStyle(),
    this.editPhotoDocumentStyle = const EditPhotoDocumentStyle(),
    required this.onSave,
  }) : super(key: key);

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
                  dialogs.defaultDialog(context, "Taking picture");
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
                  dialogs.defaultDialog(context, "Cropping picture");
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
                  dialogs.defaultDialog(context, "Editting picture");
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
                  dialogs.defaultDialog(context, "Saving Document");
                }

                if (state.statusSavePhotoDocument == AppStatus.success) {
                  Navigator.pop(context);
                  dialogs.defaultDialog(context, "Saved Document");
                }
              },
            ),
          ],
          child: Container(
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
  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;
  final TakePhotoDocumentStyle takePhotoDocumentStyle;
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;
  final EditPhotoDocumentStyle editPhotoDocumentStyle;
  final OnSave onSave;

  const _View({
    Key? key,
    this.pageTransitionBuilder,
    required this.takePhotoDocumentStyle,
    required this.cropPhotoDocumentStyle,
    required this.editPhotoDocumentStyle,
    required this.onSave,
  }) : super(key: key);

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
                const begin = Offset(-1.0, 0.0);
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
