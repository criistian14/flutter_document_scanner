import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:flutter_document_scanner/src/bloc/app/app_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop_bloc.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop_event.dart';
import 'package:flutter_document_scanner/src/bloc/crop/crop_state.dart';
import 'package:flutter_document_scanner/src/ui/widgets/app_bar_crop_photo.dart';
import 'package:flutter_document_scanner/src/ui/widgets/mask_crop.dart';
import 'package:flutter_document_scanner/src/utils/border_crop_area_painter.dart';
import 'package:flutter_document_scanner/src/utils/dot_utils.dart';
import 'package:flutter_document_scanner/src/utils/image_utils.dart';

class CropPhotoDocument extends StatelessWidget {
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;

  const CropPhotoDocument({
    Key? key,
    required this.cropPhotoDocumentStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddingSafeArea = MediaQuery.of(context).padding;
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: BlocSelector<AppBloc, AppState, File?>(
        selector: (state) => state.pictureInitial,
        builder: (context, state) {
          if (state == null) {
            return const Center(
              child: Text("NO IMAGE"),
            );
          }

          return BlocProvider(
            create: (context) => CropBloc(
              dotUtils: DotUtils(),
              imageUtils: ImageUtils(),
            )..add(CropAreaInitialized(
                area: context.read<AppBloc>().state.areaInitial,
                image: state,
                screenSize: screenSize,
                positionImage: Rect.fromLTRB(
                  cropPhotoDocumentStyle.left,
                  cropPhotoDocumentStyle.top + paddingSafeArea.top,
                  cropPhotoDocumentStyle.right,
                  cropPhotoDocumentStyle.bottom + paddingSafeArea.bottom,
                ),
              )),
            child: _CropView(
              cropPhotoDocumentStyle: cropPhotoDocumentStyle,
              image: state,
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    context.read<DocumentScannerController>().changePage(AppPages.takePhoto);
    return false;
  }
}

class _CropView extends StatelessWidget {
  final CropPhotoDocumentStyle cropPhotoDocumentStyle;
  final File image;

  const _CropView({
    Key? key,
    required this.cropPhotoDocumentStyle,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          current.statusCropPhoto != previous.statusCropPhoto,
      listener: (context, state) {
        if (state.statusCropPhoto == AppStatus.loading) {
          context.read<CropBloc>().add(CropPhotoByAreaCropped());
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // * Photo
          // Positioned(
          //   top:
          //       cropPhotoDocumentStyle.top + MediaQuery.of(context).padding.top,
          //   bottom: cropPhotoDocumentStyle.bottom,
          //   left: cropPhotoDocumentStyle.left,
          //   right: cropPhotoDocumentStyle.right,
          //   child: Image.file(
          //     image,
          //     fit: BoxFit.fill,
          //   ),
          // ),

          Align(
            alignment: Alignment.topLeft,
            child: Image.file(
              image,
              fit: BoxFit.fill,
            ),
          ),

          // * Mask
          BlocSelector<CropBloc, CropState, Area>(
            selector: (state) => state.area,
            builder: (context, state) {
              return MaskCrop(
                area: state,
                cropPhotoDocumentStyle: cropPhotoDocumentStyle,
              );
            },
          ),

          // * Border Mask
          BlocSelector<CropBloc, CropState, Area>(
            selector: (state) => state.area,
            builder: (context, state) {
              return CustomPaint(
                painter: BorderCropAreaPainter(
                  area: state,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),

          // * Dot - Top Left
          BlocSelector<CropBloc, CropState, Point>(
            selector: (state) => state.area.topLeft,
            builder: (context, state) {
              return Positioned(
                left: state.x - (cropPhotoDocumentStyle.dotSize / 2),
                top: state.y - (cropPhotoDocumentStyle.dotSize / 2),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<CropBloc>().add(
                          CropDotMoved(
                            deltaX: details.delta.dx,
                            deltaY: details.delta.dy,
                            dotPosition: DotPosition.topLeft,
                          ),
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: cropPhotoDocumentStyle.dotSize,
                    height: cropPhotoDocumentStyle.dotSize,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          cropPhotoDocumentStyle.dotRadius,
                        ),
                        child: Container(
                          width: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          height: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // * Dot - Top Right
          BlocSelector<CropBloc, CropState, Point>(
            selector: (state) => state.area.topRight,
            builder: (context, state) {
              return Positioned(
                left: state.x - (cropPhotoDocumentStyle.dotSize / 2),
                top: state.y - (cropPhotoDocumentStyle.dotSize / 2),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<CropBloc>().add(
                          CropDotMoved(
                            deltaX: details.delta.dx,
                            deltaY: details.delta.dy,
                            dotPosition: DotPosition.topRight,
                          ),
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: cropPhotoDocumentStyle.dotSize,
                    height: cropPhotoDocumentStyle.dotSize,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          cropPhotoDocumentStyle.dotRadius,
                        ),
                        child: Container(
                          width: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          height: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // * Dot - Bottom Left
          BlocSelector<CropBloc, CropState, Point>(
            selector: (state) => state.area.bottomLeft,
            builder: (context, state) {
              return Positioned(
                left: state.x - (cropPhotoDocumentStyle.dotSize / 2),
                top: state.y - (cropPhotoDocumentStyle.dotSize / 2),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<CropBloc>().add(
                          CropDotMoved(
                            deltaX: details.delta.dx,
                            deltaY: details.delta.dy,
                            dotPosition: DotPosition.bottomLeft,
                          ),
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: cropPhotoDocumentStyle.dotSize,
                    height: cropPhotoDocumentStyle.dotSize,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          cropPhotoDocumentStyle.dotRadius,
                        ),
                        child: Container(
                          width: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          height: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // * Dot - Bottom Right
          BlocSelector<CropBloc, CropState, Point>(
            selector: (state) => state.area.bottomRight,
            builder: (context, state) {
              return Positioned(
                left: state.x - (cropPhotoDocumentStyle.dotSize / 2),
                top: state.y - (cropPhotoDocumentStyle.dotSize / 2),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    context.read<CropBloc>().add(
                          CropDotMoved(
                            deltaX: details.delta.dx,
                            deltaY: details.delta.dy,
                            dotPosition: DotPosition.bottomRight,
                          ),
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: cropPhotoDocumentStyle.dotSize,
                    height: cropPhotoDocumentStyle.dotSize,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          cropPhotoDocumentStyle.dotRadius,
                        ),
                        child: Container(
                          width: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          height: cropPhotoDocumentStyle.dotSize - (2 * 2),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // * Default App Bar
          AppBarCropPhoto(
            cropPhotoDocumentStyle: cropPhotoDocumentStyle,
          ),

          // * children
          if (cropPhotoDocumentStyle.children != null)
            ...cropPhotoDocumentStyle.children!,
        ],
      ),
    );
  }
}