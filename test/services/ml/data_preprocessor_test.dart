import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:rukunin/services/ml/data_preprocessor.dart';

void main() {
  // This is needed to load assets in tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DataPreprocessor', () {
    test(
      'compute should return a 64x64 single-channel (grayscale) image as Float32List',
      () {
        // Arrange
        final preprocessor = DataPreprocessor();

        // Create a dummy 100x100 red image
        final dummyImage = img.Image(width: 100, height: 100);
        img.fill(dummyImage, color: img.ColorRgb8(255, 0, 0));

        // Encode it to PNG bytes
        final rawImage = Uint8List.fromList(img.encodePng(dummyImage));

        // Act
        final grayscaleNorm = preprocessor.compute(rawImage);

        // Assert
        // 1. Check if the output has the correct size for a 64x64 image.
        expect(
          grayscaleNorm.length,
          64 * 64,
          reason: 'Output should have 4096 elements for a 64x64 image.',
        );

        // 2. Check if it's a single-channel (grayscale) normalized image.
        // All values should be between 0.0 and 1.0.
        expect(
          grayscaleNorm.every((p) => p >= 0.0 && p <= 1.0),
          isTrue,
          reason:
              'All grayscale values should be normalized between 0.0 and 1.0.',
        );
      },
    );

    testWidgets('compute should correctly process real image assets', (
      WidgetTester tester,
    ) async {
      // Arrange
      final preprocessor = DataPreprocessor();
      final imagePaths = [
        'assets/ml_test/img_0.png',
        'assets/ml_test/img_1.png',
      ];

      for (final path in imagePaths) {
        // Act
        final byteData = await rootBundle.load(path);
        final rawImage = byteData.buffer.asUint8List();
        final grayscaleNorm = preprocessor.compute(rawImage);

        // Assert
        expect(
          grayscaleNorm.length,
          64 * 64,
          reason:
              'Output for $path should have 4096 elements for a 64x64 image.',
        );

        expect(
          grayscaleNorm.every((p) => p >= 0.0 && p <= 1.0),
          isTrue,
          reason:
              'All grayscale values for $path should be normalized between 0.0 and 1.0.',
        );
      }
    });
  });
}
