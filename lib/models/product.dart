class Product {
  final String id;
  final String name;
  final String seller;
  final num price;
  final String badge;
  final String category;
  final String description;
  final String imageUrl;
  final int stock;
  final bool isActive;
  final bool isDiscount;
  final double rating;
  int quantity;

  Product({
    String? id,
    required this.name,
    required this.seller,
    required this.price,
    required this.badge,
    String? category,
    required this.description,
    String? imageUrl,
    this.stock = 100,
    this.isActive = true,
    this.isDiscount = false,
    this.rating = 0,
    this.quantity = 0,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        category = category ?? badge,
        imageUrl = imageUrl ?? 'https://via.placeholder.com/150';
}