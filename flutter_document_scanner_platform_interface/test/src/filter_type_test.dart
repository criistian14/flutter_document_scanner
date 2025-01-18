import 'package:flutter_document_scanner_platform_interface/src/filter_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Should return correct values for each enum option',
    () async {
      expect(FilterType.natural.value, 'NATURAL_FILTER');
      expect(FilterType.gray.value, 'GRAY_FILTER');
      expect(FilterType.eco.value, 'ECO_FILTER');
    },
  );
}
