library document_scanner;

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scanner/src/ui/crop_document_picture.dart';
import 'package:document_scanner/src/ui/edit_document_picture.dart';
import 'package:document_scanner/src/utils/document.dart';
import 'package:flutter/material.dart';

import 'src/types/types.dart';
import 'src/ui/taking_picture_document.dart';

class DocumentScanner extends StatefulWidget {
  final CameraLensDirection initialCameraLensDirection;
  final List<Widget>? childrenTakingPicture;
  final Function(DocumentEvent)? sendEvents;
  final CameraController cameraController;
  final Function(File document) onSaveDocument;
  final Widget? loadingWidgetWhenTakingPicture;
  final Widget? loadingWidgetWhenCropPicture;
  final Widget? loadingWidgetWhenEditingPicture;

  const DocumentScanner({
    Key? key,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.childrenTakingPicture,
    this.sendEvents,
    required this.cameraController,
    required this.onSaveDocument,
    this.loadingWidgetWhenTakingPicture,
    this.loadingWidgetWhenCropPicture,
    this.loadingWidgetWhenEditingPicture,
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
          loadingWidgetWhenTakingPicture: widget.loadingWidgetWhenTakingPicture,
          nextStep: (File picture, BuildContext dialogContext) async {
            _selectedArea = await DocumentUtils.checkIsDocument(picture);

            setState(() {
              _picture = picture;
              _stateDocument = StateDocument.cropDocumentPicture;
              Navigator.pop(dialogContext);
            });
          },
        );

      case StateDocument.cropDocumentPicture:
        return CropDocumentPicture(
          picture: _picture,
          initialArea: _selectedArea,
          loadingWidgetWhenCropPicture: widget.loadingWidgetWhenCropPicture,
          nextStep: (
            File document,
            Rect? selectedArea,
            BuildContext dialogContext,
          ) {
            setState(() {
              _document = document;
              _selectedArea = selectedArea;
              _stateDocument = StateDocument.editingDocumentPicture;
              Navigator.pop(dialogContext);
            });
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
          loadingWidgetWhenEditingPicture:
              widget.loadingWidgetWhenEditingPicture,
          backStep: () {
            setState(() {
              _stateDocument = StateDocument.cropDocumentPicture;
            });
          },
          returnDocument: (File document, BuildContext dialogContext) {
            Navigator.pop(dialogContext);
            widget.onSaveDocument(document);
          },
        );

      case StateDocument.documentValidation:
        return Container();
    }
  }
}
