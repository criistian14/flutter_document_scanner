import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        accentColor: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _documentScannerCtrl = DocumentScannerController();
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _documentScannerCtrl.stateDocument.listen((state) {
      switch (state) {
        case StateDocument.takePictureDocument:
          // TODO: when is show take picture view
          break;
        case StateDocument.loadingTakePictureDocument:
          // TODO: show modal when taking picture, or other function
          break;
        case StateDocument.cropDocumentPicture:
          // TODO: when is show crop picture view
          break;
        case StateDocument.loadingCropDocumentPicture:
          // TODO: show modal when cropping picture, or other function
          break;
        case StateDocument.editDocumentPicture:
          // TODO: when is show edit picture view
          break;
        case StateDocument.loadingEditDocumentPicture:
          // TODO: show modal when saving document, or other function
          break;
        case StateDocument.saveDocument:
          // TODO: When save document and call onSaveDocument
          break;
      }
    });

    _documentScannerCtrl.flash.listen((flash) {
      setState(() {
        _flashOn = flash;
      });
    });
  }

  @override
  void dispose() {
    _documentScannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Document",
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF303030),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: DocumentScanner(
            controller: _documentScannerCtrl,
            showButtonTakePicture: false,
            showDefaultBottomNavigation: false,
            cropColorMask: Colors.white.withOpacity(0.5),
            baseColor: const Color(0xFF303030),
            childBottomTakePicture: _CustomBottomTakePicture(
              documentScannerCtrl: _documentScannerCtrl,
            ),
            childTopTakePicture: Container(
              color: const Color(0xFF303030),
              width: double.infinity,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _flashOn ? Colors.yellow : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _documentScannerCtrl.toggleFlash,
                    child: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: _flashOn ? Colors.yellow : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            childBottomCropPicture: _CustomBottomCropPicture(
              documentScannerCtrl: _documentScannerCtrl,
            ),
            childBottomEditDocument: _CustomBottomEditDocument(
              documentScannerCtrl: _documentScannerCtrl,
            ),
            onSaveDocument: _onSaveDocument,
          ),
        ),
      ),
    );
  }

  void _onSaveDocument(File document) async {
    print(document.path);
    // TODO: when save
  }
}

class _CustomBottomTakePicture extends StatelessWidget {
  const _CustomBottomTakePicture({
    Key key,
    @required this.documentScannerCtrl,
  }) : super(key: key);

  final DocumentScannerController documentScannerCtrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      // Take picture from controller
      onTap: documentScannerCtrl.takePicture,
      child: Container(
        color: const Color(0xFF303030),
        width: size.width,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: size.width * 0.01,
            ),
          ),
          height: size.width * 0.16,
          child: Container(
            margin: EdgeInsets.all(size.width * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            width: size.width * 0.1,
            height: size.width * 0.1,
          ),
        ),
      ),
    );
  }
}

class _CustomBottomCropPicture extends StatelessWidget {
  const _CustomBottomCropPicture({
    Key key,
    @required this.documentScannerCtrl,
  }) : super(key: key);

  final DocumentScannerController documentScannerCtrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: const Color(0xFF303030),
      width: size.width,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom cancel button
          ElevatedButton(
            // Back step from controller
            onPressed: documentScannerCtrl.backStep,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 35,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0.3),
              shape: CircleBorder(),
              padding: const EdgeInsets.all(13),
            ),
          ),
          SizedBox(width: size.width * 0.14),

          // Custom crop button
          ElevatedButton(
            // Crop picture from controller
            onPressed: documentScannerCtrl.cropPicture,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 35,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0.3),
              shape: CircleBorder(),
              padding: const EdgeInsets.all(13),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomEditDocument extends StatelessWidget {
  const _CustomBottomEditDocument({
    Key key,
    @required this.documentScannerCtrl,
  }) : super(key: key);

  final DocumentScannerController documentScannerCtrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: const Color(0xFF303030),
      width: size.width,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Custom natural button
              ElevatedButton(
                // Apply natura filter to picture from controller
                onPressed: documentScannerCtrl.applyNaturalFilter,
                child: Text("Natural"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(26),
                ),
              ),

              // Custom gray button
              ElevatedButton(
                // Apply gray filter to picture from controller
                onPressed: documentScannerCtrl.applyGrayFilter,
                child: Text("Gray"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(26),
                ),
              ),

              // Custom eco button
              ElevatedButton(
                // Apply eco filter to picture from controller
                onPressed: documentScannerCtrl.applyEcoFilter,
                child: Text("Eco"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(26),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom cancel button
              ElevatedButton(
                // Back step from controller
                onPressed: documentScannerCtrl.backStep,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 35,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(13),
                ),
              ),
              SizedBox(width: size.width * 0.14),

              // Custom save button
              ElevatedButton(
                // Crop picture from controller
                onPressed: documentScannerCtrl.save,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 35,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.3),
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
