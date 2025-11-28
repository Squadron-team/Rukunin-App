import 'package:rukunin/modules/marketplace/models/product.dart';

enum OrderStatus { pending, confirmed, inDelivery, completed, cancelled }

class Order {
  final String id;
  final String userId;
  final String sellerId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final String shippingAddress;
  final String? buyerName;
  final String? buyerContact;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.userId,
    required this.sellerId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.shippingAddress,
    String? id,
    this.status = OrderStatus.pending,
    this.buyerName,
    this.buyerContact,
    DateTime? createdAt,
    this.discount = 0,
    this.updatedAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  // For backward compatibility with existing code
  Product get product => items.first.product;
  int get quantity => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Konfirmasi';
      case OrderStatus.confirmed:
        return 'Dikonfirmasi';
      case OrderStatus.inDelivery:
        return 'Sedang Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  factory Order.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Order(
      id: documentId,
      userId: data['userId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      items:
          (data['items'] as List?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${data['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: data['paymentMethod'] ?? '',
      shippingAddress: data['shippingAddress'] ?? '',
      buyerName: data['buyerName'],
      buyerContact: data['buyerContact'],
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'sellerId': sellerId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'buyerName': buyerName,
      'buyerContact': buyerContact,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  Order copyWith({OrderStatus? status, DateTime? updatedAt}) {
    return Order(
      id: id,
      userId: userId,
      sellerId: sellerId,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      totalAmount: totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      buyerName: buyerName,
      buyerContact: buyerContact,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name,
      'productImage': product.imageUrl,
      'quantity': quantity,
      'price': price,
      'unit': product.unit,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: Product(
        id: map['productId'] ?? '',
        name: map['productName'] ?? '',
        description: '',
        price: (map['price'] ?? 0).toDouble(),
        imageUrl: map['productImage'] ?? '',
        unit: map['unit'] ?? 'kg',
      ),
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}
