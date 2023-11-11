// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

/// Default AppBar of the Crop Photo page
class AppBarCropPhoto extends StatelessWidget {
  /// Create a widget with style
  const AppBarCropPhoto({
    super.key,
    required this.cropPhotoDocumentStyle,
  });

  /// The style of the page
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  @override
  Widget build(BuildContext context) {
    if (cropPhotoDocumentStyle.hideAppBarDefault) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().changePage(
                        AppPages.takePhoto,
                      ),
              icon: const Icon(
                Icons.close,
              ),
              color: Colors.white,
            ),

            // * Crop photo
            TextButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().cropPhoto(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text(
                cropPhotoDocumentStyle.textButtonSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
