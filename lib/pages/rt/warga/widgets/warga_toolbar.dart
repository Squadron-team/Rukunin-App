import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/warga/widgets/search_bar.dart';
import 'package:rukunin/pages/rt/warga/widgets/download_button.dart';

class WargaToolbar extends StatelessWidget {
  final void Function(String) onSearchChanged;
  final VoidCallback onDownload;
  final bool showFilter;
  final void Function() onToggleFilter;

  const WargaToolbar({
    required this.onSearchChanged,
    required this.onDownload,
    required this.showFilter,
    required this.onToggleFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WargaSearchBar(
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 12),
        DownloadButton(onPressed: onDownload),
        const SizedBox(width: 8),
        IconButton(
          tooltip: 'Filter',
          icon: Icon(
            Icons.filter_list,
            color: (showFilter) ? AppColors.primary : Colors.grey[700],
          ),
          onPressed: onToggleFilter,
        ),
      ],
    );
  }
}
