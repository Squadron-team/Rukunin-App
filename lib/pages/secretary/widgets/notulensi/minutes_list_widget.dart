import 'package:flutter/material.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_item.dart';
import 'package:rukunin/pages/secretary/widgets/notulensi/minutes_model.dart';

class MinutesListWidget extends StatelessWidget {
  final List<MinutesModel> data;
  final Function(MinutesModel) onTap;
  final Function(MinutesModel) onDelete;

  const MinutesListWidget({
    required this.data,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return MinutesItem(
          data: data[index],
          onTap: () => onTap(data[index]),
          onDelete: () => onDelete(data[index]),
        );
      },
    );
  }
}
