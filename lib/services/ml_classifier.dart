import 'dart:typed_data';
import 'package:rukunin/native/feature_extractor_ffi.dart';
import 'package:rukunin/services/onnx_service.dart';

final _extractor = FeatureExtractorFfi();

Future<int> classifyGrayscaleImage(
  Uint8List grayscaleBytes,
  int width,
  int height,
) async {
  final features = _extractor.compute(grayscaleBytes, width, height);

  final outputs = await OnnxService.runInference(features);

  int bestIdx = 0;
  double bestVal = outputs[0];
  for (int i = 1; i < outputs.length; i++) {
    if (outputs[i] > bestVal) {
      bestVal = outputs[i];
      bestIdx = i;
    }
  }

  return bestIdx;
}
