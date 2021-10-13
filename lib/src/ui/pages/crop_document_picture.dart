import 'dart:io';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../flutter_document_scanner.dart';
import '../widgets/bottom_navigation.dart';

class CropDocumentPicture extends StatelessWidget {
  final DocumentScannerControllerInterface controller;
  final CropController cropController;

  final File picture;
  final Rect initialArea;
  final Color baseColor;

  final Widget childTopCropPicture;
  final Widget childBottomCropPicture;
  final bool showDefaultBottomNavigation;

  final Color cropColorMask;
  final Color cropColorBorderArea;
  final double cropWidthBorderArea;
  final Color cropColorDotControl;

  const CropDocumentPicture({
    Key key,
    @required this.controller,
    @required this.cropController,
    @required this.picture,
    @required this.showDefaultBottomNavigation,
    this.baseColor,
    this.initialArea,
    this.childTopCropPicture,
    this.childBottomCropPicture,
    this.cropColorMask,
    this.cropColorBorderArea,
    this.cropWidthBorderArea,
    this.cropColorDotControl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.backStep();
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (childTopCropPicture != null) childTopCropPicture,

            Expanded(
              child: Crop(
                image: picture.readAsBytesSync(),
                controller: cropController,
                initialArea: _initialAreaCalculate(context),
                onCropped: controller.onCroppedPicture,
                maskColor: cropColorMask,
                colorBorderArea: cropColorBorderArea,
                widthBorderArea: cropWidthBorderArea,
                baseColor: baseColor,
                cornerDotBuilder: (size, edgeAlignment) {
                  return DotControl(
                    color: cropColorDotControl,
                  );
                },
              ),
            ),

            // Default Menu
            if (showDefaultBottomNavigation)
              BottomNavigation(
                onBack: controller.backStep,
                onNext: controller.cropPicture,
              ),

            if (childBottomCropPicture != null) childBottomCropPicture,
          ],
        ),
      ),
    );
  }

  /// Validate if have an initial crop area
  Rect _initialAreaCalculate(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Rect _initialArea = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.1,
      size.width - (size.width * 0.3),
      size.height - (size.height * 0.45),
    );

    if (initialArea != null) {
      _initialArea = Rect.fromLTWH(
        initialArea.left,
        initialArea.top,
        initialArea.width,
        initialArea.height,
      );
    }

    return _initialArea;
  }
}
