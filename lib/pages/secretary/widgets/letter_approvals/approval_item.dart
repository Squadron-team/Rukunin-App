import 'package:flutter/material.dart';

class ApprovalItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const ApprovalItem({required this.data, required this.onTap, super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mail, color: Colors.blue, size: 28),
            ),

            const SizedBox(width: 16),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data['date'],
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // STATUS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: getStatusColor(data['status']).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                data['status'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: getStatusColor(data['status']),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
