import 'package:flutter/material.dart';
import '../models/status_iuran.dart';

class IuranCard extends StatelessWidget {
  final StatusIuran status;

  const IuranCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Informasi Warga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.nama,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    status.nik,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status.rt,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  // Status Pembayaran
                  if (status.sudahBayar) ...[
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "Sudah Membayar",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Belum Membayar",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Nominal & metode
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Rp ${status.nominal.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status.metodePembayaran ?? "-",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  status.tanggalBayar != null
                      ? "${status.tanggalBayar!.day}-${status.tanggalBayar!.month}-${status.tanggalBayar!.year}"
                      : "-",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
