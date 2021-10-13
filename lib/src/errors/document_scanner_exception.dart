class DocumentScannerException implements Exception {
  String code;
  String description;

  DocumentScannerException({
    this.code,
    this.description,
  });

  @override
  String toString() {
    return "DocumentScannerException: $code, $description";
  }
}
