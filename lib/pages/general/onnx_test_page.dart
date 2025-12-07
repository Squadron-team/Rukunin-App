import 'dart:typed_data';
import 'package:flutter/material.dart';
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

            // Test Buttons
            const Text(
              'Run Test Inference:',
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
                      : () =>
                            _runTestInference([0.5, 0.3, 0.2, 0.8], 'Sample 1'),
                  child: const Text('Test Sample 1'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _runTestInference([
                          0.1,
                          0.1,
                          0.0,
                          0.2,
                        ], 'Sample 2 (Low)'),
                  child: const Text('Test Sample 2'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _runTestInference([
                          0.9,
                          0.7,
                          0.8,
                          1.0,
                        ], 'Sample 3 (High)'),
                  child: const Text('Test Sample 3'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _runTestInference([
                          0.0,
                          0.0,
                          0.0,
                          0.0,
                        ], 'All Zeros'),
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
