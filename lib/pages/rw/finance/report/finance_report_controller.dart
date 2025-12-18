class FinanceReportController {
  final int totalIncome = 2500000;
  final int totalExpenses = 850000;

  final List<int> chartData = [400, 600, 900, 500, 1200, 800];

  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Iuran Warga',
      'amount': 200000,
      'type': 'income',
      'date': '1 Desember 2025',
    },
    {
      'title': 'Beli Kursi',
      'amount': 350000,
      'type': 'expense',
      'date': '3 Desember 2025',
    },
    {
      'title': 'Sumbangan Acara',
      'amount': 500000,
      'type': 'income',
      'date': '5 Desember 2025',
    },
  ];
}
