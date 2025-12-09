import 'dart:typed_data';
import 'dart:math' as math;

class HogExtractor {
  final int orientations = 9; // HOG bins
  final int cellSize = 8; // 8×8 pixels per cell
  final int blockSize = 2; // 2×2 cells per block
  final double eps = 1e-5;

  /// Input MUST be 64×64 grayscale Float32List
  Float32List compute(Float32List img) {
    const int width = 64;
    const int height = 64;

    final gx = Float32List(width * height);
    final gy = Float32List(width * height);

    // Gradient filters [-1, 0, 1]
    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final idx = y * width + x;
        gx[idx] = img[idx + 1] - img[idx - 1];
        gy[idx] = img[idx + width] - img[idx - width];
      }
    }

    final mag = Float32List(width * height);
    final angle = Float32List(width * height);

    // Magnitude + orientation
    for (int i = 0; i < width * height; i++) {
      final mx = gx[i];
      final my = gy[i];
      mag[i] = math.sqrt(mx * mx + my * my);

      double a = math.atan2(my, mx) * 180.0 / math.pi;
      if (a < 0) a += 180.0;

      // 🔥 Important fix: avoid angle = 180.0 exactly
      if (a >= 180.0) a = 179.999999;

      angle[i] = a;
    }

    // Cells: 8×8
    final int cellsX = width ~/ cellSize;
    final int cellsY = height ~/ cellSize;

    final cellHist = List.generate(
      cellsY,
      (_) => List.generate(cellsX, (_) => Float32List(orientations)),
    );

    final double binSize = 180.0 / orientations;

    // -----------------------
    // Pixel → Cell histogram
    // -----------------------
    for (int cy = 0; cy < cellsY; cy++) {
      for (int cx = 0; cx < cellsX; cx++) {
        for (int y = 0; y < cellSize; y++) {
          for (int x = 0; x < cellSize; x++) {
            final iy = cy * cellSize + y;
            final ix = cx * cellSize + x;
            final idx = iy * width + ix;

            final m = mag[idx];
            final a = angle[idx];

            double binPos = a / binSize;

            // 🔥 FIX: avoid floating point giving binPos = 9.0
            if (binPos >= orientations) {
              binPos = orientations - 1e-6;
            }

            int bin0 = binPos.floor();
            int bin1 = (bin0 + 1) % orientations;

            double w1 = binPos - bin0;
            double w0 = 1.0 - w1;

            cellHist[cy][cx][bin0] += m * w0;
            cellHist[cy][cx][bin1] += m * w1;
          }
        }
      }
    }

    // -----------------------
    // BLOCK NORMALIZATION
    // -----------------------
    final int blocksX = cellsX - 1;
    final int blocksY = cellsY - 1;

    final List<double> features = [];

    for (int by = 0; by < blocksY; by++) {
      for (int bx = 0; bx < blocksX; bx++) {
        final block = Float32List(blockSize * blockSize * orientations);
        int k = 0;

        // Collect 4 cell histograms = 36 values
        for (int cy = 0; cy < blockSize; cy++) {
          for (int cx = 0; cx < blockSize; cx++) {
            final hist = cellHist[by + cy][bx + cx];
            for (int o = 0; o < orientations; o++) {
              block[k++] = hist[o];
            }
          }
        }

        // L2-norm
        double norm = eps;
        for (final v in block) {
          norm += v * v;
        }
        norm = math.sqrt(norm);

        for (int i = 0; i < block.length; i++) {
          block[i] /= norm;
        }

        // Hys clipping at 0.2
        for (int i = 0; i < block.length; i++) {
          if (block[i] > 0.2) block[i] = 0.2;
        }

        // Renormalize
        double norm2 = eps;
        for (final v in block) {
          norm2 += v * v;
        }
        norm2 = math.sqrt(norm2);

        for (int i = 0; i < block.length; i++) {
          block[i] /= norm2;
        }

        features.addAll(block);
      }
    }

    // scikit-image fills up to 2916 features
    while (features.length < 2916) {
      features.add(0.0);
    }

    return Float32List.fromList(features);
  }
}
