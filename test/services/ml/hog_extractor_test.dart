import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rukunin/services/ml/data_preprocessor.dart';
import 'package:rukunin/services/ml/hog_extractor.dart';

void main() {
  // This is needed to load assets in tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HogExtractor', () {
    test('compute should return 2916 features for a 64x64 image', () {
      // Arrange
      final hogExtractor = HogExtractor();
      final image = Float32List(64 * 64);

      // Fill image with some dummy data to avoid all-zero gradients
      for (int i = 0; i < image.length; i++) {
        image[i] = (i % 255).toDouble();
      }

      // Act
      final features = hogExtractor.compute(image);

      // Assert
      expect(
        features.length,
        2916,
        reason: 'HOG features for a 64x64 image should be 2916',
      );
    });

    testWidgets('compute should return 2916 features for real image assets', (
      WidgetTester tester,
    ) async {
      // Arrange
      final preprocessor = DataPreprocessor();
      final hogExtractor = HogExtractor();
      final imagePaths = [
        'assets/ml_test/img_0.png',
        'assets/ml_test/img_1.png',
      ];

      for (final path in imagePaths) {
        // Act
        // 1. Load and preprocess the image
        final byteData = await rootBundle.load(path);
        final rawImage = byteData.buffer.asUint8List();
        final grayscaleImage = preprocessor.compute(rawImage);

        // 2. Compute HOG features
        final features = hogExtractor.compute(grayscaleImage);

        // Assert
        expect(
          features.length,
          2916,
          reason: 'HOG features for preprocessed image $path should be 2916',
        );
      }
    });
  });
}
