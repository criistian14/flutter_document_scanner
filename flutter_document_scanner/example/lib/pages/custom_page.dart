import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final _controller = DocumentScannerController();

  @override
  Widget build(BuildContext context) {
    _controller.currentFilterType.listen((filterType) {
      switch (filterType) {
        case FilterType.natural:
          // TODO: Handle this case.
          break;
        case FilterType.gray:
          // TODO: Handle this case.
          break;
        case FilterType.eco:
          // TODO: Handle this case.
          break;
      }
      print('Filter Type: ${filterType}');
    });

    return Scaffold(
      body: DocumentScanner(
        controller: _controller,
        generalStyles: const GeneralStyles(
          hideDefaultBottomNavigation: true,
          hideDefaultDialogs: true,
        ),
        cropPhotoDocumentStyle: CropPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
        ),
        editPhotoDocumentStyle: EditPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
        ),
        onSave: (Uint8List imageBytes) {
          // ? Bytes of the document/image already processed
        },
      ),
    );
  }
}
