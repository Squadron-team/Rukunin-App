import 'package:rukunin/modules/marketplace/models/product.dart';

class CartItem {
  final String id;
  final String userId;
  final String productId;
  final Product product;
  int quantity;
  final DateTime addedAt;

  CartItem({
    String? id,
    required this.userId,
    required this.productId,
    required this.product,
    required this.quantity,
    DateTime? addedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        addedAt = addedAt ?? DateTime.now();

  // Factory constructor for Firestore
  factory CartItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CartItem(
      id: documentId,
      userId: data['userId'] ?? '',
      productId: data['productId'] ?? '',
      product: Product.fromFirestore(data['product'] ?? {}, data['productId']),
      quantity: data['quantity'] ?? 1,
      addedAt: data['addedAt']?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'productId': productId,
      'product': product.toFirestore(),
      'quantity': quantity,
      'addedAt': addedAt,
    };
  }

  // Calculate total price
  double get totalPrice => product.price * quantity;
}
