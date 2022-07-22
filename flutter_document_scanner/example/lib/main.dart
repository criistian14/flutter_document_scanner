// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
