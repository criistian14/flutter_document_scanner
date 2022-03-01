import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ImageUtils imageUtils;

  setUp(() {
    imageUtils = ImageUtils();
  });

  test(
    "should return the rect of the image",
    () async {
      // arrange
      const screenSize = Size(720, 1280);

      // act
      final imageRect = imageUtils.imageRect(screenSize);

      // assert
      expect(imageRect, const Rect.fromLTWH(0, 0, 720, 1280));
    },
  );
}
