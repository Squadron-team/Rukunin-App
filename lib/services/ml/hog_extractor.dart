import 'dart:typed_data';
import 'dart:math' as math;

class HogExtractor {
  final int orientations = 9;
  final int cellSize = 8;
  final int blockSize = 2; // 2×2 cells
  final double eps = 1e-5;

  /// grayscale: Float32List of length 4096 (64×64)
  Float32List compute(Float32List grayscale) {
    const width = 64;
    const height = 64;

    // 1. Compute gradients using simple [-1, 0, 1] kernel
    final gx = Float32List(width * height);
    final gy = Float32List(width * height);

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final idx = y * width + x;

        gx[idx] = grayscale[idx + 1] - grayscale[idx - 1];
        gy[idx] = grayscale[idx + width] - grayscale[idx - width];
      }
    }

    // 2. Magnitude and orientation
    final mag = Float32List(width * height);
    final angle = Float32List(width * height);

    for (int i = 0; i < width * height; i++) {
      final gxi = gx[i];
      final gyi = gy[i];
      mag[i] = math.sqrt(gxi * gxi + gyi * gyi);

      // angle in degrees [0,180)
      angle[i] = (math.atan2(gyi, gxi) * (180 / math.pi)) % 180;
      if (angle[i] < 0) angle[i] += 180;
    }

    // 3. Cell histograms
    final cellsX = width ~/ cellSize; // = 8
    final cellsY = height ~/ cellSize; // = 8

    // cellsY × cellsX × orientations
    final cellHist = List.generate(
      cellsY,
      (_) => List.generate(cellsX, (_) => Float32List(orientations)),
    );

    for (int cy = 0; cy < cellsY; cy++) {
      for (int cx = 0; cx < cellsX; cx++) {
        for (int y = 0; y < cellSize; y++) {
          for (int x = 0; x < cellSize; x++) {
            final iy = cy * cellSize + y;
            final ix = cx * cellSize + x;
            final idx = iy * width + ix;

            final m = mag[idx];
            final a = angle[idx];

            // orientation bin
            final bin = (a / (180 / orientations)).floor();
            final clampedBin = math.min(bin, orientations - 1);

            cellHist[cy][cx][clampedBin] += m;
          }
        }
      }
    }

    // 4. Block normalization (2×2 blocks, L2-Hys)
    final blocksY = cellsY - 1; // 7
    final blocksX = cellsX - 1; // 7

    final List<double> features = [];

    for (int by = 0; by < blocksY; by++) {
      for (int bx = 0; bx < blocksX; bx++) {
        // Collect 2×2 cells → 36 values
        final block = Float32List(orientations * blockSize * blockSize);
        int k = 0;

        for (int cy = 0; cy < blockSize; cy++) {
          for (int cx = 0; cx < blockSize; cx++) {
            final hist = cellHist[by + cy][bx + cx];
            for (int o = 0; o < orientations; o++) {
              block[k++] = hist[o];
            }
          }
        }

        // L2-Hys normalization
        double norm = 0;
        for (final v in block) {
          norm += v * v;
        }
        norm = math.sqrt(norm) + eps;

        for (int i = 0; i < block.length; i++) {
          block[i] = block[i] / norm;
        }

        // Append to output features
        features.addAll(block);
      }
    }

    return Float32List.fromList(features);
  }
}
