import 'package:flutter/material.dart';
import 'package:rukunin/pages/admin/admin_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/pages/admin/marketplace/marketplace_add_page.dart';

class MarketplaceListPage extends StatefulWidget {
  const MarketplaceListPage({super.key});

  @override
  State<MarketplaceListPage> createState() => _MarketplaceListPageState();
}

class _MarketplaceListPageState extends State<MarketplaceListPage> {
  String selectedCategory = 'Semua';
  String searchQuery = '';
  final TextEditingController searchC = TextEditingController();

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Marketplace',
      currentIndex: 3,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 96.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kelola Produk & Jasa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '6 Produk',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  TextField(
                    controller: searchC,
                    decoration: InputDecoration(
                      hintText: 'Cari produk atau penjual...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (v) => setState(() => searchQuery = v),
                  ),
                  const SizedBox(height: 16),

                  // Filter Category
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip('Semua'),
                        _buildCategoryChip('Makanan'),
                        _buildCategoryChip('Minuman'),
                        _buildCategoryChip('Jasa'),
                        _buildCategoryChip('Lainnya'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product List
                  _buildProductCard(
                    id: '1',
                    name: 'Nasi Goreng Spesial',
                    seller: 'Warung Bu Siti',
                    phone: '081234567890',
                    price: 15000,
                    category: 'Makanan',
                    image: '🍛',
                    stock: 20,
                    isActive: true,
                  ),
                  _buildProductCard(
                    id: '2',
                    name: 'Es Teh Manis',
                    seller: 'Warung Bu Siti',
                    phone: '081234567890',
                    price: 3000,
                    category: 'Minuman',
                    image: '🥤',
                    stock: 50,
                    isActive: true,
                  ),
                  _buildProductCard(
                    id: '3',
                    name: 'Cuci Motor',
                    seller: 'Bengkel Pak Budi',
                    phone: '081234567891',
                    price: 10000,
                    category: 'Jasa',
                    image: '🏍️',
                    stock: 0,
                    isActive: true,
                  ),
                  _buildProductCard(
                    id: '4',
                    name: 'Kue Brownies',
                    seller: 'Dapur Ibu Ani',
                    phone: '081234567892',
                    price: 25000,
                    category: 'Makanan',
                    image: '🍰',
                    stock: 15,
                    isActive: true,
                  ),
                  _buildProductCard(
                    id: '5',
                    name: 'Jus Alpukat',
                    seller: 'Warung Bu Siti',
                    phone: '081234567890',
                    price: 12000,
                    category: 'Minuman',
                    image: '🥑',
                    stock: 0,
                    isActive: false,
                  ),
                  _buildProductCard(
                    id: '6',
                    name: 'Service AC',
                    seller: 'Teknisi Pak Joko',
                    phone: '081234567893',
                    price: 150000,
                    category: 'Jasa',
                    image: '❄️',
                    stock: 0,
                    isActive: true,
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MarketplaceAddPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (v) => setState(() => selectedCategory = category),
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String id,
    required String name,
    required String seller,
    required String phone,
    required int price,
    required String category,
    required String image,
    required int stock,
    required bool isActive,
  }) {
    bool isService = category == 'Jasa';

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/marketplace/detail',
              arguments: {
                'id': id,
                'name': name,
                'seller': seller,
                'phone': phone,
                'price': price,
                'category': category,
                'image': image,
                'stock': stock,
                'isActive': isActive,
                'description': 'Deskripsi lengkap untuk $name. Produk berkualitas dengan harga terjangkau.',
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image/Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(image, style: const TextStyle(fontSize: 35)),
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isActive ? 'Aktif' : 'Nonaktif',
                              style: TextStyle(
                                fontSize: 10,
                                color: isActive ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.store, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              seller,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!isService)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: stock > 0
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Stok: $stock',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: stock > 0 ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${_formatCurrency(price)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}