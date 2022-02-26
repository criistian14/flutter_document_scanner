import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/utils/edit_photo_document_style.dart';

class AppBarEditPhoto extends StatelessWidget {
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  const AppBarEditPhoto({
    Key? key,
    required this.editPhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (editPhotoDocumentStyle.hideAppBarDefault) return Container();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 15,
        ),
        color: Colors.black.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().changePage(
                        AppPages.cropPhoto,
                      ),
              icon: const Icon(
                Icons.close,
              ),
              color: Colors.white,
            ),

            // * Crop photo
            TextButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().savePhotoDocument(),
              child: Text(
                editPhotoDocumentStyle.textButtonSave,
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
