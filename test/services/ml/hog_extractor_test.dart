import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:rukunin/services/ml/hog_extractor.dart';

void main() {
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
  });
}
