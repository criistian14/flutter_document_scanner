import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:path_provider/path_provider.dart';

class DocumentUtils {
  static Future<Rect> detectEdges(File picture) async {
    final appDir = await getTemporaryDirectory();
    File pictureFile = File('${appDir.path}/${DateTime.now()}.jpg');
    await pictureFile.writeAsBytes(picture.readAsBytesSync());

    var res = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      outputType: Cv2.COLOR_BGR2GRAY,
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.bilateralFilter(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      diameter: 9,
      sigmaColor: 75,
      sigmaSpace: 75,
      borderType: Cv2.BORDER_DEFAULT,
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.adaptiveThreshold(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      maxValue: 255,
      adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
      thresholdType: Cv2.THRESH_BINARY,
      blockSize: 115,
      constantValue: 4,
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      kernelSize: 11,
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.canny(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      threshold1: 200,
      threshold2: 250,
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.morphologyEx(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      operation: Cv2.MORPH_CLOSE,
      kernelSize: [5, 11],
    );
    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    List<Rect> contours = await Cv2.findContours(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      mode: Cv2.RETR_TREE,
      method: Cv2.CHAIN_APPROX_SIMPLE,
    );
    if (contours == null) return null;

    Rect maxContour = Rect.zero;
    double maxArea = 100;

    contours.forEach((contour) {
      double areaContour = contour.height * contour.width;

      if (areaContour > maxArea) {
        maxArea = areaContour;
        maxContour = contour;
      }
    });

    return maxContour;
  }

  static Future<Uint8List> grayScale(Uint8List picture) async {
    final appDir = await getTemporaryDirectory();
    File pictureFile = File('${appDir.path}/${DateTime.now()}.jpg');
    await pictureFile.writeAsBytes(picture);

    var res = await Cv2.cvtColor(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      outputType: Cv2.COLOR_BGR2GRAY,
    );

    return res;
  }

  static Future<Uint8List> eco(Uint8List picture) async {
    final appDir = await getTemporaryDirectory();
    File pictureFile = File('${appDir.path}/${DateTime.now()}.jpg');
    await pictureFile.writeAsBytes(picture);

    var res = await Cv2.gaussianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      kernelSize: [3, 3],
      sigmaX: 0,
    );

    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.adaptiveThreshold(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      maxValue: 255,
      adaptiveMethod: Cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
      thresholdType: Cv2.THRESH_BINARY,
      blockSize: 7,
      constantValue: 2,
    );

    if (res == null) return null;
    await pictureFile.writeAsBytes(res);

    res = await Cv2.medianBlur(
      pathFrom: CVPathFrom.GALLERY_CAMERA,
      pathString: pictureFile.path,
      kernelSize: 3,
    );

    return res;
  }
}
