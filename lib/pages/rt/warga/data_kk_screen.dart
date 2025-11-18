import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/rt/rt_layout.dart';
import 'package:rukunin/pages/rt/warga/widgets/search_bar.dart';
import 'package:rukunin/pages/rt/warga/widgets/download_button.dart';
import 'package:rukunin/repositories/resident.dart';
import 'package:rukunin/models/resident.dart';
import 'package:rukunin/pages/rt/warga/widgets/doc_preview_dialog.dart';

class DataKkScreen extends StatefulWidget {
  const DataKkScreen({super.key});

  @override
  State<DataKkScreen> createState() => _DataKkScreenState();
}

class _DataKkScreenState extends State<DataKkScreen> {
  final List<Warga> _all = WargaRepository.generateDummy(count: 60);
  String _query = '';

  List<Warga> get _filtered {
    return _all.where((w) => w.kkUrl.isNotEmpty && (_query.isEmpty || w.name.toLowerCase().contains(_query.toLowerCase()) || w.kkNumber.contains(_query))).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return CommunityHeadLayout(
      title: 'Data KK',
      currentIndex: 0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: WargaSearchBar(onChanged: (v) => setState(() => _query = v))),
                  const SizedBox(width: 12),
                  DownloadButton(onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Berhasil diunduh'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ));
                  }),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isNotEmpty) Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Data KK warga RT ${items.first.rt} / RW ${items.first.rw}', style: TextStyle(color: Colors.grey[700])),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text('Tidak ada data KK', style: TextStyle(color: Colors.grey[600])))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final w = items[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                              child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => showDocPreview(context, type: 'KK', name: w.name, number: w.kkNumber, url: w.kkUrl),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.asset(
                                        w.kkUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          color: Colors.grey[100],
                                          child: const Center(child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                            Text(w.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(child: Text(w.kkNumber, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                                                const SizedBox.shrink(),
                                              ],
                                            )
                                          ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  
}
