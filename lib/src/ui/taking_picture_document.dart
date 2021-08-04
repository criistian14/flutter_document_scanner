import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TakingPictureDocument extends StatefulWidget {
  final CameraController controller;
  final List<Widget>? children;
  final Function(File picture, BuildContext? dialogContext) nextStep;
  final Widget? loadingWidgetWhenTakingPicture;
  final Widget? childWidgetTakePicture;
  final Function()? onLoadingTakingPicture;

  TakingPictureDocument({
    Key? key,
    required this.controller,
    this.children,
    required this.nextStep,
    this.loadingWidgetWhenTakingPicture,
    this.childWidgetTakePicture,
    this.onLoadingTakingPicture,
  }) : super(key: key);

  @override
  _TakingPictureDocumentState createState() => _TakingPictureDocumentState();
}

class _TakingPictureDocumentState extends State<TakingPictureDocument> {
  BuildContext? dialogContext;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: size.height,
          width: size.width,
          child: widget.controller.value.isInitialized
              ? CameraPreview(widget.controller)
              : Container(),
        ),
        defaultTakePicture(context: context),
        if (widget.children != null) ...widget.children!
      ],
    );
  }

  Widget defaultTakePicture({
    required BuildContext context,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 40,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            if (widget.onLoadingTakingPicture != null) {
              widget.onLoadingTakingPicture!();
            } else {
              loadingModal(
                context: context,
              );
            }

            final appDir = await getTemporaryDirectory();
            File picture = File('${appDir.path}/picture_taken.jpg');
            await widget.controller.takePicture(picture.path);
            widget.nextStep(picture, dialogContext);
          },
          child: widget.childWidgetTakePicture ??
              Icon(
                Icons.camera_alt,
              ),
        ),
      ),
    );
  }

  void loadingModal({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;
        if (widget.loadingWidgetWhenTakingPicture != null) {
          return widget.loadingWidgetWhenTakingPicture!;
        }

        return AlertDialog(
          title: Text(
            "Taking picture",
          ),
        );
      },
    );
  }
}
