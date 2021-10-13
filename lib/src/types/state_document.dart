enum StateDocument {
  /// Camera preview is displayed
  takePictureDocument,

  /// When the picture is being processed
  loadingTakePictureDocument,

  /// View crop the document
  cropDocumentPicture,

  /// When the document is being cropped
  loadingCropDocumentPicture,

  /// View with options to edit the document
  editDocumentPicture,

  /// When applying the filter to the document
  loadingEditDocumentPicture,

  /// When complete save document
  saveDocument,
}
