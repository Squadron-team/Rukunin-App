import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rukunin/services/ml/data_preprocessor.dart';
import 'package:rukunin/services/ml/hog_isolate.dart';
import 'package:rukunin/services/ml/onnx_service.dart';
import 'package:rukunin/utils/image_helper.dart';

enum ProcessingStep {
  idle,
  inputSelected,
  preprocessed,
  hogExtracted,
  classified,
}

class OnnxTestPage extends StatefulWidget {
  const OnnxTestPage({super.key});

  @override
  State<OnnxTestPage> createState() => _OnnxTestPageState();
}

class _OnnxTestPageState extends State<OnnxTestPage> {
  String status = 'Not loaded';
  bool isLoading = false;
  ProcessingStep currentStep = ProcessingStep.idle;

  // Input data
  String? currentImagePath;
  Uint8List? currentImageBytes;
  List<double>? manualFeatures;
  String? testName;

  // Step 1: Preprocessing
  final _dataPreprocessor = DataPreprocessor();
  Float32List? preprocessedImage;
  Uint8List? imgPreprocessedPng;
  int? originalWidth;
  int? originalHeight;

  // Step 2: HOG Extraction
  Float32List? hogFeatures;
  int? hogFeaturesLength;

  // Step 3: Classification
  int? predictedClass;
  double? confidence;
  List<double>? allProbabilities;

  @override
  void initState() {
    super.initState();
    _load();
  }

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

  void _resetPipeline() {
    setState(() {
      currentStep = ProcessingStep.idle;
      currentImagePath = null;
      currentImageBytes = null;
      manualFeatures = null;
      testName = null;
      preprocessedImage = null;
      imgPreprocessedPng = null;
      originalWidth = null;
      originalHeight = null;
      hogFeatures = null;
      hogFeaturesLength = null;
      predictedClass = null;
      confidence = null;
      allProbabilities = null;
    });
  }

  // Step 1: Select input (image or manual features)
  Future<void> _selectImageInput(String assetPath, String name) async {
    setState(() {
      isLoading = true;
    });

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      if (!mounted) return;

      setState(() {
        currentImagePath = assetPath;
        currentImageBytes = bytes;
        testName = name;
        originalWidth = image.width;
        originalHeight = image.height;
        currentStep = ProcessingStep.inputSelected;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Error loading image: $e';
        isLoading = false;
      });
    }
  }

  void _selectManualInput(List<double> features, String name) {
    setState(() {
      manualFeatures = features;
      testName = name;
      currentStep = ProcessingStep.inputSelected;
      // For manual features, skip to HOG step
      hogFeatures = Float32List.fromList(features);
      hogFeaturesLength = features.length;
      currentStep = ProcessingStep.hogExtracted;
    });
  }

  // Step 2: Preprocess image
  Future<void> _preprocessImage() async {
    if (currentImageBytes == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final preprocessed = _dataPreprocessor.compute(currentImageBytes!);
      final imgPrePng = ImageHelper.float32ToPng(preprocessed, 64, 64);

      if (!mounted) return;

      setState(() {
        preprocessedImage = preprocessed;
        imgPreprocessedPng = imgPrePng;
        currentStep = ProcessingStep.preprocessed;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Error preprocessing: $e';
        isLoading = false;
      });
    }
  }

  // Step 3: Extract HOG features
  Future<void> _extractHogFeatures() async {
    if (preprocessedImage == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final features = await compute(hogIsolateEntry, preprocessedImage!);

      if (!mounted) return;

      setState(() {
        hogFeatures = features;
        hogFeaturesLength = features.length;
        currentStep = ProcessingStep.hogExtracted;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Error extracting HOG: $e';
        isLoading = false;
      });
    }
  }

  // Step 4: Run ML classification
  Future<void> _runClassification() async {
    if (hogFeatures == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final outputs = await OnnxService.runInference(hogFeatures!);

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
        currentStep = ProcessingStep.classified;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        status = 'Error during classification: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildStepCard(String title, Widget content, {Widget? action}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            content,
            if (action != null) ...[const SizedBox(height: 12), action],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ONNX Test - Step by Step'),
        actions: [
          if (currentStep != ProcessingStep.idle)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetPipeline,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Model Status
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

            // Step 1: Input Selection
            _buildStepCard(
              'Step 1: Select Input',
              currentStep == ProcessingStep.idle
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Choose an input method to start:'),
                        const SizedBox(height: 12),
                        const Text(
                          'Test with Images:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () => _selectImageInput(
                                        'assets/ml_test/img_0.png',
                                        'Test Image 1',
                                      ),
                                icon: const Icon(Icons.image),
                                label: const Text('Image 1'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () => _selectImageInput(
                                        'assets/ml_test/img_1.png',
                                        'Test Image 2',
                                      ),
                                icon: const Icon(Icons.image),
                                label: const Text('Image 2'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Test with Manual Features:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton(
                              onPressed: () => _selectManualInput([
                                0.5,
                                0.3,
                                0.2,
                                0.8,
                              ], 'Sample 1'),
                              child: const Text('Sample 1'),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectManualInput([
                                0.1,
                                0.1,
                                0.0,
                                0.2,
                              ], 'Sample 2'),
                              child: const Text('Sample 2'),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectManualInput([
                                0.9,
                                0.7,
                                0.8,
                                1.0,
                              ], 'Sample 3'),
                              child: const Text('Sample 3'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildResultRow('Selected', testName ?? 'Unknown'),
                        if (currentImagePath != null)
                          _buildResultRow('Path', currentImagePath!),
                        if (originalWidth != null && originalHeight != null)
                          _buildResultRow(
                            'Original Size',
                            '${originalWidth}x$originalHeight',
                          ),
                        if (currentImageBytes != null) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 150),
                              child: Image.memory(
                                currentImageBytes!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                        if (manualFeatures != null) ...[
                          const SizedBox(height: 8),
                          _buildResultRow(
                            'Features',
                            manualFeatures!
                                .map((e) => e.toStringAsFixed(3))
                                .join(', '),
                          ),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // Step 2: Preprocessing
            if (currentStep.index >= ProcessingStep.inputSelected.index &&
                manualFeatures == null)
              _buildStepCard(
                'Step 2: Preprocess Image',
                currentStep == ProcessingStep.inputSelected
                    ? const Text(
                        'Convert image to 64x64 grayscale for HOG extraction.',
                      )
                    : Column(
                        children: [
                          _buildResultRow('Status', 'Completed ✓'),
                          _buildResultRow('Output Size', '64x64 grayscale'),
                          if (imgPreprocessedPng != null) ...[
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Image.memory(
                                  imgPreprocessedPng!,
                                  width: 128,
                                  height: 128,
                                  filterQuality: FilterQuality.none,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                action: currentStep == ProcessingStep.inputSelected
                    ? ElevatedButton.icon(
                        onPressed: isLoading ? null : _preprocessImage,
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(
                          isLoading ? 'Processing...' : 'Run Preprocessing',
                        ),
                      )
                    : null,
              ),
            if (currentStep.index >= ProcessingStep.inputSelected.index &&
                manualFeatures == null)
              const SizedBox(height: 16),

            // Step 3: HOG Extraction
            if (currentStep.index >= ProcessingStep.preprocessed.index ||
                manualFeatures != null)
              _buildStepCard(
                'Step 3: Extract HOG Features',
                currentStep == ProcessingStep.preprocessed
                    ? const Text(
                        'Extract Histogram of Oriented Gradients features from the preprocessed image.',
                      )
                    : Column(
                        children: [
                          _buildResultRow('Status', 'Completed ✓'),
                          _buildResultRow(
                            'Features Count',
                            hogFeaturesLength?.toString() ?? '0',
                          ),
                          if (hogFeatures != null &&
                              hogFeatures!.length >= 4) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'First 10 features (preview):',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            ...hogFeatures!
                                .take(10)
                                .toList()
                                .asMap()
                                .entries
                                .map(
                                  (e) => _buildResultRow(
                                    '  Feature ${e.key}',
                                    e.value.toStringAsFixed(6),
                                  ),
                                ),
                          ],
                        ],
                      ),
                action: currentStep == ProcessingStep.preprocessed
                    ? ElevatedButton.icon(
                        onPressed: isLoading ? null : _extractHogFeatures,
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(
                          isLoading ? 'Extracting...' : 'Extract HOG Features',
                        ),
                      )
                    : null,
              ),
            if (currentStep.index >= ProcessingStep.preprocessed.index ||
                manualFeatures != null)
              const SizedBox(height: 16),

            // Step 4: Classification
            if (currentStep.index >= ProcessingStep.hogExtracted.index)
              _buildStepCard(
                'Step 4: ML Classification',
                currentStep == ProcessingStep.hogExtracted
                    ? const Text(
                        'Run logistic regression model to classify the image.',
                      )
                    : Column(
                        children: [
                          _buildResultRow('Status', 'Completed ✓'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Predicted Class: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      predictedClass?.toString() ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Confidence: ${((confidence ?? 0) * 100).toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (allProbabilities != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'All Class Probabilities:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...allProbabilities!.asMap().entries.map((e) {
                              final isMax = e.key == predictedClass;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'Class ${e.key}:',
                                        style: TextStyle(
                                          fontWeight: isMax
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: e.value.clamp(0.0, 1.0),
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              isMax ? Colors.blue : Colors.grey,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        '${(e.value * 100).toStringAsFixed(2)}%',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontWeight: isMax
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                action: currentStep == ProcessingStep.hogExtracted
                    ? ElevatedButton.icon(
                        onPressed: isLoading ? null : _runClassification,
                        icon: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow),
                        label: Text(
                          isLoading ? 'Classifying...' : 'Run Classification',
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
