import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rukunin/services/ml/data_preprocessor.dart';
import 'package:rukunin/services/ml/hog_extractor.dart';
import 'package:rukunin/services/ml/onnx_service.dart';

class OnnxTestPage extends StatefulWidget {
  const OnnxTestPage({super.key});

  @override
  State<OnnxTestPage> createState() => _OnnxTestPageState();
}

class _OnnxTestPageState extends State<OnnxTestPage> {
  String status = 'Not loaded';
  bool isLoading = false;
  String? currentImagePath;
  Uint8List? currentImageBytes;
  final _dataPreprocessor = DataPreprocessor();
  final _hogExtractor = HogExtractor();

  // Inference results
  String? testName;
  List<double>? inputFeatures;
  int? predictedClass;
  double? confidence;
  List<double>? allProbabilities;
  int? imageWidth;
  int? imageHeight;

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

  Future<void> _runTestInference(List<double> features, String name) async {
    setState(() {
      isLoading = true;
      testName = name;
      inputFeatures = features;
      predictedClass = null;
      confidence = null;
      allProbabilities = null;
      imageWidth = null;
      imageHeight = null;
    });

    try {
      final input = Float32List.fromList(features);
      final outputs = await OnnxService.runInference(input);

      int predClass = 0;
      double maxProb = outputs[0];
      for (int i = 1; i < outputs.length; i++) {
        if (outputs[i] > maxProb) {
          maxProb = outputs[i];
          predClass = i;
        }
      }

      if (!mounted) return;

      setState(() {
        predictedClass = predClass;
        confidence = maxProb;
        allProbabilities = outputs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        testName = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _runImageInference(String assetPath, String name) async {
    setState(() {
      isLoading = true;
      currentImagePath = assetPath;
      testName = name;
      inputFeatures = null;
      predictedClass = null;
      confidence = null;
      allProbabilities = null;
      imageWidth = null;
      imageHeight = null;
    });

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      setState(() {
        currentImageBytes = bytes;
      });

      final preprocessedImage = _dataPreprocessor.compute(bytes);
      final features = _hogExtractor.compute(preprocessedImage);

      setState(() {
        inputFeatures = features.take(4).toList();
        imageWidth = image.width;
        imageHeight = image.height;
      });

      final outputs = await OnnxService.runInference(features);

      int predClass = 0;
      double maxProb = -double.infinity;

      for (int i = 0; i < outputs.length; i++) {
        if (outputs[i] > maxProb) {
          maxProb = outputs[i];
          predClass = i;
        }
      }

      if (!mounted) return;

      setState(() {
        predictedClass = predClass;
        confidence = maxProb;
        allProbabilities = outputs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        testName = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Widget _buildResultsCard() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (testName == null) {
      return const Text(
        'Click a test button to run inference',
        style: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultRow('Test', testName!),
        if (currentImagePath != null) ...[
          const SizedBox(height: 8),
          _buildResultRow('Image', currentImagePath!),
          if (imageWidth != null && imageHeight != null)
            _buildResultRow('Image Size', '${imageWidth}x$imageHeight'),
        ],
        if (inputFeatures != null) ...[
          const SizedBox(height: 8),
          const Text(
            'Extracted Features:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          _buildResultRow('  Mean', inputFeatures![0].toStringAsFixed(3)),
          if (inputFeatures!.length > 1)
            _buildResultRow('  Std Dev', inputFeatures![1].toStringAsFixed(3)),
          if (inputFeatures!.length > 2)
            _buildResultRow('  Min', inputFeatures![2].toStringAsFixed(3)),
          if (inputFeatures!.length > 3)
            _buildResultRow('  Max', inputFeatures![3].toStringAsFixed(3)),
        ],
        if (predictedClass != null && confidence != null) ...[
          const SizedBox(height: 12),
          _buildResultRow(
            'Predicted Class',
            predictedClass.toString(),
            isHighlight: true,
          ),
          _buildResultRow(
            'Confidence',
            '${(confidence! * 100).toStringAsFixed(2)}%',
            isHighlight: true,
          ),
        ],
        if (allProbabilities != null) ...[
          const SizedBox(height: 12),
          const Text(
            'All Class Probabilities:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...allProbabilities!.asMap().entries.map((e) {
            return _buildResultRow(
              '  Class ${e.key}',
              '${(e.value * 100).toStringAsFixed(2)}%',
            );
          }),
        ],
      ],
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                fontSize: isHighlight ? 15 : 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                fontSize: isHighlight ? 15 : 14,
                color: isHighlight ? Colors.blue : null,
              ),
            ),
          ),
        ],
      ),
    );
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
                        _buildResultsCard(),
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
