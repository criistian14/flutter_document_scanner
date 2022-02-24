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
  void initState() {
    super.initState();

    _controller.statusTakePhotoPage.listen((event) {
      switch (event) {
        case AppStatus.initial:
          print("CURRENT STATUS: AppStatus.initial");
          break;

        case AppStatus.loading:
          print("CURRENT STATUS: AppStatus.loading");
          break;

        case AppStatus.success:
          print("CURRENT STATUS: AppStatus.success");
          break;

        case AppStatus.failure:
          print("CURRENT STATUS: AppStatus.failure");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: DocumentScanner(
              controller: _controller,
              generalStyles: const GeneralStyles(
                baseColor: Colors.white,
              ),
              takePhotoDocumentStyle: const TakePhotoDocumentStyle(),
              cropPhotoDocumentStyle: CropPhotoDocumentStyle(
                top: MediaQuery.of(context).padding.top,
                // left: 40,
                // right: 40,
                // bottom: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}
