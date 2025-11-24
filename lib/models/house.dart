class House {
  final String id;
  final String streetName;
  final int houseNo;
  final String status; 
  final bool isOccupied;

  House({
    required this.id,
    required this.streetName,
    required this.houseNo,
    this.status = 'tetap',
    this.isOccupied = false,
  });

  House copyWith({String? id, String? streetName, int? houseNo, String? status, bool? isOccupied}) {
    return House(
      id: id ?? this.id,
      streetName: streetName ?? this.streetName,
      houseNo: houseNo ?? this.houseNo,
      status: status ?? this.status,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }
}
