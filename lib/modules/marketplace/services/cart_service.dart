import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/modules/marketplace/models/cart_item.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'user_carts';

  // Get user's cart items as stream
  Stream<List<CartItem>> getUserCart(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Add item to cart
  Future<String?> addToCart({
    required String userId,
    required Product product,
    required int quantity,
  }) async {
    try {
      // Check if product already in cart
      final existingCart = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: product.id)
          .limit(1)
          .get();

      if (existingCart.docs.isNotEmpty) {
        // Update quantity if exists
        final docId = existingCart.docs.first.id;
        final currentQuantity = existingCart.docs.first.data()['quantity'] ?? 0;
        await _firestore.collection(_collectionName).doc(docId).update({
          'quantity': currentQuantity + quantity,
        });
        return docId;
      } else {
        // Add new item
        final cartItem = CartItem(
          userId: userId,
          productId: product.id,
          product: product,
          quantity: quantity,
        );
        final docRef = await _firestore
            .collection(_collectionName)
            .add(cartItem.toFirestore());
        return docRef.id;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return null;
    }
  }

  // Update cart item quantity
  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }
      await _firestore
          .collection(_collectionName)
          .doc(cartItemId)
          .update({'quantity': newQuantity});
      return true;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      await _firestore.collection(_collectionName).doc(cartItemId).delete();
      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear user's cart
  Future<bool> clearCart(String userId) async {
    try {
      final cartItems = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (var doc in cartItems.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Get cart count
  Stream<int> getCartCount(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Get cart total
  Stream<double> getCartTotal(String userId) {
    return getUserCart(userId).map((cartItems) {
      return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    });
  }
}
