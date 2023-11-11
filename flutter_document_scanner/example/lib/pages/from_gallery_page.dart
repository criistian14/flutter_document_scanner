import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:image_picker/image_picker.dart';

class FromGalleryPage extends StatefulWidget {
  const FromGalleryPage({super.key});

  @override
  State<FromGalleryPage> createState() => _FromGalleryPageState();
}

class _FromGalleryPageState extends State<FromGalleryPage> {
  final controller = DocumentScannerController();
  bool imageIsSelected = false;

  @override
  void initState() {
    super.initState();

    controller.currentPage.listen((AppPages page) {
      if (page == AppPages.takePhoto) {
        setState(() => imageIsSelected = false);
      }

      if (page == AppPages.cropPhoto) {
        setState(() => imageIsSelected = true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentScanner(
        controller: controller,
        generalStyles: GeneralStyles(
          showCameraPreview: false,
          widgetInsteadOfCameraPreview: Center(
            child: ElevatedButton(
              onPressed: _selectImage,
              child: const Text('Select image'),
            ),
          ),
        ),
        onSave: (Uint8List imageBytes) {
          // ? Bytes of the document/image already processed
        },
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await controller.findContoursFromExternalImage(
      image: File(image.path),
    );
  }
}
