import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../document_scanner_controller.dart';
import '../../types/types.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/item_filter.dart';

class EditDocumentPicture extends StatelessWidget {
  final DocumentScannerControllerInterface? controller;

  final File? picture;

  final Widget? childTopEditDocument;
  final Widget? childBottomEditDocument;
  final bool showDefaultBottomNavigation;

  final Color? baseColor;

  const EditDocumentPicture({
    Key? key,
    required this.controller,
    required this.picture,
    required this.showDefaultBottomNavigation,
    this.childTopEditDocument,
    this.childBottomEditDocument,
    this.baseColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller!.backStep();
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: baseColor ?? Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (childTopEditDocument != null) childTopEditDocument!,

            StreamBuilder<Uint8List>(
              stream: controller!.pictureWithFilter,
              initialData: picture!.readAsBytesSync(),
              builder: (context, snapshot) {
                return Expanded(
                  child: Container(
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),

            // Default Menu
            if (showDefaultBottomNavigation)
              Container(
                height: 55,
                width: double.infinity,
                color: Color(0xFF040404).withOpacity(0.7),
                child: Center(
                  child: StreamBuilder<FilterDocument>(
                      stream: controller!.currentFilter,
                      initialData: FilterDocument.original,
                      builder: (context, snapshot) {
                        return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            // Natural filter
                            ItemFilter(
                              onTap: controller!.applyNaturalFilter,
                              title: "Original",
                              active: snapshot.data == FilterDocument.original,
                            ),

                            // Gray filter
                            ItemFilter(
                              onTap: controller!.applyGrayFilter,
                              title: "Gray",
                              active: snapshot.data == FilterDocument.gray,
                            ),

                            // Eco filter
                            ItemFilter(
                              onTap: controller!.applyEcoFilter,
                              title: "Eco",
                              active: snapshot.data == FilterDocument.eco,
                            ),
                          ],
                        );
                      }),
                ),
              ),

            // Menu
            if (showDefaultBottomNavigation)
              BottomNavigation(
                iconNext: Icons.check,
                onBack: controller!.backStep,
                onNext: controller!.save,
              ),

            if (childBottomEditDocument != null) childBottomEditDocument!,
          ],
        ),
      ),
    );
  }
}
