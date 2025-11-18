import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

typedef VoidCallbackNullable = void Function()?;

class DocTile extends StatelessWidget {
  final String title;
  final String url;
  final VoidCallback onUpload;
  final VoidCallbackNullable onView;
  final double height;
  final bool showUpload;
  final bool showViewButton;
  final bool viewOnBoxTap;
  final VoidCallbackNullable onRemove;

  const DocTile({
    super.key,
    required this.title,
    required this.url,
    required this.onUpload,
    this.onView,
    this.height = 110,
    this.showUpload = true,
    this.showViewButton = true,
    this.viewOnBoxTap = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: InkWell(
              onTap: viewOnBoxTap && onView != null ? onView : null,
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Center(
                    child: url.isEmpty
                        ? Text('Belum ada $title')
                        : Image.asset(
                            url,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Container(
                              color: Colors.grey[100],
                              child: const Center(child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey)),
                            ),
                          ),
                  ),
                  if (url.isNotEmpty && onRemove != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Material(
                        color: Colors.white.withOpacity(0.9),
                        shape: const CircleBorder(),
                        elevation: 0,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onRemove,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.close, size: 16, color: Colors.red[700]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (showUpload || showViewButton)
          Row(
            children: [
              if (showUpload)
                if (showViewButton)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: AppColors.primary),
                    ),
                    onPressed: onUpload,
                    icon: Icon(Icons.upload_file, size: 18, color: AppColors.primary),
                    label: Text('Upload', style: TextStyle(color: AppColors.primary)),
                  )
                else
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        minimumSize: const Size(0, 44),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: AppColors.primary),
                      ),
                      onPressed: onUpload,
                      icon: Icon(Icons.upload_file, size: 18, color: AppColors.primary),
                      label: Text('Upload', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
              if (showUpload && showViewButton) const SizedBox(width: 8),
              if (showViewButton)
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: onView,
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text('Lihat'),
                ),
            ],
          ),
      ],
    );
  }
}
