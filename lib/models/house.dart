class House {
  final String id;
  final String streetName;
  final int houseNo;
  final bool isOccupied;

  House({
    required this.id,
    required this.streetName,
    required this.houseNo,
    this.isOccupied = false,
  });

  House copyWith({
    String? id,
    String? streetName,
    int? houseNo,
    bool? isOccupied,
  }) {
    return House(
      id: id ?? this.id,
      streetName: streetName ?? this.streetName,
      houseNo: houseNo ?? this.houseNo,
      
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}
