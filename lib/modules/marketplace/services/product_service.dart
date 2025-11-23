import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collectionName = 'marketplace_products';

  // Get all products as stream
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(_collectionName)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get single product
  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(productId)
          .get();
      if (doc.exists) {
        return Product.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // Enhanced search products with multiple strategies
  Stream<List<Product>> searchProducts(String query) {
    if (query.isEmpty) {
      return Stream.value([]);
    }

    final searchQuery = query.toLowerCase();

    // Search by name (case-insensitive using Firestore query)
    return _firestore
        .collection(_collectionName)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          final products = snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .where(
                (product) =>
                    product.name.toLowerCase().contains(searchQuery) ||
                    product.description.toLowerCase().contains(searchQuery) ||
                    product.category.toLowerCase().contains(searchQuery) ||
                    product.seller.toLowerCase().contains(searchQuery),
              )
              .toList();

          // Sort by relevance (exact match first)
          products.sort((a, b) {
            final aNameMatch = a.name.toLowerCase().startsWith(searchQuery);
            final bNameMatch = b.name.toLowerCase().startsWith(searchQuery);
            if (aNameMatch && !bNameMatch) return -1;
            if (!aNameMatch && bNameMatch) return 1;
            return 0;
          });

          return products;
        });
  }

  // Alternative: Search with autocomplete suggestions
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('isActive', isEqualTo: true)
          .limit(10)
          .get();

      final suggestions = snapshot.docs
          .map((doc) => doc.data()['name'] as String)
          .where((name) => name.toLowerCase().contains(query.toLowerCase()))
          .toSet()
          .toList();

      return suggestions;
    } catch (e) {
      print('Error getting suggestions: $e');
      return [];
    }
  }

  // Get products by shop ID
  Stream<List<Product>> getProductsByShop(String shopId) {
    return _firestore
        .collection(_collectionName)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Get product count by shop
  Future<int> getProductCountByShop(String shopId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('shopId', isEqualTo: shopId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting product count: $e');
      return 0;
    }
  }

  // Upload product image
  Future<String?> uploadProductImage(XFile image, String shopId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${shopId}_$timestamp.jpg';
      final ref = _storage.ref().child('products/$shopId/$fileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        // Web: read as byte
        final bytes = await image.readAsBytes();

        uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        final file = File(image.path);

        uploadTask = ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add product with image
  Future<String?> addProduct(Product product, String imageUrl) async {
    try {
      final productData = product.toFirestore();
      productData['imageUrl'] = imageUrl;

      final docRef = await _firestore
          .collection(_collectionName)
          .add(productData);
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }

  // Delete product image from storage
  Future<bool> deleteProductImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(_collectionName).doc(productId).update(data);
      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collectionName).doc(productId).delete();
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}
