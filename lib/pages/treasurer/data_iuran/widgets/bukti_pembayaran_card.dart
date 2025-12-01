import 'package:flutter/material.dart';

class BuktiPembayaranCard extends StatelessWidget {
  final String? proofUrl;
  final double height;
  final IconData placeholder;

  const BuktiPembayaranCard({
    this.proofUrl,
    this.height = 200,
    this.placeholder = Icons.receipt_long,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            if (proofUrl != null) {
              return Dialog(
                child: InteractiveViewer(
                  child: Image.network(proofUrl!, fit: BoxFit.contain),
                ),
              );
            }
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(
                      Icons.receipt_long,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: proofUrl == null
            ? Center(child: Icon(placeholder, size: 64, color: Colors.grey))
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(proofUrl!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
