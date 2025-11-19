class FinancialSummaryModel {
  final int income;
  final int expense;
  final int balance;
  final String level;
  final String period;

  FinancialSummaryModel({
    required this.income,
    required this.expense,
    required this.level,
    required this.period,
  }) : balance = income - expense;

  String get formattedIncome => _formatCurrency(income);
  String get formattedExpense => _formatCurrency(expense);
  String get formattedBalance => _formatCurrency(balance);

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
