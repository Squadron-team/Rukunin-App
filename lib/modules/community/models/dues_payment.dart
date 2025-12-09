import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, verified, rejected, autoVerified }

class DuesPayment {
  final String? id;
  final String userId;
  final String userName;
  final String userPhone;
  final String rt;
  final String rw;
  final double amount;
  final String month;
  final int year;
  final String receiptImageUrl;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final String? verifiedBy;
  final String? rejectionReason;
  final bool isAutoVerified;
  final double? verificationScore;

  DuesPayment({
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.rt,
    required this.rw,
    required this.amount,
    required this.month,
    required this.year,
    required this.receiptImageUrl,
    required this.status,
    required this.createdAt,
    this.id,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionReason,
    this.isAutoVerified = false,
    this.verificationScore,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'rt': rt,
      'rw': rw,
      'amount': amount,
      'month': month,
      'year': year,
      'receiptImageUrl': receiptImageUrl,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
      'verifiedBy': verifiedBy,
      'rejectionReason': rejectionReason,
      'isAutoVerified': isAutoVerified,
      'verificationScore': verificationScore,
    };
  }

  factory DuesPayment.fromFirestore(Map<String, dynamic> data, String id) {
    return DuesPayment(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhone: data['userPhone'] ?? '',
      rt: data['rt'] ?? '',
      rw: data['rw'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      month: data['month'] ?? '',
      year: data['year'] ?? DateTime.now().year,
      receiptImageUrl: data['receiptImageUrl'] ?? '',
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => PaymentStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate(),
      verifiedBy: data['verifiedBy'],
      rejectionReason: data['rejectionReason'],
      isAutoVerified: data['isAutoVerified'] ?? false,
      verificationScore: data['verificationScore']?.toDouble(),
    );
  }

  DuesPayment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhone,
    String? rt,
    String? rw,
    double? amount,
    String? month,
    int? year,
    String? receiptImageUrl,
    PaymentStatus? status,
    DateTime? createdAt,
    DateTime? verifiedAt,
    String? verifiedBy,
    String? rejectionReason,
    bool? isAutoVerified,
    double? verificationScore,
  }) {
    return DuesPayment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      amount: amount ?? this.amount,
      month: month ?? this.month,
      year: year ?? this.year,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isAutoVerified: isAutoVerified ?? this.isAutoVerified,
      verificationScore: verificationScore ?? this.verificationScore,
    );
  }
}
