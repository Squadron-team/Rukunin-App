import 'dart:math';
import 'package:rukunin/types/image_matrix.dart';

class SsimMetric {
  static double structuralSimilarity(
    ImageMatrix imgA,
    ImageMatrix imgB, {
    int windowSize = 7, // Reduced from 11 to 7 for better performance
    int stride = 4, // Add stride to skip pixels (faster computation)
  }) {
    final height = imgA.length;
    final width = imgA[0].length;

    if (height != imgB.length || width != imgB[0].length) {
      throw Exception('Images must have the same size');
    }

    final half = windowSize ~/ 2;
    double ssimSum = 0.0;
    int count = 0;

    // Use stride to reduce number of computations
    for (int y = half; y < height - half; y += stride) {
      for (int x = half; x < width - half; x += stride) {
        final windowA = _extractWindow(imgA, y - half, x - half, windowSize);
        final windowB = _extractWindow(imgB, y - half, x - half, windowSize);

        ssimSum += _ssimForWindow(windowA, windowB);
        count++;
      }
    }

    return count > 0 ? ssimSum / count : 0.0;
  }

  static List<double> _extractWindow(
    ImageMatrix img,
    int startY,
    int startX,
    int size,
  ) {
    final window = <double>[];
    for (int y = startY; y < startY + size; y++) {
      for (int x = startX; x < startX + size; x++) {
        window.add(img[y][x]);
      }
    }
    return window;
  }

  static double _ssimForWindow(
    List<double> windowA,
    List<double> windowB, {
    double c1 = 6.5025, // (0.01 * 255)^2
    double c2 = 58.5225, // (0.03 * 255)^2
  }) {
    final muA = _mean(windowA);
    final muB = _mean(windowB);

    final sigmaA = _stdDev(windowA, muA);
    final sigmaB = _stdDev(windowB, muB);

    final covAB = _covariance(windowA, windowB, muA, muB);

    // Luminance
    final luminance = (2 * muA * muB + c1) / (muA * muA + muB * muB + c1);

    // Contrast
    final contrast =
        (2 * sigmaA * sigmaB + c2) / (sigmaA * sigmaA + sigmaB * sigmaB + c2);

    // Structure
    final structure = (covAB + c2 / 2) / (sigmaA * sigmaB + c2 / 2);

    return luminance * contrast * structure;
  }

  static double _covariance(
    List<double> a,
    List<double> b,
    double meanA,
    double meanB,
  ) {
    double sum = 0.0;
    for (int i = 0; i < a.length; i++) {
      sum += (a[i] - meanA) * (b[i] - meanB);
    }
    return sum / a.length;
  }

  static double _variance(List<double> values, double meanValue) {
    final squaredDiffs = values
        .map((v) => (v - meanValue) * (v - meanValue))
        .reduce((a, b) => a + b);
    return squaredDiffs / values.length;
  }

  static double _stdDev(List<double> values, double meanValue) {
    return sqrt(_variance(values, meanValue));
  }

  static double _mean(List<double> values) {
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }
}
