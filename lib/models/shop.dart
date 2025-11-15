class Shop {
  final String id;
  final String name;
  final String ownerId;
  final String ownerName;
  final String? description;
  final String? imageUrl;
  final String? location;
  final DateTime createdAt;
  final bool isActive;

  Shop({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    this.description,
    this.imageUrl,
    this.location,
    required this.createdAt,
    this.isActive = true,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
