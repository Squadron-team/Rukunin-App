import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

typedef _ComputeFeaturesNative =
    Void Function(
      Pointer<Uint8>, // img data
      Int32, // width
      Int32, // height
      Pointer<Float>, // output features
    );

typedef _ComputeFeaturesDart =
    void Function(Pointer<Uint8>, int, int, Pointer<Float>);

class FeatureExtractorFfi {
  late final DynamicLibrary _lib;
  late final _ComputeFeaturesDart _compute;

  FeatureExtractorFfi() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libfeature_extractor.so');
    } else if (Platform.isIOS) {
      // iOS uses the library name without 'lib' prefix and extension
      _lib = DynamicLibrary.process();
      // (we'll handle iOS build later; for now focus Android)
    } else {
      throw UnsupportedError('Platform not supported');
    }

    _compute = _lib
        .lookup<NativeFunction<_ComputeFeaturesNative>>('compute_features')
        .asFunction<_ComputeFeaturesDart>();
  }

  /// imageBytes: grayscale bytes, length = width*height
  /// width, height: must match what you pass
  Float32List compute(Uint8List imageBytes, int width, int height) {
    assert(imageBytes.length == width * height);

    final imgPtr = malloc<Uint8>(imageBytes.length);
    final outPtr = malloc<Float>(4);

    // Copy Dart bytes into native memory
    imgPtr.asTypedList(imageBytes.length).setAll(0, imageBytes);

    _compute(imgPtr, width, height, outPtr);

    final result = Float32List(4);
    for (var i = 0; i < 4; i++) {
      result[i] = outPtr[i];
    }

    malloc.free(imgPtr);
    malloc.free(outPtr);

    return result;
  }
}
