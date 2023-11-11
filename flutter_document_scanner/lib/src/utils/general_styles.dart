// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';

/// The style of the document scanner.
@immutable
class GeneralStyles {
  /// Create a instance of [GeneralStyles].
  const GeneralStyles({
    this.hideDefaultBottomNavigation = false,
    this.hideDefaultDialogs = false,
    this.baseColor = Colors.white,
    this.messageTakingPicture = 'Taking picture',
    this.messageCroppingPicture = 'Cropping picture',
    this.messageEditingPicture = 'Editing picture',
    this.messageSavingPicture = 'Saving picture',
    this.showCameraPreview = true,
    this.widgetInsteadOfCameraPreview,
  });

  /// Hide the default bottom navigation.
  final bool hideDefaultBottomNavigation;

  /// Hide the default dialogs of the app.
  final bool hideDefaultDialogs;

  /// The base color of the app.
  final Color baseColor;

  /// Message to be displayed when taking picture
  /// (only if [hideDefaultDialogs] is false)
  final String messageTakingPicture;

  /// Message to be displayed when cropping picture
  /// (only if [hideDefaultDialogs] is false)
  final String messageCroppingPicture;

  /// Message to be displayed when editing picture
  /// (only if [hideDefaultDialogs] is false)
  final String messageEditingPicture;

  /// Message to be displayed when saving picture
  /// (only if [hideDefaultDialogs] is false)
  final String messageSavingPicture;

  /// Show the camera preview
  final bool showCameraPreview;

  /// Widget to be displayed instead of the camera preview
  /// (only if [showCameraPreview] is false)
  ///
  /// If this is null, a SizedBox.shrink() will be displayed
  final Widget? widgetInsteadOfCameraPreview;
}
