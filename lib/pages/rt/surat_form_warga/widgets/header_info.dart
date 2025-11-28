import 'package:flutter/material.dart';
import 'package:rukunin/pages/rt/surat_form_warga/models/document_request.dart';
import 'package:rukunin/style/app_colors.dart';

class RequestHeaderInfo extends StatelessWidget {
  final DocumentRequest request;
  final Color catColor;
  final String Function(DateTime) relativeTime;

  const RequestHeaderInfo({
    required this.request,
    required this.catColor,
    required this.relativeTime,
    super.key,
  });

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 14, color: isHighlight ? AppColors.primary : Colors.black, fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [catColor.withOpacity(0.20), catColor.withOpacity(0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            border: Border.all(color: catColor.withOpacity(0.3)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: catColor.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))]), child: const Icon(Icons.description, color: Colors.white, size: 28)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(request.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
              const SizedBox(height: 6),
              Text('Informasi Pengajuan', style: TextStyle(fontSize: 13, color: Colors.grey[800])),
            ])),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)), border: Border.all(color: catColor.withOpacity(0.18))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 12),
            _infoRow('Pemohon', request.requester),
            const SizedBox(height: 12),
            _infoRow('Tujuan', request.purpose),
            const SizedBox(height: 12),
            _infoRow('Dikirim', relativeTime(request.createdAt.toLocal())),
          ]),
        ),
      ],
    );
  }
}
