import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = DocumentScannerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: DocumentScanner(
              controller: _controller,
              generalStyles: const GeneralStyles(
                baseColor: Colors.white,
              ),
              cropPhotoDocumentStyle: CropPhotoDocumentStyle(
                top: MediaQuery.of(context).padding.top,
              ),
              onSave: (Uint8List imageBytes) {
                // ? Bytes of the document/image already processed
              },
            ),
          );
        },
      ),
    );
  }
}
