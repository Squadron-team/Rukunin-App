import 'package:flutter/material.dart';
import '../data/dummy_kegiatan.dart';

class KegiatanStatCards extends StatelessWidget {
  const KegiatanStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(child: _card("Akan Datang", DummyKegiatanData.getAkanDatang(), Icons.schedule, Colors.blue)),
          SizedBox(width: 12),
          Expanded(child: _card("Berlangsung", DummyKegiatanData.getSedangBerlangsung(), Icons.play_circle, Colors.green)),
          SizedBox(width: 12),
          Expanded(child: _card("Selesai", DummyKegiatanData.getSelesai(), Icons.check_circle, Colors.grey)),
        ],
      ),
    );
  }

  Widget _card(String label, int value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          SizedBox(height: 6),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }
}
