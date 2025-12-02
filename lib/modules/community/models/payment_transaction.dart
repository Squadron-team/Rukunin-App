class PaymentTransaction {
  final String id;
  final String userId;
  final String userName;
  final String communityId;
  final String period;
  final double amount;
  final String paymentMethod;
  final String proofImageUrl;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final String? confirmedBy;
  final String? notes;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.communityId,
    required this.period,
    required this.amount,
    required this.paymentMethod,
    required this.proofImageUrl,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.confirmedBy,
    this.notes,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      communityId: json['communityId'],
      period: json['period'],
      amount: json['amount'].toDouble(),
      paymentMethod: json['paymentMethod'],
      proofImageUrl: json['proofImageUrl'],
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
      ),
      createdAt: DateTime.parse(json['createdAt']),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : null,
      confirmedBy: json['confirmedBy'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'communityId': communityId,
      'period': period,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'proofImageUrl': proofImageUrl,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'confirmedBy': confirmedBy,
      'notes': notes,
    };
  }
}

enum PaymentStatus { pending, confirmed, rejected }
