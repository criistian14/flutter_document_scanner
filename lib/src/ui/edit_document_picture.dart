import 'dart:io';
import 'dart:typed_data';

import 'package:document_scanner/src/types/filter_document.dart';
import 'package:document_scanner/src/utils/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'bottom_navigation.dart';
import 'item_filter.dart';

class EditDocumentPicture extends StatefulWidget {
  final File picture;
  final Function() backStep;
  final Function(File document, BuildContext? dialogContext) returnDocument;
  final Function()? onLoadingSavingDocument;

  const EditDocumentPicture({
    Key? key,
    required this.picture,
    required this.backStep,
    required this.returnDocument,
    this.onLoadingSavingDocument,
  }) : super(key: key);

  @override
  _EditDocumentPictureState createState() => _EditDocumentPictureState();
}

class _EditDocumentPictureState extends State<EditDocumentPicture> {
  File? document;
  BuildContext? dialogContext;
  late Uint8List _imageBytes;
  FilterDocument _filterDocument = FilterDocument.original;

  @override
  void initState() {
    super.initState();
    document = widget.picture;
    _imageBytes = widget.picture.readAsBytesSync();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.backStep();
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (document != null)
                  Expanded(
                    child: Container(
                      child: Image.memory(
                        _imageBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                Container(
                  height: 55,
                  width: double.infinity,
                  color: Color(0xFF040404).withOpacity(0.7),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ItemFilter(
                          onTap: () {
                            if (_filterDocument == FilterDocument.original) {
                              return;
                            }

                            setState(() {
                              _imageBytes = widget.picture.readAsBytesSync();
                              _filterDocument = FilterDocument.original;
                            });
                          },
                          title: "Original",
                          active: _filterDocument == FilterDocument.original,
                        ),
                        ItemFilter(
                          onTap: () async {
                            if (_filterDocument == FilterDocument.grayScale) {
                              return;
                            }

                            var response = await DocumentUtils.grayScale(
                              widget.picture.readAsBytesSync(),
                            );

                            if (response == null) return;
                            setState(() {
                              _imageBytes = response;
                              _filterDocument = FilterDocument.grayScale;
                            });
                          },
                          title: "Escala de grises",
                          active: _filterDocument == FilterDocument.grayScale,
                        ),
                        ItemFilter(
                          onTap: () async {
                            if (_filterDocument == FilterDocument.eco) {
                              return;
                            }

                            var response = await DocumentUtils.eco(
                              widget.picture.readAsBytesSync(),
                            );

                            if (response == null) return;
                            setState(() {
                              _imageBytes = response;
                              _filterDocument = FilterDocument.eco;
                            });
                          },
                          title: "Eco",
                          active: _filterDocument == FilterDocument.eco,
                        ),
                      ],
                    ),
                  ),
                ),
                BottomNavigation(
                  iconNext: Icons.check,
                  onBack: () {
                    widget.backStep();
                  },
                  onNext: () async {
                    if (document != null) {
                      if (widget.onLoadingSavingDocument != null) {
                        widget.onLoadingSavingDocument!();
                      } else {
                        loadingModal(
                          context: context,
                        );
                      }

                      imageCache!.clear();
                      final appDir = await getTemporaryDirectory();
                      File file = File('${appDir.path}/document_edited.jpg');
                      await file.writeAsBytes(_imageBytes);

                      widget.returnDocument(file, dialogContext);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void loadingModal({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;

        return AlertDialog(
          title: Text(
            "Editing picture",
          ),
        );
      },
    );
  }
}
