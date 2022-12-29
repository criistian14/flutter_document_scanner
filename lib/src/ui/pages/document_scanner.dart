part of '../../../flutter_document_scanner.dart';

class DocumentScanner extends StatefulWidget {
  final DocumentScannerControllerInterface? controller;

  final bool showDefaultBottomNavigation;
  final bool showDefaultDialogs;
  final Color baseColor;

  // Config Camera
  final CameraLensDirection initialCameraLensDirection;
  final ResolutionPreset resolutionCamera;

  // Taking Picture
  final Widget? childButtonTakePicture;
  final bool showButtonTakePicture;
  final Widget? childTopTakePicture;
  final Widget? childBottomTakePicture;

  // Cropping Picture
  final Widget? childTopCropPicture;
  final Widget? childBottomCropPicture;
  final Color? cropColorMask;
  final Color? cropColorBorderArea;
  final double? cropWidthBorderArea;
  final Color cropColorDotControl;

  // Editing Document
  final Function(File document) onSaveDocument;
  final Widget? childTopEditDocument;
  final Widget? childBottomEditDocument;

  const DocumentScanner({
    Key? key,
    this.controller,
    this.showDefaultBottomNavigation = true,
    this.showDefaultDialogs = true,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.resolutionCamera = ResolutionPreset.high,

    // Taking Picture
    this.showButtonTakePicture = true,
    this.childButtonTakePicture,
    this.childTopTakePicture,
    this.childBottomTakePicture,

    // Cropping Picture
    this.childTopCropPicture,
    this.childBottomCropPicture,
    this.cropColorMask,
    this.baseColor = Colors.white,
    this.cropColorBorderArea,
    this.cropWidthBorderArea,
    this.cropColorDotControl = Colors.white,

    // Editing Document
    required this.onSaveDocument,
    this.childTopEditDocument,
    this.childBottomEditDocument,
  }) : super(key: key);

  @override
  _DocumentScannerState createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  File? _picture, _pictureCropped;
  CameraController? _cameraController;
  CropController _cropController = CropController();
  Rect? _selectedArea;
  DocumentScannerController? _documentScannerCtrl = DocumentScannerController();
  PageController _pageController = PageController();
  final Duration _duration = Duration(milliseconds: 300);
  final Curve _curve = Curves.easeIn;
  final _dialogs = Dialogs();
  bool _openDialog = false;

  @override
  void initState() {
    super.initState();
    // Replace controller with the widget.controller
    if (widget.controller != null) {
      _documentScannerCtrl = widget.controller as DocumentScannerController?;
    }

    _documentScannerCtrl!.cropController = _cropController;

    _initCamera();
  }

  /// Start [CameraController]
  void _initCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    CameraDescription camera = cameras.firstWhere(
      (camera) => camera.lensDirection == widget.initialCameraLensDirection,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      widget.resolutionCamera,
      enableAudio: false,
    );

    _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _documentScannerCtrl!.cameraController = _cameraController;
      _documentScannerCtrl!.stateDocument.listen(_listenDocumentScannerCtrl);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null) return Container();

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        TakePictureDocument(
          controller: _documentScannerCtrl,
          cameraController: _cameraController,
          childButtonTakePicture: widget.childButtonTakePicture,
          showButtonTakePicture: widget.showButtonTakePicture,
          childTopTakePicture: widget.childTopTakePicture,
          childBottomTakePicture: widget.childBottomTakePicture,
        ),

        // View when crop
        CropDocumentPicture(
          controller: _documentScannerCtrl,
          cropController: _cropController,
          picture: _picture,
          initialArea: _selectedArea,
          showDefaultBottomNavigation: widget.showDefaultBottomNavigation,
          childTopCropPicture: widget.childTopCropPicture,
          childBottomCropPicture: widget.childBottomCropPicture,
          cropColorMask: widget.cropColorMask,
          baseColor: widget.baseColor,
          cropColorBorderArea: widget.cropColorBorderArea,
          cropWidthBorderArea: widget.cropWidthBorderArea,
          cropColorDotControl: widget.cropColorDotControl,
        ),

        // View when apply filters
        EditDocumentPicture(
          controller: _documentScannerCtrl,
          picture: _pictureCropped,
          showDefaultBottomNavigation: widget.showDefaultBottomNavigation,
          childTopEditDocument: widget.childTopEditDocument,
          childBottomEditDocument: widget.childBottomEditDocument,
          baseColor: widget.baseColor,
        ),
      ],
    );
  }

  /// Listen to [DocumentScannerControllerInterface.stateDocument] changes
  /// And validate which [StateDocument] it is currently
  void _listenDocumentScannerCtrl(StateDocument state) async {
    switch (state) {
      case StateDocument.takePictureDocument:
        _pageController.animateToPage(0, duration: _duration, curve: _curve);
        break;

      case StateDocument.loadingTakePictureDocument:
        _showDefaultDialog("Taking picture");

        break;

      case StateDocument.cropDocumentPicture:
        _hideDefaultDialog();

        _nextTakingPicture(_documentScannerCtrl!.picture);
        break;

      case StateDocument.loadingCropDocumentPicture:
        _showDefaultDialog("Cropping picture");

        break;

      case StateDocument.editDocumentPicture:
        _hideDefaultDialog();

        _nextCropDocument(_documentScannerCtrl!.pictureCropped, _selectedArea);
        break;

      case StateDocument.loadingEditDocumentPicture:
        _showDefaultDialog("Editing picture");

        break;

      case StateDocument.saveDocument:
        _hideDefaultDialog();

        final appDir = await getTemporaryDirectory();
        File document = File('${appDir.path}/${DateTime.now()}.jpg');
        await document.writeAsBytes(
          _documentScannerCtrl!.bytesPictureWithFilter!,
        );
        widget.onSaveDocument(document);
        break;
    }
  }

  /// When finish taking the picture
  /// And change state to [StateDocument.cropDocumentPicture]
  Future<void> _nextTakingPicture(File? picture) async {
    // _selectedArea = await DocumentUtils.detectEdges(picture);

    setState(() {
      _picture = picture;
    });
    _pageController.animateToPage(1, duration: _duration, curve: _curve);
  }

  /// When the picture is finished cropping
  /// And change state to [StateDocument.editDocumentPicture]
  void _nextCropDocument(File? pictureCropped, Rect? selectedArea) {
    setState(() {
      _pictureCropped = pictureCropped;
      _selectedArea = selectedArea;
    });
    _pageController.animateToPage(2, duration: _duration, curve: _curve);
  }

  /// Validate if [widget.showDefaultDialogs] and show dialog with [message]
  /// And change [_openDialog] to true
  void _showDefaultDialog(String message) {
    if (widget.showDefaultDialogs) {
      _openDialog = true;
      _dialogs.defaultDialog(context, message);
    }
  }

  /// Validate if [widget.showDefaultDialogs] is true and and [_openDialog] is true
  /// Prevent [Navigator.pop] when not [_openDialog]
  void _hideDefaultDialog() async {
    if (widget.showDefaultDialogs && _openDialog) {
      _openDialog = false;
      Navigator.pop(context);
    }
  }
}
