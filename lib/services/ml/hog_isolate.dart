import 'dart:typed_data';
import 'package:rukunin/services/ml/hog_extractor.dart';

/// Runs HOG in an isolate.
/// Input: Float32List (64x64 grayscale)
/// Output: Float32List (1764 features)
Float32List hogIsolateEntry(Float32List grayscale) {
  final hog = HogExtractor();
  return hog.compute(grayscale);
}
