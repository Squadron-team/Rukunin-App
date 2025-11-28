import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:rukunin/modules/community/models/transaction_model.dart';
import 'package:rukunin/modules/community/models/financial_summary_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:rukunin/modules/community/services/web_download_helper.dart';

class ReportGeneratorService {
  Future<String?> generatePDF({
    required String filename,
    required FinancialSummaryModel summary,
    required List<TransactionModel> incomes,
    required List<TransactionModel> expenses,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildPDFHeader(summary),
            pw.SizedBox(height: 20),
            _buildPDFSummary(summary),
            pw.SizedBox(height: 24),
            _buildPDFIncomeSection(incomes),
            pw.SizedBox(height: 24),
            _buildPDFExpenseSection(expenses),
            pw.SizedBox(height: 40),
            _buildPDFFooter(summary.level),
          ];
        },
      ),
    );

    final pdfBytes = await pdf.save();

    if (kIsWeb) {
      return await downloadFileWeb(
        Uint8List.fromList(pdfBytes),
        '$filename.pdf',
        'application/pdf',
      );
    } else {
      final output = await _getDownloadDirectory();
      final file = File('${output.path}/$filename.pdf');
      await file.writeAsBytes(pdfBytes);
      return file.path;
    }
  }

  pw.Widget _buildPDFHeader(FinancialSummaryModel summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'LAPORAN KEUANGAN',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Rukun Tetangga/Warga: ${summary.level}',
          style: const pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          'Periode: ${summary.period}',
          style: const pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          'Tanggal Cetak: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _buildPDFSummary(FinancialSummaryModel summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'RINGKASAN KEUANGAN',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Column(
            children: [
              _buildPDFSummaryRow(
                'Total Pemasukan',
                'Rp ${summary.formattedIncome}',
              ),
              pw.SizedBox(height: 8),
              _buildPDFSummaryRow(
                'Total Pengeluaran',
                'Rp ${summary.formattedExpense}',
              ),
              pw.Divider(),
              _buildPDFSummaryRow(
                'Saldo Akhir',
                'Rp ${summary.formattedBalance}',
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPDFSummaryRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPDFIncomeSection(List<TransactionModel> incomes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DETAIL PEMASUKAN',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildPDFTableHeader('Tanggal'),
                _buildPDFTableHeader('Deskripsi'),
                _buildPDFTableHeader('Kategori'),
                _buildPDFTableHeader('Jumlah'),
              ],
            ),
            ...incomes.map(
              (item) => pw.TableRow(
                children: [
                  _buildPDFTableCell(item.date),
                  _buildPDFTableCell(item.description),
                  _buildPDFTableCell(item.category),
                  _buildPDFTableCell('Rp ${_formatCurrency(item.amount)}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPDFExpenseSection(List<TransactionModel> expenses) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DETAIL PENGELUARAN',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildPDFTableHeader('Tanggal'),
                _buildPDFTableHeader('Deskripsi'),
                _buildPDFTableHeader('Kategori'),
                _buildPDFTableHeader('Jumlah'),
              ],
            ),
            ...expenses.map(
              (item) => pw.TableRow(
                children: [
                  _buildPDFTableCell(item.date),
                  _buildPDFTableCell(item.description),
                  _buildPDFTableCell(item.category),
                  _buildPDFTableCell('Rp ${_formatCurrency(item.amount)}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPDFFooter(String level) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Mengetahui,', style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 40),
            pw.Text(
              '__________________',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text('Ketua $level', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Bendahara,', style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 40),
            pw.Text(
              '__________________',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.Text(
              'Bendahara $level',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPDFTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _buildPDFTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  Future<String?> generateExcel({
    required String filename,
    required FinancialSummaryModel summary,
    required List<TransactionModel> incomes,
    required List<TransactionModel> expenses,
  }) async {
    var excel = Excel.createExcel();
    excel.delete('Sheet1');

    _createSummarySheet(excel, summary);
    _createIncomeSheet(excel, incomes);
    _createExpenseSheet(excel, expenses);

    final bytes = excel.encode();
    if (bytes != null) {
      if (kIsWeb) {
        return await downloadFileWeb(
          Uint8List.fromList(bytes),
          '$filename.xlsx',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );
      } else {
        final output = await _getDownloadDirectory();
        final file = File('${output.path}/$filename.xlsx');
        await file.writeAsBytes(bytes);
        return file.path;
      }
    }
    return null;
  }

  void _createSummarySheet(Excel excel, FinancialSummaryModel summary) {
    var sheet = excel['Ringkasan'];
    sheet.appendRow([TextCellValue('LAPORAN KEUANGAN ${summary.level}')]);
    sheet.appendRow([TextCellValue('Periode: ${summary.period}')]);
    sheet.appendRow([
      TextCellValue(
        'Tanggal Cetak: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
      ),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue('Keterangan'),
      TextCellValue('Jumlah (Rp)'),
    ]);
    sheet.appendRow([
      TextCellValue('Total Pemasukan'),
      IntCellValue(summary.income),
    ]);
    sheet.appendRow([
      TextCellValue('Total Pengeluaran'),
      IntCellValue(summary.expense),
    ]);
    sheet.appendRow([
      TextCellValue('Saldo Akhir'),
      IntCellValue(summary.balance),
    ]);
  }

  void _createIncomeSheet(Excel excel, List<TransactionModel> incomes) {
    var sheet = excel['Pemasukan'];
    sheet.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('Deskripsi'),
      TextCellValue('Kategori'),
      TextCellValue('Jumlah (Rp)'),
    ]);

    for (var item in incomes) {
      sheet.appendRow([
        TextCellValue(item.date),
        TextCellValue(item.description),
        TextCellValue(item.category),
        IntCellValue(item.amount),
      ]);
    }
  }

  void _createExpenseSheet(Excel excel, List<TransactionModel> expenses) {
    var sheet = excel['Pengeluaran'];
    sheet.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('Deskripsi'),
      TextCellValue('Kategori'),
      TextCellValue('Jumlah (Rp)'),
    ]);

    for (var item in expenses) {
      sheet.appendRow([
        TextCellValue(item.date),
        TextCellValue(item.description),
        TextCellValue(item.category),
        IntCellValue(item.amount),
      ]);
    }
  }

  Future<String?> generateCSV({
    required String filename,
    required FinancialSummaryModel summary,
    required List<TransactionModel> incomes,
    required List<TransactionModel> expenses,
  }) async {
    final buffer = StringBuffer();

    buffer.writeln('LAPORAN KEUANGAN ${summary.level}');
    buffer.writeln('Periode: ${summary.period}');
    buffer.writeln(
      'Tanggal Cetak: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    );
    buffer.writeln();

    buffer.writeln('RINGKASAN');
    buffer.writeln('Keterangan,Jumlah');
    buffer.writeln('Total Pemasukan,${summary.income}');
    buffer.writeln('Total Pengeluaran,${summary.expense}');
    buffer.writeln('Saldo Akhir,${summary.balance}');
    buffer.writeln();

    buffer.writeln('PEMASUKAN');
    buffer.writeln('Tanggal,Deskripsi,Kategori,Jumlah');
    for (var item in incomes) {
      buffer.writeln(
        '${item.date},${item.description},${item.category},${item.amount}',
      );
    }
    buffer.writeln();

    buffer.writeln('PENGELUARAN');
    buffer.writeln('Tanggal,Deskripsi,Kategori,Jumlah');
    for (var item in expenses) {
      buffer.writeln(
        '${item.date},${item.description},${item.category},${item.amount}',
      );
    }

    final csvBytes = Uint8List.fromList(buffer.toString().codeUnits);

    if (kIsWeb) {
      return await downloadFileWeb(csvBytes, '$filename.csv', 'text/csv');
    } else {
      final output = await _getDownloadDirectory();
      final file = File('${output.path}/$filename.csv');
      await file.writeAsString(buffer.toString());
      return file.path;
    }
  }

  Future<Directory> _getDownloadDirectory() async {
    if (kIsWeb) {
      throw UnsupportedError('File system access not supported on web');
    }

    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), use app-specific directory
      // For Android 10-12 (API 29-32), try Downloads folder first
      try {
        // Check Android version
        final directory = Directory('/storage/emulated/0/Download');

        // Try to create a test file to check write permission
        if (await directory.exists()) {
          try {
            final testFile = File('${directory.path}/.test_write');
            await testFile.writeAsString('test');
            await testFile.delete();
            return directory;
          } catch (e) {
            // No write permission, fall back to app directory
          }
        }
      } catch (e) {
        // Directory doesn't exist or not accessible
      }

      // Fallback: Use app-specific external directory
      // This doesn't require permissions on Android 10+
      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          // Create a Documents folder inside app directory
          final documentsDir = Directory('${externalDir.path}/Documents');
          if (!await documentsDir.exists()) {
            await documentsDir.create(recursive: true);
          }
          return documentsDir;
        }
      } catch (e) {
        // If external storage fails, use internal
      }

      // Last resort: internal app documents
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
