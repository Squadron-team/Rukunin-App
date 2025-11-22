class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String badge;
  final String seller; // same as shopName
  final String shopId;
  final int stock;
  final bool isActive;
  final bool isDiscount;
  final double rating;
  final DateTime createdAt;
  int quantity; // for cart functionality

  Product({
    String? id,
    required this.name,
    required this.description,
    required this.price,
    String? imageUrl,
    String? category,
    String? badge,
    String? seller,
    String? shopId,
    this.stock = 100,
    this.isActive = true,
    this.isDiscount = false,
    this.rating = 0.0,
    DateTime? createdAt,
    this.quantity = 0,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl = imageUrl ?? '',
        category = category ?? badge ?? 'Lainnya',
        badge = badge ?? category ?? 'Lainnya',
        seller = seller ?? 'Toko Tidak Diketahui',
        shopId = shopId ?? '',
        createdAt = createdAt ?? DateTime.now();

  // Factory constructor for Firestore
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      badge: data['badge'] ?? data['category'] ?? '',
      seller: data['shopName'] ?? data['seller'] ?? '',
      shopId: data['shopId'] ?? '',
      stock: data['stock'] ?? 0,
      isActive: data['isActive'] ?? true,
      isDiscount: data['isDiscount'] ?? false,
      rating: (data['rating'] ?? 0).toDouble(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      quantity: data['quantity'] ?? 0,
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'badge': badge,
      'shopName': seller,
      'shopId': shopId,
      'stock': stock,
      'isActive': isActive,
      'isDiscount': isDiscount,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  // Copy with method for cart operations
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? badge,
    String? seller,
    String? shopId,
    int? stock,
    bool? isActive,
    bool? isDiscount,
    double? rating,
    DateTime? createdAt,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      badge: badge ?? this.badge,
      seller: seller ?? this.seller,
      shopId: shopId ?? this.shopId,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      isDiscount: isDiscount ?? this.isDiscount,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
    );
  }
}