import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';

final List<Street> streets = [
  Street(name: 'Gang Mawar', totalHouses: 12, paid: 10, status: 'Baik', statusColor: Colors.green),
  Street(name: 'Gang Melati', totalHouses: 15, paid: 12, status: 'Baik', statusColor: Colors.green),
  Street(name: 'Gang Anggrek', totalHouses: 10, paid: 6, status: 'Perlu Perhatian', statusColor: Colors.orange),
  Street(name: 'Gang Dahlia', totalHouses: 8, paid: 2, status: 'Buruk', statusColor: Colors.red),
  Street(name: 'Gang Melur', totalHouses: 6, paid: 1, status: 'Buruk', statusColor: Colors.red),
];

void addStreet(Street s) => streets.insert(0, s);
void updateStreet(int index, Street s) => streets[index] = s;
void removeStreetAt(int index) => streets.removeAt(index);

List<Street> computeStreetSummaries(List residents) {
  return streets.map((s) => s.copyWith()).toList();
}

List<Street> computeStreetSummariesFromResidents(List residents) {
  return computeStreetSummaries(residents);
}
