import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:rukunin/modules/marketplace/models/order.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create new order
  Future<String?> createOrder({
    required String userId,
    required List<Product> products,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    try {
      // Get buyer info
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final buyerName = userData?['name'];
      final buyerContact = userData?['phone'];

      // Group products by seller
      final Map<String, List<Product>> productsBySeller = {};
      for (var product in products) {
        if (!productsBySeller.containsKey(product.shopId)) {
          productsBySeller[product.shopId] = [];
        }
        productsBySeller[product.shopId]!.add(product);
      }

      // Create order for each seller
      final List<String> orderIds = [];

      for (var entry in productsBySeller.entries) {
        final sellerId = entry.key;
        final sellerProducts = entry.value;

        final sellerSubtotal = sellerProducts.fold<double>(
          0,
          (sum, p) => sum + (p.price * p.quantity),
        );

        final order = Order(
          userId: userId,
          sellerId: sellerId,
          items: sellerProducts
              .map(
                (p) =>
                    OrderItem(product: p, quantity: p.quantity, price: p.price),
              )
              .toList(),
          subtotal: sellerSubtotal,
          deliveryFee: deliveryFee / productsBySeller.length,
          discount: discount / productsBySeller.length,
          totalAmount:
              sellerSubtotal +
              (deliveryFee / productsBySeller.length) -
              (discount / productsBySeller.length),
          paymentMethod: paymentMethod,
          shippingAddress: shippingAddress,
          buyerName: buyerName,
          buyerContact: buyerContact,
        );

        final docRef = await _firestore
            .collection('orders')
            .add(order.toFirestore());
        orderIds.add(docRef.id);

        // Update product stock
        for (var product in sellerProducts) {
          await _firestore
              .collection('marketplace_products')
              .doc(product.id)
              .update({'stock': FieldValue.increment(-product.quantity)});
        }
      }

      return orderIds.first; // Return first order ID
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Get user orders stream
  Stream<List<Order>> getUserOrders(String userId, {bool? isCompleted}) {
    Query query = _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (isCompleted != null) {
      if (isCompleted) {
        query = query.where('status', isEqualTo: 'completed');
      } else {
        query = query.where(
          'status',
          whereIn: ['pending', 'confirmed', 'inDelivery'],
        );
      }
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Order.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Get single order
  Future<Order?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return Order.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting order: $e');
      return null;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      final order = await getOrder(orderId);
      if (order == null) return false;

      // Restore product stock
      for (var item in order.items) {
        await _firestore.collection('products').doc(item.product.id).update({
          'stock': FieldValue.increment(item.quantity),
        });
      }

      await updateOrderStatus(orderId, OrderStatus.cancelled);
      return true;
    } catch (e) {
      print('Error cancelling order: $e');
      return false;
    }
  }

  // Get seller orders stream
  Stream<List<Order>> getSellerOrders(String sellerId) {
    return _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Order.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }
}
