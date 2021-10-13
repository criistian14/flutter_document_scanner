import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../document_scanner_controller.dart';

class TakePictureDocument extends StatelessWidget {
  final DocumentScannerControllerInterface controller;
  final CameraController cameraController;

  final Widget childButtonTakePicture;
  final bool showButtonTakePicture;
  final Widget childTopTakePicture;
  final Widget childBottomTakePicture;

  const TakePictureDocument({
    Key key,
    @required this.controller,
    @required this.cameraController,
    this.childButtonTakePicture,
    @required this.showButtonTakePicture,
    this.childTopTakePicture,
    this.childBottomTakePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (childTopTakePicture != null) childTopTakePicture,

        Expanded(
          child: Container(
            color: Colors.black,
            child: cameraController.value.isInitialized
                ? CameraPreview(cameraController)
                : Container(),
          ),
        ),

        // Default button take picture
        if (showButtonTakePicture) _buttonTakePicture(context),

        if (childBottomTakePicture != null) childBottomTakePicture,
      ],
    );
  }

  /// Default button take picture and show [childButtonTakePicture]
  Widget _buttonTakePicture(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 40,
        ),
        child: FloatingActionButton(
          onPressed: controller.takePicture,
          child: childButtonTakePicture ??
              Icon(
                Icons.camera_alt,
              ),
        ),
      ),
    );
  }
}
