import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/ml_inference_test/widgets/result_row.dart';

class ReceiptDetectionCard extends StatelessWidget {
  final bool isReceiptDetectionTest;
  final bool isLoadingReceipt;
  final Uint8List? currentImageBytes;
  final Map<String, dynamic>? receiptDetectionResult;
  final VoidCallback onTestReceipt;

  const ReceiptDetectionCard({
    required this.isReceiptDetectionTest,
    required this.isLoadingReceipt,
    required this.currentImageBytes,
    required this.receiptDetectionResult,
    required this.onTestReceipt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Receipt Detection Test',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test fake receipt detection using Firebase Functions',
              style: TextStyle(fontSize: 13, color: Colors.green.shade800),
            ),
            const SizedBox(height: 12),
            if (!isReceiptDetectionTest) ...[
              ElevatedButton.icon(
                onPressed: isLoadingReceipt ? null : onTestReceipt,
                icon: isLoadingReceipt
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  isLoadingReceipt ? 'Analyzing...' : 'Test Receipt Detection',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ] else ...[
              if (currentImageBytes != null) ...[
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        currentImageBytes!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (receiptDetectionResult != null)
                _buildReceiptResults(receiptDetectionResult!)
              else if (isLoadingReceipt)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptResults(Map<String, dynamic> result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Verdict Section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: result['verdict'] == 'FAKE'
                ? Colors.red.shade50
                : result['verdict'] == 'VALID RECEIPT'
                ? Colors.green.shade50
                : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: result['verdict'] == 'FAKE'
                  ? Colors.red.shade300
                  : result['verdict'] == 'VALID RECEIPT'
                  ? Colors.green.shade300
                  : Colors.orange.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    result['verdict'] == 'FAKE'
                        ? Icons.error
                        : result['verdict'] == 'VALID RECEIPT'
                        ? Icons.check_circle
                        : Icons.warning,
                    color: result['verdict'] == 'FAKE'
                        ? Colors.red.shade700
                        : result['verdict'] == 'VALID RECEIPT'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    result['verdict'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: result['verdict'] == 'FAKE'
                          ? Colors.red.shade900
                          : result['verdict'] == 'VALID RECEIPT'
                          ? Colors.green.shade900
                          : Colors.orange.shade900,
                    ),
                  ),
                ],
              ),
              if (result['early_detection'] == true) ...[
                const SizedBox(height: 8),
                Text(
                  '⚠️ Early Detection Triggered',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (result['reason'] != null) ...[
          ResultRow(label: 'Reason', value: result['reason']),
          const SizedBox(height: 12),
        ],
        // ...rest of the results display logic
      ],
    );
  }
}
