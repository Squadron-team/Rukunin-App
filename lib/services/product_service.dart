import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'marketplace_products';

  // Get all products as stream
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    final lowerCaseCategory = category.toLowerCase();

    return _firestore
        .collection(_collectionName)
        .where('category', isEqualTo: lowerCaseCategory)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get single product
  Future<Product?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(productId).get();
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
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery) ||
              product.description.toLowerCase().contains(searchQuery) ||
              product.category.toLowerCase().contains(searchQuery) ||
              product.seller.toLowerCase().contains(searchQuery))
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
}
