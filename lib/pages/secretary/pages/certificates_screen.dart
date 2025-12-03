import 'package:flutter/material.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/widgets/rukunin_app_bar.dart';
import 'package:rukunin/pages/secretary/widgets/certificate/certificate_card.dart';
import 'package:rukunin/pages/secretary/widgets/certificate/certificate_form_screen.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  List<Map<String, String>> certificates = [
    {
      'title': 'Surat Keterangan Domisili',
      'resident': 'Budi Santoso',
      'date': '02 Des 2025',
    },
    {
      'title': 'Surat Keterangan Tidak Mampu',
      'resident': 'Siti Aminah',
      'date': '01 Des 2025',
    },
    {
      'title': 'Surat Keterangan Usaha',
      'resident': 'Ahmad Fauzi',
      'date': '30 Nov 2025',
    },
  ];

  List<Map<String, String>> filteredCertificates = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCertificates = List.from(certificates);
    _searchController.addListener(_filterCertificates);
  }

  void _filterCertificates() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCertificates = certificates.where((cert) {
        return cert['title']!.toLowerCase().contains(query) ||
            cert['resident']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void addCertificate(Map<String, String> certificate) {
    setState(() {
      certificates.add(certificate);
      _filterCertificates();
    });
  }

  void editCertificate(int index, Map<String, String> certificate) {
    setState(() {
      certificates[index] = certificate;
      _filterCertificates();
    });
  }

  void deleteCertificate(int index) {
    setState(() {
      certificates.removeAt(index);
      _filterCertificates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RukuninAppBar(
        title: 'Surat Keterangan',
        showNotification: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari surat / nama warga...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredCertificates.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada surat ditemukan',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredCertificates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final certificate = filteredCertificates[index];
                        final originalIndex = certificates.indexOf(certificate);
                        return CertificateCard(
                          title: certificate['title']!,
                          resident: certificate['resident']!,
                          date: certificate['date']!,
                          onTap: () async {
                            final updated =
                                await Navigator.push<Map<String, String>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CertificateFormScreen(
                                      initialData: certificate,
                                    ),
                                  ),
                                );
                            if (updated != null) {
                              editCertificate(originalIndex, updated);
                            }
                          },
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Hapus Surat'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus surat ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm ?? false) {
                              deleteCertificate(originalIndex);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCertificate = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(builder: (_) => const CertificateFormScreen()),
          );
          if (newCertificate != null) {
            addCertificate(newCertificate);
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
