import 'package:flutter/material.dart';

class InputSelectionStep extends StatelessWidget {
  final bool isWeb;
  final bool isLoading;
  final VoidCallback onImageTest1;
  final VoidCallback onImageTest2;
  final VoidCallback onFirebaseTest1;
  final VoidCallback onFirebaseTest2;
  final VoidCallback onManualSample1;
  final VoidCallback onManualSample2;
  final VoidCallback onManualSample3;

  const InputSelectionStep({
    required this.isWeb,
    required this.isLoading,
    required this.onImageTest1,
    required this.onImageTest2,
    required this.onFirebaseTest1,
    required this.onFirebaseTest2,
    required this.onManualSample1,
    required this.onManualSample2,
    required this.onManualSample3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Choose an input method to start:'),
        const SizedBox(height: 12),
        const Text(
          'Test with Images (Local):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isWeb)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              '⚠️ Android only',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Opacity(
          opacity: isWeb ? 0.5 : 1.0,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (isLoading || isWeb) ? null : onImageTest1,
                  icon: const Icon(Icons.image),
                  label: const Text('Image 1'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: (isLoading || isWeb) ? null : onImageTest2,
                  icon: const Icon(Icons.image),
                  label: const Text('Image 2'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Test with Firebase Functions:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            '✓ Available on all platforms',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onFirebaseTest1,
                icon: const Icon(Icons.cloud),
                label: const Text('Firebase 1'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onFirebaseTest2,
                icon: const Icon(Icons.cloud),
                label: const Text('Firebase 2'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Test with Manual Features:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (isWeb)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              '⚠️ Android only',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        const SizedBox(height: 8),
        Opacity(
          opacity: isWeb ? 0.5 : 1.0,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: isWeb ? null : onManualSample1,
                child: const Text('Sample 1'),
              ),
              ElevatedButton(
                onPressed: isWeb ? null : onManualSample2,
                child: const Text('Sample 2'),
              ),
              ElevatedButton(
                onPressed: isWeb ? null : onManualSample3,
                child: const Text('Sample 3'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
