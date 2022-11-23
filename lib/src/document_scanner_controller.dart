import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:path_provider/path_provider.dart';

import 'types/types.dart';
import 'utils/document.dart';

abstract class DocumentScannerControllerInterface {
  Stream<StateDocument> get stateDocument;

  Stream<FilterDocument> get currentFilter;

  Stream<Uint8List> get pictureWithFilter;

  void changeStateDocument(StateDocument state);

  Future<void> takePicture();

  Future<void> cropPicture();

  Future<void> onCroppedPicture(Uint8List bytesPicture);

  Future<void> applyNaturalFilter();

  Future<void> applyGrayFilter();

  Future<void> applyEcoFilter();

  Future<void> save();

  void backStep();

  void dispose();
}

class DocumentScannerController implements DocumentScannerControllerInterface {
  CameraController _cameraController;
  CropController _cropController;
  StateDocument _stateDocument = StateDocument.takePictureDocument;
  File _picture, _pictureCropped;
  Uint8List bytesPictureWithFilter;

  set cameraController(CameraController cameraCtrl) =>
      _cameraController = cameraCtrl;

  set cropController(CropController cropController) =>
      _cropController = cropController;

  StreamController<StateDocument> _streamStateDocument =
      StreamController.broadcast();

  StreamController<FilterDocument> _streamFilterDocument =
      StreamController.broadcast();

  StreamController<Uint8List> _streamPictureWithFilter =
      StreamController.broadcast();

  @override
  Stream<StateDocument> get stateDocument => _streamStateDocument.stream;

  @override
  Stream<FilterDocument> get currentFilter => _streamFilterDocument.stream;

  @override
  Stream<Uint8List> get pictureWithFilter => _streamPictureWithFilter.stream;

  File get picture => _picture;

  File get pictureCropped => _pictureCropped;

  @override
  void changeStateDocument(StateDocument state) {
    _stateDocument = state;
    _streamStateDocument.add(state);
  }

  @override
  Future<void> takePicture() async {
    assert(_cameraController != null);
    assert(_stateDocument == StateDocument.takePictureDocument);

    changeStateDocument(StateDocument.loadingTakePictureDocument);
    final pictureTake = await _cameraController.takePicture();

    _picture = File(pictureTake.path);

    changeStateDocument(StateDocument.cropDocumentPicture);
  }

  @override
  Future<void> cropPicture() async {
    assert(_stateDocument == StateDocument.cropDocumentPicture);
    changeStateDocument(StateDocument.loadingCropDocumentPicture);

    _cropController.crop();
  }

  @override
  Future<void> onCroppedPicture(Uint8List bytesPicture) async {
    assert(_stateDocument == StateDocument.loadingCropDocumentPicture);

    final appDir = await getTemporaryDirectory();
    File picture = File('${appDir.path}/${DateTime.now()}.jpg');
    await picture.writeAsBytes(bytesPicture);

    _pictureCropped = picture;

    changeStateDocument(StateDocument.editDocumentPicture);
  }

  void _changeFilter(FilterDocument filter, Uint8List bytes) {
    bytesPictureWithFilter = bytes;
    _streamPictureWithFilter.add(bytes);
    _streamFilterDocument.add(filter);
  }

  @override
  Future<void> applyNaturalFilter() async {
    assert(_pictureCropped != null);

    Uint8List bytes = await _pictureCropped.readAsBytes();

    _changeFilter(FilterDocument.original, bytes);
  }

  @override
  Future<void> applyGrayFilter() async {
    assert(_pictureCropped != null);

    Uint8List response = await DocumentUtils.grayScale(
      _pictureCropped.readAsBytesSync(),
    );

    if (response == null) return;
    // TODO: add DocumentScannerException

    _changeFilter(FilterDocument.gray, response);
  }

  @override
  Future<void> applyEcoFilter() async {
    assert(_pictureCropped != null);

    Uint8List response = await DocumentUtils.eco(
      _pictureCropped.readAsBytesSync(),
    );

    if (response == null) return;
    // TODO: add DocumentScannerException

    _changeFilter(FilterDocument.eco, response);
  }

  @override
  Future<void> save() async {
    assert(_stateDocument == StateDocument.editDocumentPicture);
    assert(bytesPictureWithFilter != null);
    changeStateDocument(StateDocument.loadingEditDocumentPicture);

    // imageCache.clear();
    final appDir = await getTemporaryDirectory();
    File file = File('${appDir.path}/${DateTime.now()}.jpg');
    await file.writeAsBytes(bytesPictureWithFilter);

    changeStateDocument(StateDocument.saveDocument);
  }

  @override
  void backStep() {
    if (_stateDocument == StateDocument.cropDocumentPicture) {
      return changeStateDocument(StateDocument.takePictureDocument);
    }

    if (_stateDocument == StateDocument.editDocumentPicture) {
      return changeStateDocument(StateDocument.cropDocumentPicture);
    }

    if (_stateDocument == StateDocument.saveDocument) {
      return changeStateDocument(StateDocument.cropDocumentPicture);
    }
  }

  @override
  void dispose() {
    _streamStateDocument?.close();
    _streamFilterDocument?.close();
    _streamPictureWithFilter?.close();
  }
}
