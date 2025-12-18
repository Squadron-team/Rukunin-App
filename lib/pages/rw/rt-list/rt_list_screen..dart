import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RtListScreen extends StatefulWidget {
  const RtListScreen({super.key});

  @override
  State<RtListScreen> createState() => _RtListScreenState();
}

class _RtListScreenState extends State<RtListScreen> {
  final List<Map<String, dynamic>> rtList = [
    {'rt': 'RT 01', 'kk': 45, 'warga': 160},
    {'rt': 'RT 02', 'kk': 38, 'warga': 140},
    {'rt': 'RT 03', 'kk': 52, 'warga': 190},
    {'rt': 'RT 04', 'kk': 41, 'warga': 150},
    {'rt': 'RT 05', 'kk': 47, 'warga': 170},
    {'rt': 'RT 06', 'kk': 33, 'warga': 120},
  ];

  String search = '';
  bool isLoading = false;

  // Fungsi untuk simulasi refresh
  Future<void> _handleRefresh() async {
    setState(() => isLoading = true);

    // Simulasi delay network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);

    // Tampilkan snackbar sukses
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRt = rtList
        .where(
          (rt) =>
              (rt['rt'] as String).toLowerCase().contains(search.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Daftar RT',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRefresh,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              _buildSummary(),
              _buildSearch(),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLoading
                      ? _buildLoadingState()
                      : _buildRtList(filteredRt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================
  // SUMMARY
  // =============================
  Widget _buildSummary() {
    final totalKK = rtList.fold<int>(0, (sum, rt) => sum + (rt['kk'] as int));
    final totalWarga = rtList.fold<int>(
      0,
      (sum, rt) => sum + (rt['warga'] as int),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(Icons.home_work, 'Total RT', rtList.length.toString()),
          _summaryItem(Icons.family_restroom, 'Total KK', totalKK.toString()),
          _summaryItem(Icons.people, 'Total Warga', totalWarga.toString()),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  // =============================
  // SEARCH
  // =============================
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari RT...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: search.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() => search = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() => search = value);
        },
      ),
    );
  }

  // =============================
  // LOADING STATE
  // =============================
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
            ),
            title: Container(
              height: 16,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                height: 12,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =============================
  // LIST RT
  // =============================
  Widget _buildRtList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      return _buildEmptyState();
    }

    // Cari RT dengan warga terbanyak
    final maxWarga = data
        .map((e) => e['warga'] as int)
        .reduce((a, b) => a > b ? a : b);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final rt = data[index];
        final isTopRT = rt['warga'] == maxWarga;
        return _rtCard(rt, isTopRT);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'RT tidak ditemukan',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba kata kunci lain',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _rtCard(Map<String, dynamic> rt, bool isTopRT) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isTopRT
            ? Border.all(color: Colors.amber.shade300, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: isTopRT
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.blue.withOpacity(0.1),
              child: Icon(
                Icons.home_rounded,
                color: isTopRT ? Colors.amber.shade700 : Colors.blue,
              ),
            ),
            title: Row(
              children: [
                Text(
                  rt['rt'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (isTopRT) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                ],
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  _infoChip(
                    Icons.family_restroom,
                    'KK',
                    (rt['kk'] as int).toString(),
                  ),
                  const SizedBox(width: 8),
                  _infoChip(
                    Icons.people,
                    'Warga',
                    (rt['warga'] as int).toString(),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: navigasi ke detail RT
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Membuka detail ${rt['rt']}'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          if (isTopRT)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 12,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Terbanyak',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
