import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/modules/marketplace/models/shop.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'marketplace_shops';

  // Get user's shop
  Stream<Shop?> getUserShop(String userId) {
    return _firestore
        .collection(_collectionName)
        .where('ownerId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Shop.fromFirestore(
            snapshot.docs.first.data(),
            snapshot.docs.first.id,
          );
        });
  }

  // Check if user has shop
  Future<bool> hasShop(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('ownerId', isEqualTo: userId)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking shop: $e');
      return false;
    }
  }

  // Create new shop
  Future<String?> createShop(Shop shop) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(shop.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error creating shop: $e');
      return null;
    }
  }

  // Update shop
  Future<bool> updateShop(String shopId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now();
      await _firestore.collection(_collectionName).doc(shopId).update(data);
      return true;
    } catch (e) {
      print('Error updating shop: $e');
      return false;
    }
  }

  // Delete shop
  Future<bool> deleteShop(String shopId) async {
    try {
      await _firestore.collection(_collectionName).doc(shopId).delete();
      return true;
    } catch (e) {
      print('Error deleting shop: $e');
      return false;
    }
  }

  // Get shop by ID
  Future<Shop?> getShop(String shopId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(shopId)
          .get();
      if (doc.exists) {
        return Shop.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting shop: $e');
      return null;
    }
  }

  // Get all active shops
  Stream<List<Shop>> getAllShops() {
    return _firestore
        .collection(_collectionName)
        .where('isActive', isEqualTo: true)
        .where('isApproved', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Shop.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }
}
