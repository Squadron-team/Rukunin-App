import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/repositories/products.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/category_chip.dart';
import 'package:rukunin/widgets/cards/promo_banner_card.dart';
import 'package:rukunin/pages/admin/marketplace/widgets/admin_product_card.dart';
import 'package:rukunin/modules/marketplace/widgets/search_bar_market.dart';

class AdminMarketplaceScreen extends StatefulWidget {
  const AdminMarketplaceScreen({super.key});

  @override
  State<AdminMarketplaceScreen> createState() => _AdminMarketplaceScreenState();
}

class _AdminMarketplaceScreenState extends State<AdminMarketplaceScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Semua', 'Menunggu', 'Disetujui'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pasar Warga (Admin)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: AppColors.primary),
            onPressed: () {
              _showModerationOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarMarket(),
          
          // Status Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedTabIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < _tabs.length - 1 ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Admin Notice Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Admin',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Memantau pasar - ketuk produk untuk moderasi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Promo Banners
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        PromoBannerCard(
                          title: 'PROMO 11.11!',
                          subtitle: 'Diskon hingga 50%',
                          primaryColor: AppColors.primary,
                        ),
                        PromoBannerCard(
                          title: 'Promo Akhir Tahun 🎉',
                          subtitle: 'Gratis ongkir se-Indonesia',
                          primaryColor: Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: index == 0 ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppColors.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Tabs
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CategoryChip(
                          label: 'Sayur',
                          icon: '🥬',
                          isSelected: true,
                        ),
                        CategoryChip(label: 'Buah', icon: '🍎'),
                        CategoryChip(label: 'Daging', icon: '🥩'),
                        CategoryChip(label: 'Minuman', icon: '🥤'),
                        CategoryChip(label: 'Peralatan', icon: '🔧'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Products Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.55,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return AdminProductCard(
                          product: product,
                          onTap: () {
                            context.pushNamed(
                              'admin-marketplace-detail',
                              extra: {
                                'id': product.id,
                                'name': product.name,
                                'seller': product.seller,
                                'phone': '081234567890',
                                'price': product.price,
                                'category': product.category,
                                'image': product.imageUrl,
                                'stock': product.stock,
                                'isActive': product.isActive,
                                'description': product.description,
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> get _filteredProducts {
    return products.where((product) {
      if (_selectedTabIndex == 0) return true; // Semua
      if (_selectedTabIndex == 1) return !product.isActive; // Menunggu
      if (_selectedTabIndex == 2) return product.isActive; // Disetujui
      return true;
    }).toList();
  }

  void _showModerationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opsi Moderasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.pending_actions, color: Colors.orange),
              title: const Text('Lihat Produk Menunggu'),
              subtitle: Text('${products.where((p) => !p.isActive).length} menunggu persetujuan'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Lihat Produk Disetujui'),
              subtitle: Text('${products.where((p) => p.isActive).length} sudah disetujui'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedTabIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
