import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:rukunin/types/image_matrix.dart';
import 'package:rukunin/utils/image_processing/image_utils_pure.dart';
import 'package:rukunin/utils/image_processing/image_utils_ui.dart';
import 'package:rukunin/utils/metrics/ssim_metric.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SsimMetric', () {
    late ImageMatrix receiptMatrix;
    late ImageMatrix img3Matrix;
    late ImageMatrix img4Matrix;
    late ImageMatrix img5Matrix;

    setUpAll(() async {
      // Load and convert images to grayscale matrices using ImageUtils
      receiptMatrix = await _loadImageAsGrayscaleMatrix(
        'assets/ml_test/receipt.jpg',
      );
      img3Matrix = await _loadImageAsGrayscaleMatrix(
        'assets/ml_test/img_3.jpg',
      );
      img4Matrix = await _loadImageAsGrayscaleMatrix(
        'assets/ml_test/img_4.jpg',
      );
      img5Matrix = await _loadImageAsGrayscaleMatrix(
        'assets/ml_test/img_5.jpg',
      );

      // Ensure all images have the same dimensions
      final targetWidth = receiptMatrix[0].length;
      final targetHeight = receiptMatrix.length;

      // Resize img3 and img4 to match receipt dimensions if needed
      if (img3Matrix.length != targetHeight ||
          img3Matrix[0].length != targetWidth) {
        img3Matrix = ImageUtilsPure.resizeToMatch(
          img3Matrix,
          targetWidth,
          targetHeight,
        );
      }

      if (img4Matrix.length != targetHeight ||
          img4Matrix[0].length != targetWidth) {
        img4Matrix = ImageUtilsPure.resizeToMatch(
          img4Matrix,
          targetWidth,
          targetHeight,
        );
      }

      if (img5Matrix.length != targetHeight ||
          img5Matrix[0].length != targetWidth) {
        img5Matrix = ImageUtilsPure.resizeToMatch(
          img5Matrix,
          targetWidth,
          targetHeight,
        );
      }

      print(
        'Receipt dimensions: ${receiptMatrix.length}x${receiptMatrix[0].length}',
      );
      print('img_3 dimensions: ${img3Matrix.length}x${img3Matrix[0].length}');
      print('img_4 dimensions: ${img4Matrix.length}x${img4Matrix[0].length}');
      print('img_5 dimensions: ${img5Matrix.length}x${img5Matrix[0].length}');
    });

    test('should return SSIM close to 1 for identical images', () {
      final ssim = SsimMetric.structuralSimilarity(
        receiptMatrix,
        receiptMatrix,
      );

      expect(
        ssim,
        closeTo(1.0, 0.01),
        reason: 'SSIM should be 1.0 for identical images',
      );
    });

    test('should return SSIM close to 1 for similar images (img_3.jpg)', () {
      final ssim = SsimMetric.structuralSimilarity(receiptMatrix, img3Matrix);

      // Expected: ~0.96 based on skimage reference
      expect(
        ssim,
        greaterThan(0.90),
        reason: 'SSIM should be around 0.96 for similar images',
      );
      expect(ssim, lessThanOrEqualTo(1.0), reason: 'SSIM cannot exceed 1.0');

      print('SSIM for img_3.jpg: $ssim (expected ~0.96)');
    });

    test(
      'should return SSIM close to 0.68 for moderately similar images (img_4.jpg)',
      () {
        final ssim = SsimMetric.structuralSimilarity(receiptMatrix, img4Matrix);

        // Expected: ~0.68 based on skimage reference
        // img_4.jpg is moderately similar, not dissimilar
        expect(
          ssim,
          greaterThan(0.60),
          reason: 'SSIM should be around 0.68 for moderately similar images',
        );
        expect(
          ssim,
          lessThan(0.75),
          reason: 'SSIM should be less than 0.75 for this test case',
        );

        print('SSIM for img_4.jpg: $ssim (expected ~0.68)');
      },
    );

    test(
      'should return SSIM close to 0.75 for moderately-high similar images (img_5.jpg)',
      () {
        final ssim = SsimMetric.structuralSimilarity(receiptMatrix, img5Matrix);

        // Expected: ~0.75 based on requirement
        expect(
          ssim,
          greaterThan(0.70),
          reason:
              'SSIM should be around 0.75 for moderately-high similar images',
        );
        expect(
          ssim,
          lessThan(0.80),
          reason: 'SSIM should be less than 0.80 for this test case',
        );

        print('SSIM for img_5.jpg: $ssim (expected ~0.75)');
      },
    );

    test('should throw exception for images with different sizes', () {
      final smallMatrix = [
        [0.0, 0.0],
        [0.0, 0.0],
      ];

      expect(
        () => SsimMetric.structuralSimilarity(receiptMatrix, smallMatrix),
        throwsException,
      );
    });
  });
}

/// Helper function to load an image and convert it to a grayscale matrix
/// Uses ImageUtils for consistent processing
Future<ImageMatrix> _loadImageAsGrayscaleMatrix(String assetPath) async {
  final file = File(assetPath);
  final bytes = await file.readAsBytes();

  // Use ImageUtils for consistent conversion
  return await ImageUtilsUi.loadAndConvertToGrayscale(bytes);
}
