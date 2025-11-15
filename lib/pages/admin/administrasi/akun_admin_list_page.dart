import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/admin/administrasi/akun_admin_edit_page.dart';

class AkunAdminListPage extends StatefulWidget {
  const AkunAdminListPage({super.key});

  @override
  State<AkunAdminListPage> createState() => _AkunAdminListPageState();
}

class _AkunAdminListPageState extends State<AkunAdminListPage> {
  String selectedRole = 'Semua';
  String searchQuery = '';

  final List<String> roleFilters = [
    'Semua',
    'Admin Sistem',
    'Ketua RT',
    'Ketua RW',
    'Bendahara',
    'Sekretaris',
  ];

  final List<Map<String, dynamic>> admins = [
    {
      'id': '1',
      'name': 'Ahmad Wijaya',
      'email': 'ahmad.wijaya@rukunin.id',
      'phone': '081234567890',
      'role': 'Admin Sistem',
      'roleColor': Colors.red,
      'roleIcon': Icons.admin_panel_settings,
      'status': 'Aktif',
      'joinDate': '15 Jan 2024',
      'lastLogin': '2 jam lalu',
      'avatar': 'AW',
    },
    {
      'id': '2',
      'name': 'Siti Nurhaliza',
      'email': 'siti.nurhaliza@rukunin.id',
      'phone': '081234567891',
      'role': 'Admin Sistem',
      'roleColor': Colors.red,
      'roleIcon': Icons.admin_panel_settings,
      'status': 'Aktif',
      'joinDate': '20 Jan 2024',
      'lastLogin': '5 jam lalu',
      'avatar': 'SN',
    },
    {
      'id': '3',
      'name': 'Budi Santoso',
      'email': 'budi.santoso@rukunin.id',
      'phone': '081234567892',
      'role': 'Ketua RT',
      'roleColor': Colors.blue,
      'roleIcon': Icons.supervised_user_circle,
      'status': 'Aktif',
      'joinDate': '01 Feb 2024',
      'lastLogin': '1 hari lalu',
      'avatar': 'BS',
    },
    {
      'id': '4',
      'name': 'Dewi Lestari',
      'email': 'dewi.lestari@rukunin.id',
      'phone': '081234567893',
      'role': 'Ketua RT',
      'roleColor': Colors.blue,
      'roleIcon': Icons.supervised_user_circle,
      'status': 'Aktif',
      'joinDate': '05 Feb 2024',
      'lastLogin': '3 jam lalu',
      'avatar': 'DL',
    },
    {
      'id': '5',
      'name': 'Eko Prasetyo',
      'email': 'eko.prasetyo@rukunin.id',
      'phone': '081234567894',
      'role': 'Ketua RW',
      'roleColor': Colors.purple,
      'roleIcon': Icons.account_balance,
      'status': 'Aktif',
      'joinDate': '10 Feb 2024',
      'lastLogin': '1 jam lalu',
      'avatar': 'EP',
    },
    {
      'id': '6',
      'name': 'Fatimah Zahra',
      'email': 'fatimah.zahra@rukunin.id',
      'phone': '081234567895',
      'role': 'Bendahara',
      'roleColor': Colors.green,
      'roleIcon': Icons.account_balance_wallet,
      'status': 'Aktif',
      'joinDate': '15 Feb 2024',
      'lastLogin': '30 menit lalu',
      'avatar': 'FZ',
    },
    {
      'id': '7',
      'name': 'Gunawan Wijaya',
      'email': 'gunawan.wijaya@rukunin.id',
      'phone': '081234567896',
      'role': 'Bendahara',
      'roleColor': Colors.green,
      'roleIcon': Icons.account_balance_wallet,
      'status': 'Aktif',
      'joinDate': '20 Feb 2024',
      'lastLogin': '2 hari lalu',
      'avatar': 'GW',
    },
    {
      'id': '8',
      'name': 'Hana Permata',
      'email': 'hana.permata@rukunin.id',
      'phone': '081234567897',
      'role': 'Sekretaris',
      'roleColor': Colors.orange,
      'roleIcon': Icons.description,
      'status': 'Aktif',
      'joinDate': '25 Feb 2024',
      'lastLogin': '4 jam lalu',
      'avatar': 'HP',
    },
    {
      'id': '9',
      'name': 'Irfan Hakim',
      'email': 'irfan.hakim@rukunin.id',
      'phone': '081234567898',
      'role': 'Sekretaris',
      'roleColor': Colors.orange,
      'roleIcon': Icons.description,
      'status': 'Nonaktif',
      'joinDate': '01 Mar 2024',
      'lastLogin': '1 minggu lalu',
      'avatar': 'IH',
    },
  ];

  List<Map<String, dynamic>> get filteredAdmins {
    return admins.where((admin) {
      final matchesRole = selectedRole == 'Semua' || admin['role'] == selectedRole;
      final matchesSearch = admin['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          admin['email'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesRole && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AkunAdminEditPage(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: AdminLayout(
        title: 'Kelola Akun Admin',
        currentIndex: 4,
        body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.manage_accounts,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kelola Akun Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manajemen akun administrator sistem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari nama atau email admin...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Role
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: roleFilters.length,
              itemBuilder: (context, index) {
                final role = roleFilters[index];
                final isSelected = selectedRole == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(role),
                    onSelected: (selected) {
                      setState(() {
                        selectedRole = role;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),

          // List Admin
          Expanded(
            child: filteredAdmins.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada admin ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredAdmins.length,
                    itemBuilder: (context, index) {
                      final admin = filteredAdmins[index];
                      return _buildAdminCard(context, admin);
                    },
                  ),
          ),
        ],
      ),
    ),
    );
  }
}
  

  Widget _buildAdminCard(BuildContext context, Map<String, dynamic> admin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AkunAdminEditPage(adminId: admin['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: admin['roleColor'].withOpacity(0.1),
                child: Text(
                  admin['avatar'],
                  style: TextStyle(
                    color: admin['roleColor'],
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            admin['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: admin['status'] == 'Aktif'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            admin['status'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: admin['status'] == 'Aktif' ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(admin['roleIcon'], size: 14, color: admin['roleColor']),
                        const SizedBox(width: 4),
                        Text(
                          admin['role'],
                          style: TextStyle(
                            fontSize: 12,
                            color: admin['roleColor'],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.email_outlined, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            admin['email'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Login terakhir: ${admin['lastLogin']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
