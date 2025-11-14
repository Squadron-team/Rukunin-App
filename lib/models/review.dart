class Review {
  final String id;               // Unique ID of the review
  final String userId;           // ID of the user who wrote the review
  final String userName;         // Display name of the reviewer
  final String? userAvatar;      // Optional avatar URL
  final double rating;           // e.g. 4.5
  final String comment;          // Review text
  final DateTime createdAt;      // Timestamp of the review
  final List<String> images;     // Review image URLs
  final int likes;               // Helpful votes count
  final String? productVariation; // Example: "Color: Red, Size: M"

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userAvatar,
    this.images = const [],
    this.likes = 0,
    this.productVariation,
  });

  // JSON factory
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      images: List<String>.from(json['images'] ?? []),
      likes: json['likes'] ?? 0,
      productVariation: json['productVariation'],
    );
  }

  // To JSON for APIs
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'images': images,
      'likes': likes,
      'productVariation': productVariation,
    };
  }
}
