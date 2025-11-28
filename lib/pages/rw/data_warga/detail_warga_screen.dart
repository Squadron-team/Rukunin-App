import 'package:flutter/material.dart';
import 'package:rukunin/pages/rw/data_warga/models/warga_model.dart';
import 'package:rukunin/pages/rw/data_warga/edit_warga_screen.dart';
import 'package:rukunin/style/app_colors.dart';

class DetailWargaScreen extends StatefulWidget {
  final Warga warga;

  const DetailWargaScreen({required this.warga, super.key});

  @override
  State<DetailWargaScreen> createState() => _DetailWargaScreenState();
}

class _DetailWargaScreenState extends State<DetailWargaScreen> {
  late Warga currentWarga;

  @override
  void initState() {
    super.initState();
    currentWarga = widget.warga;
  }

  void _refreshData() {
    final updatedWarga = DummyWargaData.getWargaById(currentWarga.id);
    if (updatedWarga != null) {
      setState(() {
        currentWarga = updatedWarga;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 20),
                _buildInfoSection(),
                const SizedBox(height: 20),
                _buildActionButtons(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== APP BAR ====================
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context, true),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditWargaScreen(warga: currentWarga),
              ),
            );
            if (result == true) {
              _refreshData();
            }
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onPressed: () => _showDeleteDialog(context),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== PROFILE HEADER ====================
  Widget _buildProfileHeader() {
    return Transform.translate(
      offset: const Offset(0, -60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(currentWarga.fotoUrl),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            currentWarga.nama,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              currentWarga.pekerjaan,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== INFO SECTION ====================
  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Informasi Pribadi'),
          const SizedBox(height: 12),
          _infoCard([
            _infoRow(Icons.credit_card, 'NIK', currentWarga.nik),
            _divider(),
            _infoRow(Icons.person, 'Jenis Kelamin', currentWarga.jenisKelamin),
            _divider(),
            _infoRow(
              Icons.cake,
              'Tempat, Tanggal Lahir',
              '${currentWarga.tempatLahir}, ${currentWarga.tanggalLahir}',
            ),
            _divider(),
            _infoRow(
              Icons.favorite,
              'Status Perkawinan',
              currentWarga.statusPerkawinan,
            ),
          ]),
          const SizedBox(height: 20),
          _sectionTitle('Alamat & Kontak'),
          const SizedBox(height: 12),
          _infoCard([
            _infoRow(Icons.home, 'Alamat', currentWarga.alamat),
            _divider(),
            _infoRow(
              Icons.location_city,
              'RT / RW',
              'RT ${currentWarga.rt} / RW ${currentWarga.rw}',
            ),
            _divider(),
            _infoRow(Icons.phone, 'No. Telepon', currentWarga.noTelepon),
          ]),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey[200]);
  }

  // ==================== ACTION BUTTONS ====================
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditWargaScreen(warga: currentWarga),
                  ),
                );
                if (result == true) {
                  _refreshData();
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteDialog(context),
              icon: const Icon(Icons.delete),
              label: const Text('Hapus'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== DELETE DIALOG ====================
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Data Warga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus data ${currentWarga.nama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              DummyWargaData.deleteWarga(currentWarga.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Close detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data warga berhasil dihapus'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
