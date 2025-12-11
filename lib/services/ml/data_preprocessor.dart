import 'dart:typed_data';
import 'package:image/image.dart' as img;

class DataPreprocessor {
  Float32List compute(Uint8List rawImage) {
    // Decode the image
    final decoded = img.decodeImage(rawImage);
    if (decoded == null) {
      throw Exception('Failed to decode image');
    }

    // 1. Resize to 64×64 (match Python)
    final resized = img.copyResize(
      decoded,
      width: 64,
      height: 64,
      // optional: choose interpolation if you want to experiment
      // interpolation: img.Interpolation.average,
    );

    // 2. Convert to grayscale (match skimage.rgb2gray style)
    final width = resized.width;
    final height = resized.height; // should be 64x64
    final grayscaleNorm = Float32List(width * height);

    int index = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y); // returns a Pixel

        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;

        // skimage.rgb2gray-like formula
        final gray = 0.2125 * r + 0.7154 * g + 0.0721 * b;

        grayscaleNorm[index++] = gray;
      }
    }

    return grayscaleNorm;
  }
}
