class Product {
  final String name;
  final String seller;
  final num price;
  final String badge;
  final String description;
  final bool isDiscount;
  final double rating;
  int quantity;

  Product({
    required this.name,
    required this.seller,
    required this.price,
    required this.badge,
    required this.description,
    this.isDiscount = false,
    this.rating = 0,
    this.quantity = 0
  });
}