# Flutter Document Scanner

<p align="center">
<a href="https://pub.dev/packages/flutter_document_scanner"><img src="https://img.shields.io/pub/v/flutter_document_scanner.svg" alt="Pub"></a>
<a href="https://github.com/criistian14/flutter_document_scanner/actions"><img src="https://github.com/criistian14/flutter_document_scanner/actions/workflows/main.yml/badge.svg" alt="build"></a>
<a href="https://codecov.io/gh/criistian14/flutter_document_scanner">
  <img src="https://codecov.io/gh/criistian14/flutter_document_scanner/branch/master/graph/badge.svg?token=2U7891NVMO"/>
</a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

---

A Flutter plugin that allows the management of taking, cropping and applying filters to an image, using
the [Camera](https://pub.dev/packages/camera) plugin and [OpenCV](https://opencv.org/)


![Demo](https://raw.githubusercontent.com/criistian14/flutter_document_scanner/master/demo_scanner.gif)

---

## Usage

First, add flutter_document_scanner as
a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

## Example

### Import libraries.

```dart
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
```

### Initialize the DocumentScannerController

```dart
  final _controller = DocumentScannerController();
```

### Display widget 

```dart
DocumentScanner(
  controller: _controller,
  onSave: (Uint8List imageBytes) {
    print("image bytes: $imageBytes");
  },
);
```

---

## Controller Document uses

### Actions 

```dart
_controller.takePhoto(
  minContourArea: 80000.0,
);

_controller.cropPhoto();

_controller.applyFilter(FilterType.gray);

_controller.savePhotoDocument();

_controller.changePage(AppPages.cropPhoto);
```

### Can listen to the changes

```dart
_controller.statusTakePhotoPage.listen((AppStatus event) {
  print("Changes when taking the picture");
  print("[initial, loading, success, failure]");
});


_controller.statusCropPhoto.listen((AppStatus event) {
  print("Changes while cutting the image and adding warp perspective");
  print("[initial, loading, success, failure]");
});


_controller.statusEditPhoto.listen((AppStatus event) {
  print("Changes when editing the image (applying filters)");
  print("[initial, loading, success, failure]");
});


_controller.currentFilterType.listen((FilterType event) {
  print("Listen to the current filter applied on the image");
  print("[ natural, gray, eco]");
});


_controller.statusSavePhotoDocument.listen((AppStatus event) {
  print("Changes while the document image is being saved");
  print("[initial, loading, success, failure]");
});
```

---

## Customizations

### Camera

```dart
DocumentScanner(
  controller: _controller,
  onSave: (Uint8List imageBytes) {
    print("image bytes: $imageBytes");
  },
  resolutionCamera: ResolutionPreset.high,
  initialCameraLensDirection: CameraLensDirection.front,
);
```



### Page transitions

```dart
DocumentScanner(
  controller: _controller,
  onSave: (Uint8List imageBytes) {
    print("image bytes: $imageBytes");
  },
  pageTransitionBuilder: (child, animation) {
    final tween = Tween(begin: 0.0, end: 1.0);

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    return FadeTransition(
      opacity: tween.animate(curvedAnimation),
      child: child,
    );
  },
);

```

### General Styles

The properties are listed [here](https://github.com/criistian14/flutter_document_scanner/blob/master/lib/src/utils/general_styles.dart)


#### Page to take the photo 

The properties are listed [here](https://github.com/criistian14/flutter_document_scanner/blob/master/lib/src/utils/take_photo_document_style.dart) 


#### Page to crop the image

The properties are listed [here](https://github.com/criistian14/flutter_document_scanner/blob/master/lib/src/utils/crop_photo_document_style.dart)


#### Page to edit image 

The properties are listed [here](https://github.com/criistian14/flutter_document_scanner/blob/master/lib/src/utils/edit_photo_document_style.dart) 


