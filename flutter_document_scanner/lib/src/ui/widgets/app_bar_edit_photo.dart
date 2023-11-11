// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

/// Default AppBar of the Edit Photo page
class AppBarEditPhoto extends StatelessWidget {
  /// Create a widget with style
  const AppBarEditPhoto({
    super.key,
    required this.editPhotoDocumentStyle,
  });

  /// The style of the page
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  @override
  Widget build(BuildContext context) {
    if (editPhotoDocumentStyle.hideAppBarDefault) {
      return const SizedBox.shrink();
    }

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
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text(
                editPhotoDocumentStyle.textButtonSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
