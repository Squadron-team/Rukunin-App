import 'package:flutter/material.dart';

Future<void> showDownloadOptions(
  BuildContext context,
  void Function(String) onSelected,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Unduh Laporan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih format laporan yang ingin diunduh',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _DownloadOptionTile(
                icon: Icons.picture_as_pdf,
                iconColor: Colors.red,
                title: 'PDF',
                description: 'Laporan dalam format PDF',
                onTap: () {
                  Navigator.pop(context);
                  onSelected('pdf');
                },
              ),
              const SizedBox(height: 12),
              _DownloadOptionTile(
                icon: Icons.table_chart_rounded,
                iconColor: Colors.green,
                title: 'Excel (XLSX)',
                description: 'Laporan dalam format spreadsheet',
                onTap: () {
                  Navigator.pop(context);
                  onSelected('xlsx');
                },
              ),
              const SizedBox(height: 12),
              _DownloadOptionTile(
                icon: Icons.description_rounded,
                iconColor: Colors.blue,
                title: 'CSV',
                description: 'Data mentah untuk analisis',
                onTap: () {
                  Navigator.pop(context);
                  onSelected('csv');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
  );
}

class _DownloadOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _DownloadOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
