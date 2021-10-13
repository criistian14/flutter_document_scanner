library flutter_document_scanner;

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';
import 'package:flutter_document_scanner/src/utils/dialogs.dart';
import 'package:path_provider/path_provider.dart';

import 'src/types/types.dart';
import 'src/ui/pages/crop_document_picture.dart';
import 'src/ui/pages/edit_document_picture.dart';
import 'src/ui/pages/take_picture_document.dart';

export 'src/document_scanner_controller.dart';
export 'src/types/types.dart';

part 'src/ui/pages/document_scanner.dart';
