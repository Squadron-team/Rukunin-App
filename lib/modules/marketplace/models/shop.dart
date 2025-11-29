class Shop {
  final String id;
  final String name;
  final String ownerId;
  final String ownerName;
  final String? description;
  final String? imageUrl;
  final String? address;
  final String? phone;
  final bool isActive;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Shop({
    required this.name,
    required this.ownerId,
    required this.ownerName,
    String? id,
    this.description,
    this.imageUrl,
    this.address,
    this.phone,
    this.isActive = true,
    this.isApproved = false,
    DateTime? createdAt,
    this.updatedAt,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  // Factory constructor for Firestore
  factory Shop.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Shop(
      id: documentId,
      name: data['name'] ?? '',
      ownerId: data['ownerId'] ?? '',
      ownerName: data['ownerName'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
      address: data['address'],
      phone: data['phone'],
      isActive: data['isActive'] ?? true,
      isApproved: data['isApproved'] ?? false,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'phone': phone,
      'isActive': isActive,
      'isApproved': isApproved,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  // Copy with method
  Shop copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? ownerName,
    String? description,
    String? imageUrl,
    String? address,
    String? phone,
    bool? isActive,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
