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
                _buildReceiptResults()
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

  Widget _buildReceiptResults() {
    final verification =
        receiptDetectionResult!['verification'] as Map<String, dynamic>?;
    final summary = verification?['summary'] as Map<String, dynamic>?;
    final fieldVerification =
        verification?['field_verification'] as Map<String, dynamic>?;
    final lineValidation =
        verification?['line_validation'] as Map<String, dynamic>?;
    final layoutValidation =
        verification?['layout_validation'] as Map<String, dynamic>?;
    final linesData = receiptDetectionResult!['lines_data'] as List?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (summary?['passed'] == true)
                ? Colors.green.shade50
                : Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (summary?['passed'] == true)
                  ? Colors.green.shade200
                  : Colors.red.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    (summary?['passed'] == true)
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: (summary?['passed'] == true)
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      summary?['final_verdict'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ResultRow(
                label: 'Expected Amount',
                value: receiptDetectionResult!['expected_amount'] ?? 'N/A',
              ),
            ],
          ),
        ),

        // Field Verification
        if (fieldVerification != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Field Verification:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...fieldVerification.entries.map((entry) {
            final field = entry.value as Map<String, dynamic>;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ResultRow(
                      label: 'Expected',
                      value: field['expected'] ?? 'N/A',
                    ),
                    ResultRow(label: 'Actual', value: field['actual'] ?? 'N/A'),
                    ResultRow(
                      label: 'Match',
                      value: (field['is_match'] == true) ? '✓ Yes' : '✗ No',
                    ),
                  ],
                ),
              ),
            );
          }),
        ],

        // Line Validation
        if (lineValidation != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Line Validation:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            color: (lineValidation['is_valid'] == true)
                ? Colors.green.shade50
                : Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResultRow(
                    label: 'Valid',
                    value: (lineValidation['is_valid'] == true)
                        ? '✓ Yes'
                        : '✗ No',
                  ),
                  ResultRow(
                    label: 'Detected Lines',
                    value: lineValidation['detected_lines']?.toString() ?? '0',
                  ),
                  ResultRow(
                    label: 'Expected Lines',
                    value: lineValidation['expected_lines']?.toString() ?? '0',
                  ),
                  if (lineValidation['reason'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        lineValidation['reason'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],

        // Layout Validation
        if (layoutValidation != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Layout Validation:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            color: (layoutValidation['is_valid'] == true)
                ? Colors.green.shade50
                : Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResultRow(
                    label: 'Valid',
                    value: (layoutValidation['is_valid'] == true)
                        ? '✓ Yes'
                        : '✗ No',
                  ),
                  ResultRow(
                    label: 'Similarity Score',
                    value:
                        '${((layoutValidation['similarity_score'] ?? 0) * 100).toStringAsFixed(1)}%',
                  ),
                  ResultRow(
                    label: 'Threshold',
                    value:
                        '${((layoutValidation['threshold'] ?? 0) * 100).toStringAsFixed(1)}%',
                  ),
                  if (layoutValidation['reason'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        layoutValidation['reason'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (layoutValidation['violations'] != null &&
                      (layoutValidation['violations'] as List).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Violations:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    ...(layoutValidation['violations'] as List).map(
                      (v) => Padding(
                        padding: const EdgeInsets.only(left: 8, top: 2),
                        child: Text(
                          '• $v',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],

        // Detected Lines
        if (linesData != null && linesData.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Detected Text Lines:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...linesData.take(10).map((line) {
            final lineMap = line as Map<String, dynamic>;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResultRow(
                      label: 'Line ${lineMap['line_number']}',
                      value: lineMap['text'] ?? '',
                    ),
                    if (lineMap['field'] != null)
                      Text(
                        'Field: ${lineMap['field']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          if (linesData.length > 10)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '... and ${linesData.length - 10} more lines',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
