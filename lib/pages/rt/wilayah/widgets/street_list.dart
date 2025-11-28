import 'package:flutter/material.dart';
import 'package:rukunin/models/street.dart';
import 'package:rukunin/pages/rt/wilayah/widgets/street_simple_card.dart';

typedef OnDeleteStreet = Future<bool> Function(int index);

class StreetList extends StatelessWidget {
  final List<Street> items;
  final List residents;
  final void Function(Street street) onTap;
  final OnDeleteStreet onDelete;

  const StreetList({
    required this.items,
    required this.residents,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Belum ada jalan terdaftar',
          style: TextStyle(color: Colors.grey[700]),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (c, i) {
        final s = items[i];
        return Dismissible(
          key: ValueKey(s.name),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.95),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Hapus',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          confirmDismiss: (_) async {
            // delegate confirm + delete handling to parent
            return await onDelete(i);
          },
          child: StreetSimpleCard(
            streetName: s.name,
            totalHouses: s.totalHouses,
            onTap: () => onTap(s),
          ),
        );
      },
    );
  }
}
