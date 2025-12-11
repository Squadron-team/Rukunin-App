import 'dart:typed_data';
import 'package:flutter/services.dart';

class OnnxService {
  static const _channel = MethodChannel('onnx_runtime');

  /// Load ONNX model from assets and send it to Android native code
  static Future<bool> loadModel(String assetPath) async {
    final raw = await rootBundle.load(assetPath);
    final bytes = raw.buffer.asUint8List();

    final result = await _channel.invokeMethod('loadModel', {
      'modelBytes': bytes,
    });

    return result == true;
  }

  /// Run inference by sending feature vector to native ONNX Runtime
  /// `input` is a Float32List of shape [n_features]
  static Future<List<double>> runInference(Float32List input) async {
    final byteData = input.buffer.asUint8List();

    final result = await _channel.invokeMethod('runInference', {
      'input_bytes': byteData,
      'length': input.length,
    });

    // Convert dynamic result (List<dynamic>) → List<double>
    return (result as List).map((e) => (e as num).toDouble()).toList();
  }
}
