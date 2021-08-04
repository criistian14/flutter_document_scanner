# Flutter Document Scanner

A Flutter plugin that allows the management of taking, cropping and applying filters to an image, using
the [Camera](https://pub.dev/packages/camera) plugin.

## Usage

First, add camera and flutter_document_scanner as
a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Example

Import libraries.

```dart
import 'package:camera/camera.dart';
import 'package:flutter_document_scanner/document_scanner.dart';
```

Initialize the camera controller

```dart
  @override
void initState() {
  super.initState();

  _initCamera();
}

void _initCamera() async {
  List<CameraDescription> cameras = await availableCameras();
  _cameraController = CameraController(
    cameras.first,
    ResolutionPreset.high,
    enableAudio: false,
  );

  _cameraController.initialize().then((_) {
    if (!mounted) {
      return;
    }

    setState(() {});
  });
}
```

Display widget full screen

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Document Scanner",
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: SafeArea(
      child: (_cameraController != null)
          ? DocumentScanner(
        cameraController: _cameraController,
        childWidgetTakePicture: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.camera),
        ),
        onLoadingTakingPicture: _onLoadingTakingPicture,
        onTakePicture: _onTakePicture,
        onLoadingCroppingPicture: _onLoadingCroppingPicture,
        onCroppedPicture: _onCroppedPicture,
        onLoadingSavingDocument: _onLoadingSavingDocument,
        onSaveDocument: _onSaveDocument,
      )
          : Container(),
    ),
  );
}
```

Listen events, only required is onSaveDocument

```dart
void _onLoadingTakingPicture() {
  // TODO: show modal when taking picture, or other function
}

void _onTakePicture() {
  // TODO: hide modal when take picture, or other function
}

void _onLoadingCroppingPicture() {
  // TODO: show modal when cropping picture, or other function
}

void _onCroppedPicture() {
  // TODO: hide modal when crop picture, or other function
}

void _onLoadingSavingDocument() {
  // TODO: show modal when saving document, or other function
}

void _onSaveDocument(File document) async {
  // TODO: when save
}
```





