// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/src/document_scanner_controller.dart';

class ButtonTakePhoto extends StatelessWidget {
  final bool hide;

  const ButtonTakePhoto({
    Key? key,
    this.hide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return Container();
    }

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => context.read<DocumentScannerController>().takePhoto(),
          child: Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 6,
              ),
            ),
            child: Center(
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  color: Color(0xffd8345e),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
