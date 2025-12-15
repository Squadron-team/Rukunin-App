import 'dart:typed_data';
import 'package:flutter/foundation.dart';

enum ProcessingStep {
  idle,
  inputSelected,
  preprocessed,
  hogExtracted,
  classified,
}

class MLTestState {
  final String status;
  final bool isLoading;
  final ProcessingStep currentStep;

  // Input data
  final String? currentImagePath;
  final Uint8List? currentImageBytes;
  final List<double>? manualFeatures;
  final String? testName;
  final bool isFirebaseFunctionTest;

  // Preprocessing
  final Float32List? preprocessedImage;
  final Uint8List? imgPreprocessedPng;
  final int? originalWidth;
  final int? originalHeight;

  // HOG Extraction
  final Float32List? hogFeatures;
  final int? hogFeaturesLength;

  // Classification
  final int? predictedClass;
  final double? confidence;
  final List<double>? allProbabilities;

  // Receipt Detection
  final bool isReceiptDetectionTest;
  final Map<String, dynamic>? receiptDetectionResult;
  final bool isLoadingReceipt;

  const MLTestState({
    this.status = 'Not loaded',
    this.isLoading = false,
    this.currentStep = ProcessingStep.idle,
    this.currentImagePath,
    this.currentImageBytes,
    this.manualFeatures,
    this.testName,
    this.isFirebaseFunctionTest = false,
    this.preprocessedImage,
    this.imgPreprocessedPng,
    this.originalWidth,
    this.originalHeight,
    this.hogFeatures,
    this.hogFeaturesLength,
    this.predictedClass,
    this.confidence,
    this.allProbabilities,
    this.isReceiptDetectionTest = false,
    this.receiptDetectionResult,
    this.isLoadingReceipt = false,
  });

  MLTestState copyWith({
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
    return MLTestState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      currentStep: currentStep ?? this.currentStep,
      currentImagePath: currentImagePath ?? this.currentImagePath,
      currentImageBytes: currentImageBytes ?? this.currentImageBytes,
      manualFeatures: manualFeatures ?? this.manualFeatures,
      testName: testName ?? this.testName,
      isFirebaseFunctionTest:
          isFirebaseFunctionTest ?? this.isFirebaseFunctionTest,
      preprocessedImage: preprocessedImage ?? this.preprocessedImage,
      imgPreprocessedPng: imgPreprocessedPng ?? this.imgPreprocessedPng,
      originalWidth: originalWidth ?? this.originalWidth,
      originalHeight: originalHeight ?? this.originalHeight,
      hogFeatures: hogFeatures ?? this.hogFeatures,
      hogFeaturesLength: hogFeaturesLength ?? this.hogFeaturesLength,
      predictedClass: predictedClass ?? this.predictedClass,
      confidence: confidence ?? this.confidence,
      allProbabilities: allProbabilities ?? this.allProbabilities,
      isReceiptDetectionTest:
          isReceiptDetectionTest ?? this.isReceiptDetectionTest,
      receiptDetectionResult:
          receiptDetectionResult ?? this.receiptDetectionResult,
      isLoadingReceipt: isLoadingReceipt ?? this.isLoadingReceipt,
    );
  }

  MLTestState reset() {
    return const MLTestState();
  }
}
