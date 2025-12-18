import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/theme/app_colors.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPriority;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'value': 'infrastructure',
      'label': 'Infrastruktur',
      'icon': Icons.construction,
    },
    {'value': 'security', 'label': 'Keamanan', 'icon': Icons.security},
    {
      'value': 'cleanliness',
      'label': 'Kebersihan',
      'icon': Icons.cleaning_services,
    },
    {
      'value': 'lighting',
      'label': 'Penerangan',
      'icon': Icons.lightbulb_outline,
    },
    {'value': 'water', 'label': 'Air Bersih', 'icon': Icons.water_drop},
    {'value': 'other', 'label': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, dynamic>> _priorities = [
    {'value': 'low', 'label': 'Rendah', 'color': AppColors.success},
    {'value': 'medium', 'label': 'Sedang', 'color': AppColors.warning},
    {'value': 'high', 'label': 'Tinggi', 'color': AppColors.error},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 48,
          ),
        ),
        title: const Text('Laporan Terkirim'),
        content: const Text(
          'Laporan Anda telah berhasil dikirim. Tim kami akan segera menindaklanjuti.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Go back to home
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportIssue),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.report_problem_rounded,
                    color: AppColors.error,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Laporkan masalah yang Anda temui di lingkungan RT/RW',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Selection
            Text(
              'Kategori Masalah *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category['value'];
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category['icon'] as IconData, size: 16),
                      const SizedBox(width: 6),
                      Text(category['label'] as String),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = category['value']);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Priority Selection
            Text(
              'Tingkat Urgensi *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: _priorities.map((priority) {
                final isSelected = _selectedPriority == priority['value'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(priority['label'] as String),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = priority['value']);
                      },
                      selectedColor: (priority['color'] as Color).withOpacity(
                        0.2,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? priority['color'] as Color
                            : AppColors.border,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Location
            Text(
              'Lokasi Kejadian *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Jalan RT 01, dekat pos ronda',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lokasi tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Deskripsi Masalah *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Jelaskan masalah secara detail...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                if (value.length < 20) {
                  return 'Deskripsi minimal 20 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Image Upload (Optional)
            Text(
              'Foto Pendukung (Opsional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // TODO: Implement image picker
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan foto (max 3)',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed:
                  (_selectedCategory != null &&
                      _selectedPriority != null &&
                      !_isSubmitting)
                  ? _submitReport
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.error,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Kirim Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}
