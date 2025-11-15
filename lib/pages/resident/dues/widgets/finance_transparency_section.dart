import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rukunin/pages/resident/dues/models/transaction_model.dart';
import 'package:rukunin/pages/resident/dues/models/financial_summary_model.dart';
import 'package:rukunin/pages/resident/dues/services/report_generator_service.dart';
import 'package:rukunin/pages/resident/dues/widgets/components/financial_summary_card.dart';
import 'package:rukunin/pages/resident/dues/widgets/components/transaction_card.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FinanceTransparencySection extends StatefulWidget {
  const FinanceTransparencySection({super.key});

  @override
  State<FinanceTransparencySection> createState() => _FinanceTransparencySectionState();
}

class _FinanceTransparencySectionState extends State<FinanceTransparencySection> {
  String _selectedLevel = 'RT';
  String _selectedPeriod = 'Month';
  DateTime _currentDate = DateTime.now();
  bool _isDownloading = false;
  
  final _reportService = ReportGeneratorService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildLevelSelector(),
          const SizedBox(height: 20),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildPeriodNavigation(),
          const SizedBox(height: 20),
          FinancialSummaryCard(
            summary: _getFinancialSummary(),
            isCurrentPeriod: _isCurrentPeriod(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Pemasukan'),
          const SizedBox(height: 12),
          _buildTransactionList(_getIncomes(), isIncome: true),
          const SizedBox(height: 24),
          _buildSectionHeader('Pengeluaran'),
          const SizedBox(height: 12),
          _buildTransactionList(_getExpenses(), isIncome: false),
          const SizedBox(height: 24),
          _buildDownloadButton(),
          const SizedBox(height: 12),
          _buildReportButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: _buildLevelButton('RT', 'Rukun Tetangga')),
            Expanded(child: _buildLevelButton('RW', 'Rukun Warga')),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelButton(String value, String label) {
    final isSelected = _selectedLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode Laporan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildPeriodButton('Month', 'Bulanan')),
                Expanded(child: _buildPeriodButton('Quarter', 'Triwulan')),
                Expanded(child: _buildPeriodButton('Year', 'Tahunan')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String value, String label) {
    final isSelected = _selectedPeriod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ), );
  }

  Widget _buildPeriodNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(() => _currentDate = _getPreviousPeriod()),
              icon: const Icon(Icons.chevron_left_rounded),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
                padding: const EdgeInsets.all(8),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    _getPeriodLabel(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDateRangeLabel(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _isCurrentPeriod() ? null : () => setState(() => _currentDate = _getNextPeriod()),
              icon: const Icon(Icons.chevron_right_rounded),
              style: IconButton.styleFrom(
                backgroundColor: _isCurrentPeriod() ? Colors.grey[200] : Colors.grey[100],
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions, {required bool isIncome}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: transactions.map((transaction) => TransactionCard(
          transaction: transaction,
          isIncome: isIncome,
          onTap: () => _showTransactionDetail(transaction, isIncome),
        )).toList(),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFFFBF3C)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isDownloading ? null : _showDownloadOptions,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isDownloading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _isDownloading ? 'Mengunduh...' : 'Unduh Laporan Keuangan',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showReportDialog,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Laporkan Ketidaksesuaian',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Business Logic Methods
  
  FinancialSummaryModel _getFinancialSummary() {
    final multiplier = _selectedPeriod == 'Month' ? 1 : _selectedPeriod == 'Quarter' ? 3 : 12;
    final baseIncome = _selectedLevel == 'RT' ? 5000000 : 25000000;
    final baseExpense = _selectedLevel == 'RT' ? 4000000 : 20000000;

    return FinancialSummaryModel(
      income: baseIncome * multiplier,
      expense: baseExpense * multiplier,
      level: _selectedLevel,
      period: _getPeriodLabel(),
    );
  }

  List<TransactionModel> _getIncomes() {
    return [
      TransactionModel(date: '2024-01-15', description: 'Iuran Bulanan Warga', amount: 5000000, category: 'Iuran'),
      TransactionModel(date: '2024-01-20', description: 'Iuran Kebersihan', amount: 2000000, category: 'Kebersihan'),
      TransactionModel(date: '2024-01-25', description: 'Donasi Acara RT', amount: 3000000, category: 'Donasi'),
    ];
  }

  List<TransactionModel> _getExpenses() {
    return [
      TransactionModel(date: '2024-01-18', description: 'Pembayaran Satpam', amount: 4000000, category: 'Gaji'),
      TransactionModel(date: '2024-01-22', description: 'Pembelian Alat Kebersihan', amount: 1500000, category: 'Operasional'),
      TransactionModel(date: '2024-01-28', description: 'Perbaikan Jalan', amount: 6500000, category: 'Infrastruktur'),
    ];
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case 'Month':
        final monthNames = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
                           'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
        return '${monthNames[_currentDate.month - 1]} ${_currentDate.year}';
      case 'Quarter':
        final quarter = ((_currentDate.month - 1) ~/ 3) + 1;
        return 'Triwulan $quarter ${_currentDate.year}';
      case 'Year':
        return 'Tahun ${_currentDate.year}';
      default:
        return '';
    }
  }

  String _getDateRangeLabel() {
    switch (_selectedPeriod) {
      case 'Month':
        final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
        return '1 - $lastDay ${_currentDate.month}/${_currentDate.year}';
      case 'Quarter':
        final quarter = ((_currentDate.month - 1) ~/ 3) + 1;
        final startMonth = (quarter - 1) * 3 + 1;
        final endMonth = startMonth + 2;
        return '$startMonth/${_currentDate.year} - $endMonth/${_currentDate.year}';
      case 'Year':
        return '1/1/${_currentDate.year} - 31/12/${_currentDate.year}';
      default:
        return '';
    }
  }

  DateTime _getPreviousPeriod() {
    switch (_selectedPeriod) {
      case 'Month': return DateTime(_currentDate.year, _currentDate.month - 1, 1);
      case 'Quarter': return DateTime(_currentDate.year, _currentDate.month - 3, 1);
      case 'Year': return DateTime(_currentDate.year - 1, _currentDate.month, 1);
      default: return _currentDate;
    }
  }

  DateTime _getNextPeriod() {
    switch (_selectedPeriod) {
      case 'Month': return DateTime(_currentDate.year, _currentDate.month + 1, 1);
      case 'Quarter': return DateTime(_currentDate.year, _currentDate.month + 3, 1);
      case 'Year': return DateTime(_currentDate.year + 1, _currentDate.month, 1);
      default: return _currentDate;
    }
  }

  bool _isCurrentPeriod() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'Month':
        return _currentDate.year == now.year && _currentDate.month == now.month;
      case 'Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final selectedQuarter = ((_currentDate.month - 1) ~/ 3) + 1;
        return _currentDate.year == now.year && selectedQuarter == currentQuarter;
      case 'Year':
        return _currentDate.year == now.year;
      default:
        return true;
    }
  }

  // Dialog Methods

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Unduh Laporan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Pilih format laporan yang ingin diunduh', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 20),
            _buildDownloadOption(Icons.picture_as_pdf, Colors.red, 'PDF', 'Laporan dalam format PDF', () => _downloadReport('pdf')),
            const SizedBox(height: 12),
            _buildDownloadOption(Icons.table_chart_rounded, Colors.green, 'Excel (XLSX)', 'Laporan dalam format spreadsheet', () => _downloadReport('xlsx')),
            const SizedBox(height: 12),
            _buildDownloadOption(Icons.description_rounded, Colors.blue, 'CSV', 'Data mentah untuk analisis', () => _downloadReport('csv')),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOption(IconData icon, Color iconColor, String title, String description, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
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
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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

  Future<void> _downloadReport(String format) async {
    setState(() => _isDownloading = true);

    try {
      // Request permission only on Android (not on web or iOS)
      if (!kIsWeb && Platform.isAndroid) {
        // Check Android version
        if (await _shouldRequestStoragePermission()) {
          final status = await Permission.storage.request();
          
          // For Android 13+, also request photos/media permissions if needed
          if (!status.isGranted) {
            // Try alternative permissions for Android 13+
            final manageStatus = await Permission.manageExternalStorage.request();
            if (!manageStatus.isGranted) {
              // Show user-friendly message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('File akan disimpan di folder aplikasi'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            }
          }
        }
      }

      final filename = 'Laporan_Keuangan_${_selectedLevel}_${_getPeriodLabel().replaceAll(' ', '_')}';
      final summary = _getFinancialSummary();
      final incomes = _getIncomes();
      final expenses = _getExpenses();

      String? filePath;
      switch (format) {
        case 'pdf':
          filePath = await _reportService.generatePDF(
            filename: filename,
            summary: summary,
            incomes: incomes,
            expenses: expenses,
          );
          break;
        case 'xlsx':
          filePath = await _reportService.generateExcel(
            filename: filename,
            summary: summary,
            incomes: incomes,
            expenses: expenses,
          );
          break;
        case 'csv':
          filePath = await _reportService.generateCSV(
            filename: filename,
            summary: summary,
            incomes: incomes,
            expenses: expenses,
          );
          break;
      }

      if (mounted && filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Laporan berhasil diunduh!', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        kIsWeb ? filePath : filePath.split('/').last,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            action: kIsWeb
                ? null
                : SnackBarAction(
                    label: 'Buka',
                    textColor: Colors.white,
                    onPressed: () => OpenFile.open(filePath),
                  ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Gagal mengunduh laporan: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<bool> _shouldRequestStoragePermission() async {
    // Android 10+ (API 29+) doesn't need permission for app-specific directory
    // But we'll request it anyway to try accessing Downloads folder
    return true;
  }

  void _showTransactionDetail(TransactionModel transaction, bool isIncome) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Detail Transaksi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('📅 Tanggal', transaction.date),
                  const Divider(height: 24),
                  _buildDetailRow('📝 Deskripsi', transaction.description),
                  const Divider(height: 24),
                  _buildDetailRow('🏷️ Kategori', transaction.category),
                  const Divider(height: 24),
                  _buildDetailRow('💰 Jumlah', '${isIncome ? '+' : '-'}Rp ${_formatCurrency(transaction.amount)}'),
                  const Divider(height: 24),
                  _buildDetailRow('👤 Diinput oleh', isIncome ? 'Bendahara RT' : 'Ketua RT'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: const Text('Laporkan Transaksi Ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  foregroundColor: Colors.orange[700],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.orange[200]!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
      ],
    );
  }

  void _showReportDialog() {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Laporkan Ketidaksesuaian', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jelaskan alasan pelaporan Anda:', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Contoh: Data pengeluaran tidak sesuai dengan bukti yang saya miliki',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Laporan Anda telah dikirim dan akan ditinjau'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Kirim Laporan'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
