import 'dart:math';

import 'package:flutter_document_scanner_platform_interface/flutter_document_scanner_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test(
      'Should make a Contour from a map',
      () async {
        // arrange
        final tMap = {
          'height': 100,
          'width': 200,
          'points': [
            {'x': 10.5, 'y': 50.8},
            {'x': 0.2, 'y': 8.0},
          ],
        };
        const expectedContour = Contour(
          height: 100,
          width: 200,
          points: [
            Point(10.5, 50.8),
            Point(0.2, 8),
          ],
        );

        // act
        final contour = Contour.fromMap(tMap);

        // assert
        expect(contour, expectedContour);
      },
    );
  });

  test(
    'Should copy with new values',
    () async {
      // arrange
      const tContour = Contour(
        width: 50,
        height: 20,
        points: [
          Point(10.5, 50.8),
          Point(0.2, 8),
        ],
      );
      const expectedContour = Contour(
        height: 100,
        width: 200,
        points: [
          Point(10.5, 50.8),
          Point(0.2, 8),
        ],
      );

      // act
      final newContour = tContour.copyWith(
        height: 100,
        width: 200,
      );

      // assert
      expect(newContour, expectedContour);
      expect(newContour.hashCode, expectedContour.hashCode);
    },
  );

  test(
    'Should return a correct string representation',
    () async {
      // arrange
      const tContour = Contour(
        height: 100,
        width: 200,
        points: [
          Point(10.5, 50.8),
          Point(0.2, 8),
        ],
      );
      const expectedString = 'Contour{'
          'height: 100, '
          'width: 200, '
          'points: [Point(10.5, 50.8), Point(0.2, 8.0)], '
          'image: null '
          '}';

      // act
      final string = tContour.toString();

      // assert
      expect(string, expectedString);
    },
  );

  test(
    'Should ',
    () async {
      // arrange
      const tContour = Contour(
        height: 100,
        width: 200,
        points: [
          Point(10.5, 50.8),
          Point(0.2, 8),
        ],
      );
      final expectedPoints = [
        {'x': 10.5, 'y': 50.8},
        {'x': 0.2, 'y': 8.0},
      ];

      // act
      final points = tContour.pointsAsMap;

      // assert
      expect(points, expectedPoints);
    },
  );
}
