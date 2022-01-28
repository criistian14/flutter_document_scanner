import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_state.dart';
import 'package:flutter_document_scanner/src/ui/widgets/button_take_photo.dart';
import 'package:flutter_document_scanner/src/utils/dialogs.dart';
import 'package:flutter_document_scanner/src/utils/take_photo_document_style.dart';

class TakePhotoDocument extends StatelessWidget {
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  const TakePhotoDocument({
    Key? key,
    required this.takePhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dialogs dialogs = Dialogs();

    return BlocSelector<AppBloc, AppState, AppStatus>(
      selector: (state) => state.statusCamera,
      builder: (context, state) {
        switch (state) {
          case AppStatus.initial:
            return Container();

          case AppStatus.loading:
            return takePhotoDocumentStyle.onLoading;

          case AppStatus.success:
            return _CameraPreview(
              takePhotoDocumentStyle: takePhotoDocumentStyle,
            );

          case AppStatus.failure:
            return Container();
        }
      },
    );
  }
}

class _CameraPreview extends StatelessWidget {
  final TakePhotoDocumentStyle takePhotoDocumentStyle;

  const _CameraPreview({
    Key? key,
    required this.takePhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, CameraController?>(
      selector: (state) => state.cameraController,
      builder: (context, state) {
        if (state == null) {
          return const Center(
            child: Text(
              "No Camera",
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // * Camera
            Positioned(
              top: takePhotoDocumentStyle.top ?? 0,
              bottom: takePhotoDocumentStyle.bottom ?? 0,
              left: takePhotoDocumentStyle.left ?? 0,
              right: takePhotoDocumentStyle.right ?? 0,
              child: CameraPreview(state),
            ),

            // * children
            if (takePhotoDocumentStyle.children != null)
              ...takePhotoDocumentStyle.children!,

            /// Default
            const ButtonTakePhoto(),
          ],
        );
      },
    );
  }
}
