import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class DocumentUtils {
  static Future<Rect?> findContours(File picture) async {
    Rect? initialArea;

    ui.Image decodedImage = await decodeImageFromList(
      picture.readAsBytesSync(),
    );
    print("Width: ${decodedImage.width}, Height: ${decodedImage.height}");
    print("=================================================");
    await Future.delayed(Duration(seconds: 2));

    // var res = await ImgProc.cvtColor(
    //   picture.readAsBytesSync(),
    //   ImgProc.colorBGR2RGB,
    // );
    //
    // res = await ImgProc.cvtColor(
    //   res,
    //   ImgProc.colorBGR2GRAY,
    // );

    var res = await ImgProc.bilateralFilter(
      picture.readAsBytesSync(),
      9,
      75,
      75,
      Core.borderDefault,
    );

    res = await ImgProc.adaptiveThreshold(
      res,
      255,
      ImgProc.adaptiveThreshGaussianC,
      ImgProc.threshBinary,
      115,
      4,
    );

    res = await ImgProc.gaussianBlur(
      res,
      [5, 5],
      0,
    );

    res = await ImgProc.medianBlur(res, 11);

    res = await ImgProc.copyMakeBorder(res, 5, 5, 5, 5, Core.borderConstant);

    res = await ImgProc.canny(res, 75, 200);

    res = await ImgProc.morphologyEx(res, ImgProc.morphClose, [5, 11]);

    var contours = await ImgProc.findContours(
      res,
      mode: ImgProc.retrList,
      method: ImgProc.chainApproxSimple,
    );

    if (contours.length < 2) {
      return null;
    }

    Offset? point1;
    Offset? point2;

    for (var contour in contours) {
      // if (contour["x"] == null || contour["y"] == null) {
      //   continue;
      // }

      print(contour);

      // if (point1 == null) {
      //   point1 = Offset(
      //     contour["x"],
      //     contour["y"],
      //   );
      // } else {
      //   if (point2 == null) {
      //     point2 = Offset(
      //       contour["x"],
      //       contour["y"],
      //     );
      //   }
      // }

      // initialArea = Rect.fromLTRB(
      //   (contour["x"] as int).toDouble(),
      //   (contour["y"] as int).toDouble(),
      //   (contour["width"] as int).toDouble(),
      //   (contour["height"] as int).toDouble(),
      //
      //   // Offset(
      //   //   ((contour["width"] as int) - (contour["x"] as int)).toDouble(),
      //   //   (contour["y"] as int).toDouble(),
      //   // ),
      //   // Offset(
      //   //   (contour["x"] as int).toDouble(),
      //   //   (contour["height"] as int).toDouble(),
      //   // ),
      //
      //   // (contour["x"] as int).toDouble(),
      //   // (contour["y"] as int).toDouble(),
      //   // (contour["width"] as int).toDouble(),
      //   // (contour["height"] as int).toDouble(),
      // );
      // break;
    }
    if (point1 != null && point2 != null) {
      initialArea = Rect.fromPoints(point1, point2);
    }
    print("=================================================");

    return initialArea;
  }

  static Future<Uint8List?> grayScale(Uint8List picture) async {
    var res = await ImgProc.cvtColor(
      picture,
      ImgProc.colorBGR2GRAY,
    );

    return res;
  }

  static Future<Uint8List?> eco(Uint8List picture) async {
    var res = await ImgProc.gaussianBlur(
      picture,
      [3, 3],
      0,
    );

    res = await ImgProc.adaptiveThreshold(
      res,
      255,
      ImgProc.adaptiveThreshGaussianC,
      ImgProc.threshBinary,
      7,
      2,
    );

    res = await ImgProc.medianBlur(res, 3);

    return res;
  }
}
