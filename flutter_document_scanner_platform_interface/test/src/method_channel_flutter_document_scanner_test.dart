// Copyright (c) 2021, Christian Betancourt
// https://github.com/criistian14
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_document_scanner_platform_interface/src/contour.dart';
import 'package:flutter_document_scanner_platform_interface/src/errors/errors.dart';
import 'package:flutter_document_scanner_platform_interface/src/filter_type.dart';
import 'package:flutter_document_scanner_platform_interface/src/method_channel_flutter_document_scanner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelFlutterDocumentScanner methodChannelFlutterDocumentScanner;
  final log = <MethodCall>[];

  final tByteData = Uint8List(1);
  const tMinContourArea = 120.0;
  const tContour = Contour(
    points: [
      Point(10.5, 50.8),
      Point(0.2, 8),
      Point(10.5, 50.8),
      Point(0.2, 8),
    ],
  );
  const tFilter = FilterType.natural;

  void setUpSuccess({
    Object? findContourPhoto,
    bool setNullFindContourPhoto = false,
    Object? adjustingPerspective,
    bool setNullAdjustingPerspective = false,
    Object? applyFilter,
    bool setNullApplyFilter = false,
  }) {
    methodChannelFlutterDocumentScanner = MethodChannelFlutterDocumentScanner();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      methodChannelFlutterDocumentScanner.methodChannel,
      (message) {
        log.add(message);

        switch (message.method) {
          case 'findContourPhoto':
            if (setNullFindContourPhoto) {
              return null;
            }

            return Future.value(
              findContourPhoto ??
                  {
                    'height': 100,
                    'width': 200,
                    'points': [
                      {'x': 10.5, 'y': 50.8},
                      {'x': 0.2, 'y': 8.0},
                    ],
                  },
            );

          case 'adjustingPerspective':
            if (setNullAdjustingPerspective) {
              return null;
            }

            return Future.value(adjustingPerspective ?? Uint8List(2));

          case 'applyFilter':
            if (setNullApplyFilter) {
              return null;
            }

            return Future.value(applyFilter ?? Uint8List(2));

          default:
            return null;
        }
      },
    );
  }

  void setUpFailure() {
    methodChannelFlutterDocumentScanner = MethodChannelFlutterDocumentScanner();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      methodChannelFlutterDocumentScanner.methodChannel,
      (message) {
        log.add(message);

        switch (message.method) {
          case 'findContourPhoto':
            throw Exception('Custom error');

          case 'adjustingPerspective':
            throw Exception('Custom error');

          case 'applyFilter':
            throw Exception('Custom error');

          default:
            return null;
        }
      },
    );
  }

  tearDown(log.clear);

  group('findContourPhoto', () {
    test(
      'Should return a Contour',
      () async {
        // arrange
        setUpSuccess();

        const expectedContour = Contour(
          height: 100,
          width: 200,
          points: [
            Point(10.5, 50.8),
            Point(0.2, 8),
          ],
        );

        // act
        final contour =
            await methodChannelFlutterDocumentScanner.findContourPhoto(
          byteData: tByteData,
          minContourArea: tMinContourArea,
        );

        // assert
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'findContourPhoto',
              arguments: {
                'byteData': tByteData,
                'minContourArea': tMinContourArea,
              },
            ),
          ],
        );
        expect(contour, expectedContour);
      },
    );

    test(
      'Should throw InvalidByteDataError when byteData is empty or invalid',
      () async {
        try {
          // act
          await methodChannelFlutterDocumentScanner.findContourPhoto(
            byteData: Uint8List.fromList([]),
            minContourArea: tMinContourArea,
          );
        } catch (e) {
          // assert
          expect(e, isA<PlatformError>());
          expect((e as InvalidByteDataError).byteData, Uint8List.fromList([]));
        }
      },
    );

    test(
      'Should throw InvalidMinContourAreaError when minContourArea '
      'is less than or equal to 0',
      () async {
        try {
          // act
          await methodChannelFlutterDocumentScanner.findContourPhoto(
            byteData: tByteData,
            minContourArea: -10,
          );
        } catch (e) {
          // assert
          expect(e, isA<ContourError>());
          expect((e as InvalidMinContourAreaError).minContourArea, -10);
        }
      },
    );

    test(
      'Should throw ContourNullError when the returned contour is null',
      () async {
        // arrange
        setUpSuccess(setNullFindContourPhoto: true);

        try {
          // act
          await methodChannelFlutterDocumentScanner.findContourPhoto(
            byteData: tByteData,
            minContourArea: tMinContourArea,
          );
        } catch (e) {
          // assert
          expect(e, isA<ContourError>());
          expect(e, isA<ContourNullError>());
        }
      },
    );

    test(
      'Should throw InvalidContourDataError when the returned '
      'contour data is not a valid Map',
      () async {
        // arrange
        final tMapError = {
          'height': 100,
          'width': 200,
        };
        setUpSuccess(findContourPhoto: tMapError);

        try {
          // act
          await methodChannelFlutterDocumentScanner.findContourPhoto(
            byteData: tByteData,
            minContourArea: tMinContourArea,
          );
        } catch (e) {
          // assert
          expect(e, isA<ContourError>());
          expect((e as InvalidContourDataError).result, tMapError);
        }
      },
    );

    test(
      'Should throw an error',
      () async {
        // arrange
        setUpFailure();

        try {
          // act
          await methodChannelFlutterDocumentScanner.findContourPhoto(
            byteData: tByteData,
            minContourArea: tMinContourArea,
          );
        } catch (e) {
          // assert
          expect(e, isA<Exception>());
          expect(e.toString(), contains('Custom error'));
        }
      },
    );
  });

  group('adjustingPerspective', () {
    test(
      'Should return bytes of the adjusted image',
      () async {
        // arrange
        setUpSuccess();
        final expectedImage = Uint8List(2);

        // act
        final newImage =
            await methodChannelFlutterDocumentScanner.adjustingPerspective(
          byteData: tByteData,
          contour: tContour,
        );

        // assert
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'adjustingPerspective',
              arguments: {
                'byteData': tByteData,
                'points': tContour.pointsAsMap,
              },
            ),
          ],
        );
        expect(newImage, expectedImage);
      },
    );

    test(
      'Should throw InvalidByteDataError when byteData is empty or invalid',
      () async {
        try {
          // act
          await methodChannelFlutterDocumentScanner.adjustingPerspective(
            byteData: Uint8List.fromList([]),
            contour: tContour,
          );
        } catch (e) {
          // assert
          expect(e, isA<PlatformError>());
          expect((e as InvalidByteDataError).byteData, Uint8List.fromList([]));
        }
      },
    );

    test(
      'Should throw InsufficientContourPointsError when points '
      'is less than to 4',
      () async {
        // arrange
        const tContour = Contour(
          points: [
            Point(10.5, 50.8),
            Point(0.2, 8),
            Point(10.5, 50.8),
          ],
        );

        try {
          // act
          await methodChannelFlutterDocumentScanner.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          );
        } catch (e) {
          // assert
          expect(e, isA<PerspectiveError>());
          expect((e as InsufficientContourPointsError).points, tContour.points);
        }
      },
    );

    test(
      'Should throw InvalidContourPointsError when a point has NaN values',
      () async {
        // arrange
        const tContour = Contour(
          points: [
            Point(10.5, 50.8),
            Point(double.nan, 8),
            Point(10.5, 50.8),
            Point(0.2, double.nan),
          ],
        );

        try {
          // act
          await methodChannelFlutterDocumentScanner.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          );
        } catch (e) {
          // assert
          expect(e, isA<InvalidContourPointsError>());
          expect((e as InvalidContourPointsError).points, tContour.points);
        }
      },
    );

    test(
      'Should throw PerspectiveAdjustmentNullError when result is null',
      () async {
        // arrange
        setUpSuccess(setNullAdjustingPerspective: true);

        try {
          // act
          await methodChannelFlutterDocumentScanner.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          );
        } catch (e) {
          // assert
          expect(e, isA<PerspectiveAdjustmentNullError>());
        }
      },
    );

    test(
      'Should throw PlatformError when platform method fails',
      () async {
        // arrange
        setUpFailure();

        try {
          // act
          await methodChannelFlutterDocumentScanner.adjustingPerspective(
            byteData: tByteData,
            contour: tContour,
          );
        } catch (e) {
          // assert
          expect(e, isA<PlatformError>());
          expect(
            (e as PlatformError).message,
            contains('Failed to adjust perspective'),
          );
        }
      },
    );
  });

  group('applyFilter', () {
    test(
      'Should return bytes of the filtered image',
      () async {
        // arrange
        setUpSuccess();
        final expectedImage = Uint8List(2);

        // act
        final newImage = await methodChannelFlutterDocumentScanner.applyFilter(
          byteData: tByteData,
          filter: tFilter,
        );

        // assert
        expect(
          log,
          <Matcher>[
            isMethodCall(
              'applyFilter',
              arguments: {
                'byteData': tByteData,
                'filter': tFilter.value,
              },
            ),
          ],
        );
        expect(newImage, expectedImage);
      },
    );

    test(
      'Should throw an exception when byteData is empty',
      () async {
        try {
          // act
          await methodChannelFlutterDocumentScanner.applyFilter(
            byteData: Uint8List.fromList([]),
            filter: tFilter,
          );
        } catch (e) {
          // assert
          expect(e, isA<Exception>());
        }
      },
    );

    test(
      'Should throw an exception when result is null',
      () async {
        // arrange
        setUpSuccess(setNullApplyFilter: true);

        try {
          // act
          await methodChannelFlutterDocumentScanner.applyFilter(
            byteData: tByteData,
            filter: tFilter,
          );
        } catch (e) {
          // assert
          expect(e, isA<Exception>());
        }
      },
    );

    test(
      'Should throw an exception when method channel fails',
      () async {
        // arrange
        setUpFailure();

        try {
          // act
          await methodChannelFlutterDocumentScanner.applyFilter(
            byteData: tByteData,
            filter: tFilter,
          );
        } catch (e) {
          // assert
          expect(e, isA<Exception>());
        }
      },
    );
  });
}
