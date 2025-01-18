class FilterError implements Exception {
  FilterError(this.message);

  final String message;

  @override
  String toString() => 'FilterError: $message';
}

/// Thrown when the result of applying the filter is null.
class FilterResultNullError extends FilterError {
  FilterResultNullError() : super('The result of applying the filter is null.');
}

/// Thrown when the provided filter type is invalid or unsupported.
class UnsupportedFilterTypeError extends FilterError {
  UnsupportedFilterTypeError(this.filterType)
      : super('The provided filter type is unsupported ($filterType).');

  final String filterType;
}
