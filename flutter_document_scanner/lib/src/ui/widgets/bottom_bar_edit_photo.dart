// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/utils/edit_photo_document_style.dart';

class BottomBarEditPhoto extends StatelessWidget {
  final EditPhotoDocumentStyle editPhotoDocumentStyle;

  const BottomBarEditPhoto({
    Key? key,
    required this.editPhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (editPhotoDocumentStyle.hideBottomBarDefault) return Container();

    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // * Natural
            TextButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().applyFilter(
                        FilterType.natural,
                      ),
              child: const Text(
                "Natural",
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),

            // * Gray
            TextButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().applyFilter(
                        FilterType.gray,
                      ),
              child: const Text(
                "GRAY",
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),

            // * ECO
            TextButton(
              onPressed: () =>
                  context.read<DocumentScannerController>().applyFilter(
                        FilterType.eco,
                      ),
              child: const Text(
                "ECO",
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
