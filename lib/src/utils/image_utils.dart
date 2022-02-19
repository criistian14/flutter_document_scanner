import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_scanner/src/models/contour.dart';

class ImageUtils {
  final _methodChannel = const MethodChannel(
    "christian.com/flutter_document_scanner",
  );

  // Rect imageRect(Size screenSize, double imageRatio) {
  //   final imageScreenWidth = screenSize.height * imageRatio;
  //   final left = (screenSize.width - imageScreenWidth) / 2;
  //   final right = left + imageScreenWidth;
  //
  //   return Rect.fromLTWH(0, 0, right - left, screenSize.height);
  // }

  Rect imageRect(Size screenSize, int width, int height) {
    final imageRatio = width / height;
    // _isFitVertically = imageRatio < screenSize.aspectRatio;

    final imageScreenWidth = screenSize.height * imageRatio;
    final left = (screenSize.width - imageScreenWidth) / 2;
    final right = left + imageScreenWidth;
    return Rect.fromLTWH(left, 0, right - left, screenSize.height);
  }

  Future<Contour?> findContourPhoto(Uint8List byteData) async {
    try {
      final contour = await _methodChannel.invokeMethod("findContourPhoto", {
        "byteData": byteData,
      });

      final contourParsed = Contour.fromMap(Map<String, dynamic>.from(contour));
      if (contourParsed.points.isEmpty) return null;
      if (contourParsed.points.length != 4) return null;

      return contourParsed;

      // Area area;
      //
      // area = Area(
      //   topRight: contourParsed.points[0],
      //   bottomRight: contourParsed.points[1],
      //   topLeft: contourParsed.points[3],
      //   bottomLeft: contourParsed.points[2],
      // );
      //
      // return area;
    } catch (e) {
      print(e);
    }
  }
}
