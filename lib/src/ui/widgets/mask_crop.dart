import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/models/area.dart';
import 'package:flutter_document_scanner/src/utils/crop_area_clipper.dart';
import 'package:flutter_document_scanner/src/utils/crop_photo_document_style.dart';

class MaskCrop extends StatelessWidget {
  final Area area;
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  const MaskCrop({
    Key? key,
    required this.area,
    required this.cropPhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CropAreaClipper(area),
      child: BackdropFilter(
        filter: cropPhotoDocumentStyle.maskFilter ??
            ui.ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
        child: Container(
          color: cropPhotoDocumentStyle.maskColor ??
              const Color(0xffb9c2d5).withOpacity(0.1),
        ),
      ),
    );
  }
}
