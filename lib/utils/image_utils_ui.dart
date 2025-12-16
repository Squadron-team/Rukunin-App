import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:rukunin/types/image_matrix.dart';
import 'package:rukunin/utils/image_utils_pure.dart';

class ImageUtilsUi {
  static Future<Uint8List> loadAssetImage(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  static Future<ui.Image> decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<Uint8List> getRgbaBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    if (byteData == null) {
      throw Exception('Failed to extract pixel data');
    }

    return byteData.buffer.asUint8List();
  }

  static List<List<List<int>>> rgbaToRgbMatrix(
    Uint8List rgbaBytes,
    int width,
    int height,
  ) {
    final rgb = List.generate(
      height,
      (_) => List.generate(width, (_) => [0, 0, 0]),
    );

    int i = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final r = rgbaBytes[i];
        final g = rgbaBytes[i + 1];
        final b = rgbaBytes[i + 2];
        // final a = rgbaBytes[i + 3]; // ignored

        rgb[y][x] = [r, g, b];
        i += 4;
      }
    }

    return rgb;
  }

  /// Convert image bytes to RGB matrix for test environment
  /// This works with both Flutter assets and file system images
  static Future<List<List<List<int>>>> bytesToRgbMatrix(Uint8List bytes) async {
    final image = await decodeImage(bytes);
    final rgbaBytes = await getRgbaBytes(image);
    return rgbaToRgbMatrix(rgbaBytes, image.width, image.height);
  }

  /// Load and convert image to grayscale matrix
  /// Works in both app and test environments
  static Future<ImageMatrix> loadAndConvertToGrayscale(
    Uint8List bytes, {
    int? maxDimension,
  }) async {
    final image = await decodeImage(bytes);

    // Optionally downscale for performance
    ui.Image processedImage = image;
    if (maxDimension != null) {
      final scale = min(1.0, maxDimension / max(image.width, image.height));
      if (scale < 1.0) {
        final newWidth = (image.width * scale).round();
        final newHeight = (image.height * scale).round();

        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        canvas.scale(scale);
        canvas.drawImage(image, Offset.zero, Paint());

        final picture = pictureRecorder.endRecording();
        processedImage = await picture.toImage(newWidth, newHeight);
      }
    }

    final rgbaBytes = await getRgbaBytes(processedImage);
    final rgbMatrix = rgbaToRgbMatrix(
      rgbaBytes,
      processedImage.width,
      processedImage.height,
    );
    return ImageUtilsPure.toGrayscale(rgbMatrix);
  }
}
