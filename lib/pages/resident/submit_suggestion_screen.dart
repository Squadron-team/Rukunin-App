import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/l10n/app_localizations.dart';
import 'package:rukunin/theme/app_colors.dart';

class SubmitSuggestionScreen extends StatefulWidget {
  const SubmitSuggestionScreen({super.key});

  @override
  State<SubmitSuggestionScreen> createState() => _SubmitSuggestionScreenState();
}

class _SubmitSuggestionScreenState extends State<SubmitSuggestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'value': 'infrastructure',
      'label': 'Infrastruktur',
      'icon': Icons.foundation,
    },
    {'value': 'security', 'label': 'Keamanan', 'icon': Icons.shield_outlined},
    {
      'value': 'environment',
      'label': 'Lingkungan',
      'icon': Icons.park_outlined,
    },
    {
      'value': 'social',
      'label': 'Sosial & Budaya',
      'icon': Icons.people_outline,
    },
    {'value': 'event', 'label': 'Kegiatan', 'icon': Icons.event_outlined},
    {
      'value': 'finance',
      'label': 'Keuangan',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {'value': 'other', 'label': 'Lainnya', 'icon': Icons.lightbulb_outline},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitSuggestion() async {
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
        title: const Text('Saran Terkirim'),
        content: const Text(
          'Terima kasih atas saran Anda. Masukan Anda sangat berharga untuk kemajuan RT/RW kita bersama.',
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
        title: Text(l10n.sendSuggestion),
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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.feedback_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sampaikan ide dan saran Anda untuk kemajuan lingkungan RT/RW',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Selection
            Text(
              'Kategori Saran *',
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

            // Title
            Text(
              'Judul Saran *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Perbaikan Sistem Iuran RT',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                if (value.length < 5) {
                  return 'Judul minimal 5 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Detail Saran *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText:
                    'Jelaskan saran Anda secara detail, termasuk manfaat dan cara implementasinya...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Detail saran tidak boleh kosong';
                }
                if (value.length < 30) {
                  return 'Detail saran minimal 30 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Anonymous Option
            Card(
              child: SwitchListTile(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() => _isAnonymous = value);
                },
                title: const Text('Kirim sebagai Anonim'),
                subtitle: const Text('Identitas Anda tidak akan ditampilkan'),
                secondary: const Icon(Icons.privacy_tip_outlined),
                activeThumbColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Benefits Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Manfaat Memberikan Saran',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('Membangun lingkungan yang lebih baik'),
                  _buildBenefitItem('Suara Anda akan dipertimbangkan'),
                  _buildBenefitItem('Berkontribusi untuk kemajuan bersama'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: (_selectedCategory != null && !_isSubmitting)
                  ? _submitSuggestion
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  : const Text('Kirim Saran'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.blue[700], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }
}
