import 'package:rukunin/models/street.dart';
import 'package:rukunin/repositories/resident.dart' as residentRepo;

List<Map<String, dynamic>> generateAssignedResidents(
  List<Street> streets, {
  int count = 60,
}) {
  final generated = residentRepo.WargaRepository.generateDummy(count: count);
  final List<Map<String, dynamic>> generatedAssigned = [];
  if (streets.isEmpty) return generatedAssigned;

  for (var i = 0; i < generated.length; i++) {
    final w = generated[i];
    final street = streets[i % streets.length];
    final houseNo = (i % (street.totalHouses > 0 ? street.totalHouses : 6)) + 1;
    generatedAssigned.add({
      'id': w.id,
      'name': w.name,
      'nik': w.nik,
      'kkNumber': w.kkNumber,
      'address': '${street.name} No. $houseNo',
      'rt': w.rt,
      'rw': w.rw,
      'isActive': w.isActive,
      'ktpUrl': w.ktpUrl,
      'kkUrl': w.kkUrl,
      'createdAt': w.createdAt,
    });
  }
  return generatedAssigned;
}
