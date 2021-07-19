import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scanner/document_scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();

    initCamera();
  }

  void initCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    CameraDescription camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Document",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: (controller != null)
              ? DocumentScanner(
            onSaveDocument: (File document) {},
            cameraController: controller!,
          )
              : Container(),
        ),
      ),
    );
  }
}
