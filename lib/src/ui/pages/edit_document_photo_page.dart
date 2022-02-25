import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/utils/edit_photo_document_style.dart';

class EditDocumentPhotoPage extends StatelessWidget {
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  const EditDocumentPhotoPage({
    Key? key,
    required this.editPhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: BlocSelector<AppBloc, AppState, Uint8List?>(
        selector: (state) => state.pictureCropped,
        builder: (context, state) {
          if (state == null) {
            return const Center(
              child: Text("NO IMAGE"),
            );
          }

          // return BlocProvider(
          //   create: (context) => CropBloc(
          //     dotUtils: DotUtils(),
          //     imageUtils: ImageUtils(),
          //   )..add(CropAreaInitialized(
          //       contour: context.read<AppBloc>().state.contourInitial,
          //       image: state,
          //       screenSize: screenSize,
          //       positionImage: Rect.fromLTRB(
          //         cropPhotoDocumentStyle.left,
          //         cropPhotoDocumentStyle.top,
          //         cropPhotoDocumentStyle.right,
          //         cropPhotoDocumentStyle.bottom,
          //       ),
          //     )),
          //   child: _CropView(
          //     cropPhotoDocumentStyle: cropPhotoDocumentStyle,
          //     image: state,
          //   ),
          // );

          return Container(
            padding: EdgeInsets.all(28),
            child: Center(
              child: Image.memory(
                state,
                // fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    context.read<DocumentScannerController>().changePage(AppPages.cropPhoto);
    return false;
  }
}
