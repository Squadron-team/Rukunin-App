import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rukunin/services/ml/data_preprocessor.dart';
import 'package:rukunin/services/ml/hog_isolate.dart';
import 'package:rukunin/services/ml/onnx_service.dart';
import 'package:rukunin/pages/general/ml_inference_test/models/ml_test_state.dart';
import 'package:rukunin/pages/general/ml_inference_test/services/ml_firebase_service.dart';
import 'package:rukunin/pages/general/ml_inference_test/widgets/step_card.dart';
import 'package:rukunin/pages/general/ml_inference_test/widgets/result_row.dart';
import 'package:rukunin/pages/general/ml_inference_test/widgets/input_selection_step.dart';
import 'package:rukunin/pages/general/ml_inference_test/widgets/receipt_detection_card.dart';
import 'package:rukunin/utils/image_processing/image_utils_pure.dart';

export 'models/ml_test_state.dart' show ProcessingStep;

class MLInferenceTestScreen extends StatefulWidget {
  const MLInferenceTestScreen({super.key});

  @override
  State<MLInferenceTestScreen> createState() => _MLInferenceTestScreenState();
}

class _MLInferenceTestScreenState extends State<MLInferenceTestScreen> {
  MLTestState _state = const MLTestState();
  final _dataPreprocessor = DataPreprocessor();

  bool get isWeb => kIsWeb;
  bool get isAndroid => !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (isAndroid) {
      _load();
    } else {
      _updateState(
        status:
            'Web platform detected. Local ONNX inference is disabled. Use Firebase Functions for inference.',
      );
    }
  }

  void _updateState({
    String? status,
    bool? isLoading,
    ProcessingStep? currentStep,
    String? currentImagePath,
    Uint8List? currentImageBytes,
    List<double>? manualFeatures,
    String? testName,
    bool? isFirebaseFunctionTest,
    Float32List? preprocessedImage,
    Uint8List? imgPreprocessedPng,
    int? originalWidth,
    int? originalHeight,
    Float32List? hogFeatures,
    int? hogFeaturesLength,
    int? predictedClass,
    double? confidence,
    List<double>? allProbabilities,
    bool? isReceiptDetectionTest,
    Map<String, dynamic>? receiptDetectionResult,
    bool? isLoadingReceipt,
  }) {
    setState(() {
      _state = _state.copyWith(
        status: status,
        isLoading: isLoading,
        currentStep: currentStep,
        currentImagePath: currentImagePath,
        currentImageBytes: currentImageBytes,
        manualFeatures: manualFeatures,
        testName: testName,
        isFirebaseFunctionTest: isFirebaseFunctionTest,
        preprocessedImage: preprocessedImage,
        imgPreprocessedPng: imgPreprocessedPng,
        originalWidth: originalWidth,
        originalHeight: originalHeight,
        hogFeatures: hogFeatures,
        hogFeaturesLength: hogFeaturesLength,
        predictedClass: predictedClass,
        confidence: confidence,
        allProbabilities: allProbabilities,
        isReceiptDetectionTest: isReceiptDetectionTest,
        receiptDetectionResult: receiptDetectionResult,
        isLoadingReceipt: isLoadingReceipt,
      );
    });
  }

  Future<void> _load() async {
    _updateState(isLoading: true, status: 'Loading model...');

    try {
      final ok = await OnnxService.loadModel(
        'assets/models/image_classifier_linreg.onnx',
      );

      if (!mounted) return;
      _updateState(
        status: ok ? 'Model loaded successfully 🎉' : 'Failed to load model',
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error loading model: $e', isLoading: false);
    }
  }

  void _resetPipeline() {
    setState(() {
      _state = _state.reset();
    });
  }

  Future<void> _selectImageInput(String assetPath, String name) async {
    if (isWeb) {
      _showWebNotSupportedDialog('Local Image Processing');
      return;
    }

    _updateState(isLoading: true);

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      if (!mounted) return;

      _updateState(
        currentImagePath: assetPath,
        currentImageBytes: bytes,
        testName: name,
        originalWidth: image.width,
        originalHeight: image.height,
        currentStep: ProcessingStep.inputSelected,
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error loading image: $e', isLoading: false);
    }
  }

  void _selectManualInput(List<double> features, String name) {
    if (isWeb) {
      _showWebNotSupportedDialog('Manual Features Processing');
      return;
    }

    _updateState(
      manualFeatures: features,
      testName: name,
      currentStep: ProcessingStep.hogExtracted,
      hogFeatures: Float32List.fromList(features),
      hogFeaturesLength: features.length,
    );
  }

  void _showWebNotSupportedDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feature Not Available'),
        content: Text(
          '$feature is only available on Android devices.\n\n'
          'Please use Firebase Functions inference for web platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _testWithFirebaseFunctions(String assetPath, String name) async {
    _updateState(isLoading: true, status: 'Loading image for Firebase test...');

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      if (!mounted) return;

      _updateState(
        currentImagePath: assetPath,
        currentImageBytes: bytes,
        testName: name,
        originalWidth: image.width,
        originalHeight: image.height,
        isFirebaseFunctionTest: true,
        currentStep: ProcessingStep.inputSelected,
        status: 'Image loaded. Ready to call Firebase Functions.',
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error loading image: $e', isLoading: false);
    }
  }

  Future<void> _runFirebaseFunctionInference() async {
    if (_state.currentImageBytes == null) return;

    _updateState(isLoading: true, status: 'Calling Firebase Functions...');

    try {
      final data = await MLFirebaseService.classifyImage(
        _state.currentImageBytes!,
      );

      if (!mounted) return;

      if (data['success'] == true) {
        final probabilities = List<double>.from(
          (data['probabilities'] as List).map((e) => (e as num).toDouble()),
        );

        _updateState(
          predictedClass: data['prediction'],
          confidence: data['confidence'],
          allProbabilities: probabilities,
          currentStep: ProcessingStep.classified,
          status: 'Firebase inference completed successfully!',
          isLoading: false,
        );
      } else {
        _updateState(
          status: 'Firebase error: ${data['error'] ?? 'Unknown error'}',
          isLoading: false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _updateState(
        status: 'Error calling Firebase Functions: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _preprocessImage() async {
    if (_state.currentImageBytes == null) return;

    _updateState(isLoading: true);

    try {
      final preprocessed = _dataPreprocessor.compute(_state.currentImageBytes!);
      final imgPrePng = ImageUtilsPure.float32ToPng(preprocessed, 64, 64);

      if (!mounted) return;

      _updateState(
        preprocessedImage: preprocessed,
        imgPreprocessedPng: imgPrePng,
        currentStep: ProcessingStep.preprocessed,
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error preprocessing: $e', isLoading: false);
    }
  }

  Future<void> _extractHogFeatures() async {
    if (_state.preprocessedImage == null) return;

    _updateState(isLoading: true);

    try {
      final features = await compute(
        hogIsolateEntry,
        _state.preprocessedImage!,
      );

      if (!mounted) return;

      _updateState(
        hogFeatures: features,
        hogFeaturesLength: features.length,
        currentStep: ProcessingStep.hogExtracted,
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error extracting HOG: $e', isLoading: false);
    }
  }

  Future<void> _runClassification() async {
    if (_state.hogFeatures == null) return;

    _updateState(isLoading: true);

    try {
      final outputs = await OnnxService.runInference(_state.hogFeatures!);

      int predClass = 0;
      double maxProb = -double.infinity;

      for (int i = 0; i < outputs.length; i++) {
        if (outputs[i] > maxProb) {
          maxProb = outputs[i];
          predClass = i;
        }
      }

      if (!mounted) return;

      _updateState(
        predictedClass: predClass,
        confidence: maxProb,
        allProbabilities: outputs,
        currentStep: ProcessingStep.classified,
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;
      _updateState(status: 'Error during classification: $e', isLoading: false);
    }
  }

  Future<void> _testReceiptDetection(
    String assetPath,
    String expectedAmount,
  ) async {
    _updateState(isLoadingReceipt: true, status: 'Loading receipt image...');

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      if (!mounted) return;

      _updateState(
        currentImagePath: assetPath,
        currentImageBytes: bytes,
        testName: 'Receipt Detection Test',
        originalWidth: image.width,
        originalHeight: image.height,
        isReceiptDetectionTest: true,
        status: 'Receipt loaded. Analyzing...',
      );

      final resultData = await MLFirebaseService.detectFakeReceipt(
        bytes,
        expectedAmount,
      );

      if (!mounted) return;

      if (resultData['success'] == true) {
        _updateState(
          receiptDetectionResult: {
            'success': true,
            'message': resultData['message'],
            'expected_amount': resultData['expected_amount'],
            'final_verdict': resultData['final_verdict'],
            'verification': resultData['verification'],
            'lines_data': resultData['lines_data'],
          },
          status: 'Receipt analysis completed!',
          isLoadingReceipt: false,
        );
      } else {
        _updateState(
          status:
              'Receipt detection error: ${resultData['error'] ?? 'Unknown error'}',
          isLoadingReceipt: false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _updateState(
        status: 'Error in receipt detection: $e',
        isLoadingReceipt: false,
        receiptDetectionResult: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isWeb
              ? 'ML Inference - Web Mode (Limited)'
              : 'ML Inference - Step by Step',
        ),
        actions: [
          if (_state.currentStep != ProcessingStep.idle ||
              _state.isReceiptDetectionTest)
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
            if (isWeb) _buildWebBanner(),
            if (isWeb) const SizedBox(height: 16),
            _buildModelStatusCard(),
            const SizedBox(height: 16),
            _buildInputSelectionStep(),
            const SizedBox(height: 16),
            if (_shouldShowPreprocessingStep()) ...[
              _buildPreprocessingStep(),
              const SizedBox(height: 16),
            ],
            if (_shouldShowHogExtractionStep()) ...[
              _buildHogExtractionStep(),
              const SizedBox(height: 16),
            ],
            if (_shouldShowFirebaseInferenceStep()) ...[
              _buildFirebaseInferenceStep(),
              const SizedBox(height: 16),
            ],
            if (_shouldShowClassificationStep()) ...[
              _buildClassificationStep(),
              const SizedBox(height: 16),
            ],
            ReceiptDetectionCard(
              isReceiptDetectionTest: _state.isReceiptDetectionTest,
              isLoadingReceipt: _state.isLoadingReceipt,
              currentImageBytes: _state.currentImageBytes,
              receiptDetectionResult: _state.receiptDetectionResult,
              onTestReceipt: () => _testReceiptDetection(
                'assets/ml_test/receipt.jpg',
                'Rp325.000',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebBanner() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Web Platform: Local ONNX inference is disabled. Use Firebase Functions for cloud-based inference.',
                style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Model Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isWeb) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Web',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(_state.status, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSelectionStep() {
    if (_state.currentStep != ProcessingStep.idle) {
      return _buildSelectedInputCard();
    }

    return StepCard(
      title: 'Step 1: Select Input',
      content: InputSelectionStep(
        isWeb: isWeb,
        isLoading: _state.isLoading,
        onImageTest1: () =>
            _selectImageInput('assets/ml_test/img_0.png', 'Test Image 1'),
        onImageTest2: () =>
            _selectImageInput('assets/ml_test/img_1.png', 'Test Image 2'),
        onFirebaseTest1: () => _testWithFirebaseFunctions(
          'assets/ml_test/img_0.png',
          'Firebase Test 1',
        ),
        onFirebaseTest2: () => _testWithFirebaseFunctions(
          'assets/ml_test/img_1.png',
          'Firebase Test 2',
        ),
        onManualSample1: () =>
            _selectManualInput([0.5, 0.3, 0.2, 0.8], 'Sample 1'),
        onManualSample2: () =>
            _selectManualInput([0.1, 0.1, 0.0, 0.2], 'Sample 2'),
        onManualSample3: () =>
            _selectManualInput([0.9, 0.7, 0.8, 1.0], 'Sample 3'),
      ),
    );
  }

  Widget _buildSelectedInputCard() {
    return StepCard(
      title: 'Step 1: Select Input',
      content: Column(
        children: [
          ResultRow(label: 'Selected', value: _state.testName ?? 'Unknown'),
          if (_state.isFirebaseFunctionTest)
            const ResultRow(label: 'Method', value: 'Firebase Functions 🔥'),
          if (!_state.isFirebaseFunctionTest && isAndroid)
            const ResultRow(label: 'Method', value: 'Local ONNX (Android) 📱'),
          if (_state.currentImagePath != null)
            ResultRow(label: 'Path', value: _state.currentImagePath!),
          if (_state.originalWidth != null && _state.originalHeight != null)
            ResultRow(
              label: 'Original Size',
              value: '${_state.originalWidth}x${_state.originalHeight}',
            ),
          if (_state.currentImageBytes != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: Image.memory(
                  _state.currentImageBytes!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
          if (_state.manualFeatures != null) ...[
            const SizedBox(height: 8),
            ResultRow(
              label: 'Features',
              value: _state.manualFeatures!
                  .map((e) => e.toStringAsFixed(3))
                  .join(', '),
            ),
          ],
        ],
      ),
    );
  }

  bool _shouldShowPreprocessingStep() {
    return _state.currentStep.index >= ProcessingStep.inputSelected.index &&
        _state.manualFeatures == null &&
        !_state.isFirebaseFunctionTest;
  }

  Widget _buildPreprocessingStep() {
    final isCompleted =
        _state.currentStep.index > ProcessingStep.inputSelected.index;

    return StepCard(
      title: 'Step 2: Preprocess Image',
      content: isCompleted
          ? Column(
              children: [
                const ResultRow(label: 'Status', value: 'Completed ✓'),
                const ResultRow(label: 'Output Size', value: '64x64 grayscale'),
                if (_state.imgPreprocessedPng != null) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.memory(
                        _state.imgPreprocessedPng!,
                        width: 128,
                        height: 128,
                        filterQuality: FilterQuality.none,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ],
            )
          : const Text('Convert image to 64x64 grayscale for HOG extraction.'),
      action: !isCompleted
          ? ElevatedButton.icon(
              onPressed: _state.isLoading ? null : _preprocessImage,
              icon: _state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(
                _state.isLoading ? 'Processing...' : 'Run Preprocessing',
              ),
            )
          : null,
    );
  }

  bool _shouldShowHogExtractionStep() {
    return (_state.currentStep.index >= ProcessingStep.preprocessed.index ||
            _state.manualFeatures != null) &&
        !_state.isFirebaseFunctionTest;
  }

  Widget _buildHogExtractionStep() {
    final isCompleted =
        _state.currentStep.index > ProcessingStep.preprocessed.index;

    return StepCard(
      title: 'Step 3: Extract HOG Features',
      content: isCompleted
          ? Column(
              children: [
                const ResultRow(label: 'Status', value: 'Completed ✓'),
                ResultRow(
                  label: 'Features Count',
                  value: _state.hogFeaturesLength?.toString() ?? '0',
                ),
                if (_state.hogFeatures != null &&
                    _state.hogFeatures!.length >= 4) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'First 10 features (preview):',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  ..._state.hogFeatures!
                      .take(10)
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (e) => ResultRow(
                          label: '  Feature ${e.key}',
                          value: e.value.toStringAsFixed(6),
                        ),
                      ),
                ],
              ],
            )
          : const Text(
              'Extract Histogram of Oriented Gradients features from the preprocessed image.',
            ),
      action: _state.currentStep == ProcessingStep.preprocessed
          ? ElevatedButton.icon(
              onPressed: _state.isLoading ? null : _extractHogFeatures,
              icon: _state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(
                _state.isLoading ? 'Extracting...' : 'Extract HOG Features',
              ),
            )
          : null,
    );
  }

  bool _shouldShowFirebaseInferenceStep() {
    return _state.isFirebaseFunctionTest &&
        _state.currentStep == ProcessingStep.inputSelected;
  }

  Widget _buildFirebaseInferenceStep() {
    return StepCard(
      title: 'Step 2: Firebase Functions Inference',
      content: const Text(
        'Send image to Firebase Functions for cloud-based ML inference.',
      ),
      action: ElevatedButton.icon(
        onPressed: _state.isLoading ? null : _runFirebaseFunctionInference,
        icon: _state.isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.cloud_upload),
        label: Text(
          _state.isLoading ? 'Calling Firebase...' : 'Run Firebase Inference',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  bool _shouldShowClassificationStep() {
    return _state.currentStep.index >= ProcessingStep.hogExtracted.index ||
        (_state.isFirebaseFunctionTest &&
            _state.currentStep == ProcessingStep.classified);
  }

  Widget _buildClassificationStep() {
    final isCompleted = _state.currentStep == ProcessingStep.classified;
    final stepNumber = _state.isFirebaseFunctionTest ? 3 : 4;

    return StepCard(
      title:
          'Step $stepNumber: ML Classification${isCompleted ? ' Results' : ''}',
      content: isCompleted
          ? _buildClassificationResults()
          : _buildClassificationPrompt(),
      action:
          _state.currentStep == ProcessingStep.hogExtracted &&
              !_state.isFirebaseFunctionTest
          ? ElevatedButton.icon(
              onPressed: _state.isLoading ? null : _runClassification,
              icon: _state.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(
                _state.isLoading ? 'Classifying...' : 'Run Classification',
              ),
            )
          : null,
    );
  }

  Widget _buildClassificationPrompt() {
    return const Text('Run logistic regression model to classify the image.');
  }

  Widget _buildClassificationResults() {
    return Column(
      children: [
        const ResultRow(label: 'Status', value: 'Completed ✓'),
        if (_state.isFirebaseFunctionTest)
          const ResultRow(label: 'Source', value: 'Firebase Functions 🔥'),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _state.predictedClass?.toString() ?? 'N/A',
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
                'Confidence: ${((_state.confidence ?? 0) * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (_state.allProbabilities != null) ...[
          const SizedBox(height: 12),
          const Text(
            'All Class Probabilities:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ..._state.allProbabilities!.asMap().entries.map((e) {
            final isMax = e.key == _state.predictedClass;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Class ${e.key}:',
                      style: TextStyle(
                        fontWeight: isMax ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: e.value.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
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
                        fontWeight: isMax ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
