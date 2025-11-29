import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class FamilyStatusEditor extends StatelessWidget {
  final String status;
  final ValueChanged<String> onChanged;

  const FamilyStatusEditor({
    required this.status,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            'Status Tinggal',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  status == 'kontrak' ? 'Kontrak' : 'Tetap',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.edit, size: 18),
                color: AppColors.primary,
                onPressed: () async {
                  final choice = await showModalBottomSheet<String>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    builder: (c) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              selected: status == 'tetap',
                              tileColor: status == 'tetap'
                                  ? AppColors.primary.withOpacity(0.06)
                                  : null,
                              title: Text(
                                'Tetap',
                                style: TextStyle(
                                  color: status == 'tetap'
                                      ? AppColors.primary
                                      : Colors.black,
                                ),
                              ),
                              leading: Radio<String>(
                                value: 'tetap',
                                groupValue: status,
                                activeColor: AppColors.primary,
                                onChanged: (v) => Navigator.pop(c, v),
                              ),
                              onTap: () => Navigator.pop(c, 'tetap'),
                            ),
                            ListTile(
                              selected: status == 'kontrak',
                              tileColor: status == 'kontrak'
                                  ? AppColors.primary.withOpacity(0.06)
                                  : null,
                              title: Text(
                                'Kontrak',
                                style: TextStyle(
                                  color: status == 'kontrak'
                                      ? AppColors.primary
                                      : Colors.black,
                                ),
                              ),
                              leading: Radio<String>(
                                value: 'kontrak',
                                groupValue: status,
                                activeColor: AppColors.primary,
                                onChanged: (v) => Navigator.pop(c, v),
                              ),
                              onTap: () => Navigator.pop(c, 'kontrak'),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  );

                  if (choice != null && choice != status) {
                    onChanged(choice);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
