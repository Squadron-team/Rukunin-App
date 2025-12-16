import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:rukunin/types/image_matrix.dart';

class ImageUtilsPure {
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

  /// Convert RGB image to grayscale
  /// Input: height × width × 3
  /// Output: height × width
  static ImageMatrix toGrayscale(List<List<List<int>>> rgbImage) {
    final height = rgbImage.length;
    final width = rgbImage[0].length;

    return List.generate(height, (y) {
      return List.generate(width, (x) {
        final pixel = rgbImage[y][x];
        final r = pixel[0].toDouble();
        final g = pixel[1].toDouble();
        final b = pixel[2].toDouble();

        return 0.299 * r + 0.587 * g + 0.114 * b;
      });
    });
  }

  /// Resize grayscale image using bilinear interpolation
  static ImageMatrix resizeBilinear(
    ImageMatrix src,
    int newWidth,
    int newHeight,
  ) {
    final srcHeight = src.length;
    final srcWidth = src[0].length;

    final scaleX = srcWidth / newWidth;
    final scaleY = srcHeight / newHeight;

    return List.generate(newHeight, (y) {
      return List.generate(newWidth, (x) {
        final srcX = (x + 0.5) * scaleX - 0.5;
        final srcY = (y + 0.5) * scaleY - 0.5;

        final x0 = srcX.floor().clamp(0, srcWidth - 1);
        final y0 = srcY.floor().clamp(0, srcHeight - 1);
        final x1 = (x0 + 1).clamp(0, srcWidth - 1);
        final y1 = (y0 + 1).clamp(0, srcHeight - 1);

        final dx = srcX - x0;
        final dy = srcY - y0;

        final p00 = src[y0][x0];
        final p01 = src[y0][x1];
        final p10 = src[y1][x0];
        final p11 = src[y1][x1];

        final top = p00 * (1 - dx) + p01 * dx;
        final bottom = p10 * (1 - dx) + p11 * dx;

        return top * (1 - dy) + bottom * dy;
      });
    });
  }

  /// Resize while preserving aspect ratio
  static ImageMatrix resizeKeepAspect(
    ImageMatrix src,
    int targetWidth,
    int targetHeight,
  ) {
    final srcHeight = src.length;
    final srcWidth = src[0].length;

    final scale = min(targetWidth / srcWidth, targetHeight / srcHeight);

    final newWidth = (srcWidth * scale).round();
    final newHeight = (srcHeight * scale).round();

    final resized = resizeBilinear(src, newWidth, newHeight);

    // Pad with zeros (black)
    final padded = List.generate(
      targetHeight,
      (_) => List.generate(targetWidth, (_) => 0.0),
    );

    final offsetX = (targetWidth - newWidth) ~/ 2;
    final offsetY = (targetHeight - newHeight) ~/ 2;

    for (int y = 0; y < newHeight; y++) {
      for (int x = 0; x < newWidth; x++) {
        padded[y + offsetY][x + offsetX] = resized[y][x];
      }
    }

    return padded;
  }

  /// Resize grayscale image to match target dimensions
  static ImageMatrix resizeToMatch(
    ImageMatrix src,
    int targetWidth,
    int targetHeight, {
    bool keepAspect = true,
  }) {
    if (keepAspect) {
      return resizeKeepAspect(src, targetWidth, targetHeight);
    }
    return resizeBilinear(src, targetWidth, targetHeight);
  }
}
