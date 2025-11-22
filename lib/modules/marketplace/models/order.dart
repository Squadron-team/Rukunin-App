import 'package:rukunin/modules/marketplace/models/product.dart';

enum OrderStatus {
  pending,
  confirmed,
  inDelivery,
  completed,
  cancelled,
}

class Order {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String shopId;
  final Product product;
  final int quantity;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? buyerContact;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.shopId,
    required this.product,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.buyerContact,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Konfirmasi';
      case OrderStatus.confirmed:
        return 'Dikonfirmasi';
      case OrderStatus.inDelivery:
        return 'Dalam Pengiriman';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}
