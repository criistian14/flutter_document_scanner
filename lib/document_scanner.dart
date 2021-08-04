library flutter_document_scanner;

import 'dart:io';

import 'package:camera/camera.dart';
import 'src/ui/crop_document_picture.dart';
import 'src/ui/edit_document_picture.dart';
import 'src/utils/document.dart';
import 'package:flutter/material.dart';

import 'src/types/types.dart';
import 'src/ui/taking_picture_document.dart';

class DocumentScanner extends StatefulWidget {
  final CameraLensDirection initialCameraLensDirection;
  final List<Widget>? childrenTakingPicture;
  final Function(DocumentEvent)? sendEvents;
  final CameraController cameraController;
  final Function(File document) onSaveDocument;
  final Widget? childWidgetTakePicture;
  final Function()? onLoadingTakingPicture;
  final Function()? onTakePicture;
  final Function()? onLoadingCroppingPicture;
  final Function()? onCroppedPicture;
  final Function()? onLoadingSavingDocument;

  const DocumentScanner({
    Key? key,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.childrenTakingPicture,
    this.sendEvents,
    required this.cameraController,
    required this.onSaveDocument,
    this.childWidgetTakePicture,
    this.onLoadingTakingPicture,
    this.onTakePicture,
    this.onLoadingCroppingPicture,
    this.onCroppedPicture,
    this.onLoadingSavingDocument,
  }) : super(key: key);

  @override
  _DocumentScannerState createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  StateDocument _stateDocument = StateDocument.takingPictureDocument;
  late File _picture;
  late File _document;
  Rect? _selectedArea;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_stateDocument) {
      case StateDocument.takingPictureDocument:
        return TakingPictureDocument(
          controller: widget.cameraController,
          children: widget.childrenTakingPicture,
          onLoadingTakingPicture: widget.onLoadingTakingPicture,
          childWidgetTakePicture: widget.childWidgetTakePicture,
          nextStep: (File picture, BuildContext? dialogContext) async {
            // _selectedArea = await DocumentUtils.findContours(picture);

            setState(() {
              _picture = picture;
              _stateDocument = StateDocument.cropDocumentPicture;
            });

            if (dialogContext != null) {
              Navigator.pop(dialogContext);
            }

            if (widget.onTakePicture != null) {
              widget.onTakePicture!();
            }
          },
        );

      case StateDocument.cropDocumentPicture:
        return CropDocumentPicture(
          picture: _picture,
          initialArea: _selectedArea,
          onLoadingCroppingPicture: widget.onLoadingCroppingPicture,
          nextStep: (
            File document,
            Rect? selectedArea,
            BuildContext? dialogContext,
          ) {
            setState(() {
              _document = document;
              _selectedArea = selectedArea;
              _stateDocument = StateDocument.editingDocumentPicture;
            });

            if (dialogContext != null) {
              Navigator.pop(dialogContext);
            }

            if (widget.onCroppedPicture != null) {
              widget.onCroppedPicture!();
            }
          },
          backStep: () {
            setState(() {
              _stateDocument = StateDocument.takingPictureDocument;
            });
          },
        );

      case StateDocument.editingDocumentPicture:
        return EditDocumentPicture(
          picture: _document,
          onLoadingSavingDocument: widget.onLoadingSavingDocument,
          backStep: () {
            setState(() {
              _stateDocument = StateDocument.cropDocumentPicture;
            });
          },
          returnDocument: (File document, BuildContext? dialogContext) {
            if (dialogContext != null) {
              Navigator.pop(dialogContext);
            }

            widget.onSaveDocument(document);
          },
        );

      case StateDocument.documentValidation:
        return Container();
    }
  }
}
