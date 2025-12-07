import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageHelper {
  static Uint8List float32ToPng(Float32List data, int width, int height) {
    final grImage = img.Image(width: width, height: height);

    for (int i = 0; i < data.length; i++) {
      final v = (data[i] * 255).clamp(0, 255).toInt();

      final x = i % width;
      final y = i ~/ width;

      grImage.setPixelRgba(x, y, v, v, v, 255); // grayscale pixel
    }

    return Uint8List.fromList(img.encodePng(grImage));
  }
}
