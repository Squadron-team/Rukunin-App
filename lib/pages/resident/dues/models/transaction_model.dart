class TransactionModel {
  final String date;
  final String description;
  final int amount;
  final String category;

  TransactionModel({
    required this.date,
    required this.description,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'description': description,
      'amount': amount,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      date: map['date'] as String,
      description: map['description'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
    );
  }
}
