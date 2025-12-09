import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:rukunin/native/feature_extractor_ffi.dart';
import 'package:rukunin/services/onnx_service.dart';

class OnnxTestPage extends StatefulWidget {
  const OnnxTestPage({super.key});

  @override
  State<OnnxTestPage> createState() => _OnnxTestPageState();
}

class _OnnxTestPageState extends State<OnnxTestPage> {
  String status = 'Not loaded';
  String inferenceResult = '';
  bool isLoading = false;
  final _extractor = FeatureExtractorFfi();
  String? currentImagePath;
  Uint8List? currentImageBytes;

  Future<void> _load() async {
    setState(() {
      isLoading = true;
      status = 'Loading model...';
    });

    try {
      final ok = await OnnxService.loadModel(
        'assets/models/image_classifier_linreg.onnx',
      );

      if (!mounted) return;

      setState(() {
        status = ok ? 'Model loaded successfully 🎉' : 'Failed to load model';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Error loading model: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _runTestInference(List<double> features, String testName) async {
    setState(() {
      isLoading = true;
      inferenceResult = 'Running inference...';
    });

    try {
      final input = Float32List.fromList(features);
      final outputs = await OnnxService.runInference(input);

      // Find predicted class (highest probability)
      int predictedClass = 0;
      double maxProb = outputs[0];
      for (int i = 1; i < outputs.length; i++) {
        if (outputs[i] > maxProb) {
          maxProb = outputs[i];
          predictedClass = i;
        }
      }

      if (!mounted) return;

      setState(() {
        inferenceResult =
            '''
Test: $testName
Input Features: ${features.map((e) => e.toStringAsFixed(3)).join(', ')}

Predicted Class: $predictedClass
Confidence: ${(maxProb * 100).toStringAsFixed(2)}%

All Class Probabilities:
${outputs.asMap().entries.map((e) => '  Class ${e.key}: ${(e.value * 100).toStringAsFixed(2)}%').join('\n')}
        ''';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        inferenceResult = 'Error during inference: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _runImageInference(String assetPath, String testName) async {
    setState(() {
      isLoading = true;
      inferenceResult = 'Loading and processing image...';
      currentImagePath = assetPath;
    });

    try {
      // Load image from assets
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Store original image bytes for display
      setState(() {
        currentImageBytes = bytes;
      });

      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Convert to grayscale
      final grayscale = img.grayscale(image);
      final width = grayscale.width;
      final height = grayscale.height;

      // Extract grayscale bytes
      final Uint8List grayscaleBytes = Uint8List(width * height);
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final pixel = grayscale.getPixel(x, y);
          grayscaleBytes[y * width + x] = pixel.r.toInt();
        }
      }

      // Extract features using native code
      final features = _extractor.compute(grayscaleBytes, width, height);

      // Run inference
      final outputs = await OnnxService.runInference(features);

      // Find predicted class
      int predictedClass = 0;
      double maxProb = outputs[0];
      for (int i = 1; i < outputs.length; i++) {
        if (outputs[i] > maxProb) {
          maxProb = outputs[i];
          predictedClass = i;
        }
      }

      if (!mounted) return;

      setState(() {
        inferenceResult =
            '''
Test: $testName
Image: $assetPath
Image Size: ${width}x$height

Extracted Features:
  Mean: ${features[0].toStringAsFixed(3)}
  Std Dev: ${features[1].toStringAsFixed(3)}
  Min: ${features[2].toStringAsFixed(3)}
  Max: ${features[3].toStringAsFixed(3)}

Predicted Class: $predictedClass
Confidence: ${(maxProb * 100).toStringAsFixed(2)}%

All Class Probabilities:
${outputs.asMap().entries.map((e) => '  Class ${e.key}: ${(e.value * 100).toStringAsFixed(2)}%').join('\n')}
        ''';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        inferenceResult = 'Error during image inference: $e';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ONNX Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Model Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Model Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(status, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image Test Buttons
            const Text(
              'Test with Images:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _runImageInference(
                            'assets/ml_test/img_0.png',
                            'Test Image 1',
                          ),
                    icon: const Icon(Icons.image),
                    label: const Text('Test Image 1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => _runImageInference(
                            'assets/ml_test/img_1.png',
                            'Test Image 2',
                          ),
                    icon: const Icon(Icons.image),
                    label: const Text('Test Image 2'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image Preview Card
            if (currentImageBytes != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Image',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: Image.memory(
                            currentImageBytes!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentImagePath ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (currentImageBytes != null) const SizedBox(height: 16),

            // Test Buttons with manual features
            const Text(
              'Test with Manual Features:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            currentImageBytes = null;
                            currentImagePath = null;
                          });
                          _runTestInference([0.5, 0.3, 0.2, 0.8], 'Sample 1');
                        },
                  child: const Text('Test Sample 1'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            currentImageBytes = null;
                            currentImagePath = null;
                          });
                          _runTestInference([
                            0.1,
                            0.1,
                            0.0,
                            0.2,
                          ], 'Sample 2 (Low)');
                        },
                  child: const Text('Test Sample 2'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            currentImageBytes = null;
                            currentImagePath = null;
                          });
                          _runTestInference([
                            0.9,
                            0.7,
                            0.8,
                            1.0,
                          ], 'Sample 3 (High)');
                        },
                  child: const Text('Test Sample 3'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            currentImageBytes = null;
                            currentImagePath = null;
                          });
                          _runTestInference([0.0, 0.0, 0.0, 0.0], 'All Zeros');
                        },
                  child: const Text('Test Zeros'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Results Card
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inference Results',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (inferenceResult.isEmpty)
                          const Text(
                            'Click a test button to run inference',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          )
                        else
                          Text(
                            inferenceResult,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
