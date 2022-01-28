import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_event.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_state.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';
import 'package:flutter_document_scanner/src/utils/dialogs.dart';
import 'package:flutter_document_scanner/src/utils/general_styles.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

import 'take_photo_document.dart';

class DocumentScanner extends StatelessWidget {
  ///
  final DocumentScannerController? controller;

  ///
  final GeneralStyles? generalStyles;

  ///
  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;

  /// Config Camera
  final CameraLensDirection initialCameraLensDirection;
  final ResolutionPreset resolutionCamera;

  ///
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  const DocumentScanner({
    Key? key,
    this.controller,
    this.generalStyles,
    this.pageTransitionBuilder,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.resolutionCamera = ResolutionPreset.high,
    this.takePhotoDocumentStyle = const TakePhotoDocumentStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocumentScannerController _controller = DocumentScannerController();
    if (controller != null) {
      _controller = controller!;
    }

    return BlocProvider(
      create: (BuildContext context) => AppBloc()
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
            BlocListener<AppBloc, AppState>(
              listenWhen: (previous, current) =>
                  current.statusTakePhotoPage != previous.statusTakePhotoPage,
              listener: (context, state) {
                if (state.statusTakePhotoPage == AppStatus.loading) {
                  final Dialogs dialogs = Dialogs();
                  dialogs.defaultDialog(context, "Taking picture");
                }

                if (state.statusTakePhotoPage == AppStatus.success) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
          child: Container(
            color: generalStyles?.baseColor,
            child: _View(
              takePhotoDocumentStyle: takePhotoDocumentStyle,
              pageTransitionBuilder: pageTransitionBuilder,
            ),
          ),
        ),
      ),
    );
  }
}

class _View extends StatelessWidget {
  final TakePhotoDocumentStyle takePhotoDocumentStyle;
  final AnimatedSwitcherTransitionBuilder? pageTransitionBuilder;

  const _View({
    Key? key,
    required this.takePhotoDocumentStyle,
    this.pageTransitionBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DocumentScannerController>();
    controller.bloc = context.read<AppBloc>();

    return BlocSelector<AppBloc, AppState, AppPages>(
      selector: (state) => state.currentPage,
      builder: (context, state) {
        Widget page = TakePhotoDocument(
          takePhotoDocumentStyle: takePhotoDocumentStyle,
        );

        switch (state) {
          case AppPages.takePhoto:
            page = TakePhotoDocument(
              takePhotoDocumentStyle: takePhotoDocumentStyle,
            );
            break;

          case AppPages.cropPhoto:
            page = WillPopScope(
              onWillPop: () => _onPop(context),
              child: const Center(
                child: Text(
                  "Crop Photo",
                ),
              ),
            );
            break;

          case AppPages.editDocument:
            page = Container();
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

  ///
  Future<bool> _onPop(BuildContext context) async {
    context.read<DocumentScannerController>().changePage(AppPages.takePhoto);
    return false;
  }
}
