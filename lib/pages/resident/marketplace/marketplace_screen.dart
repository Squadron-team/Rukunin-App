import 'package:flutter/material.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';
import 'package:rukunin/modules/marketplace/widgets/my_shop_banner.dart';
import 'package:rukunin/modules/marketplace/services/product_service.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/category_chip.dart';
import 'package:rukunin/widgets/cards/promo_banner_card.dart';
import 'package:rukunin/modules/marketplace/widgets/product_card.dart';
import 'package:rukunin/modules/marketplace/widgets/search_bar_market.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pasar Warga',
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
      ),
      body: Column(
        children: [
          const SearchBarMarket(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const MyShopBanner(isHaveShop: true),
                  const SizedBox(height: 16),

                  // Promo Banners (horizontal scroll only for this section)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        PromoBannerCard(
                          title: 'PROMO 11.11!',
                          subtitle: 'Diskon hingga 50%',
                          primaryColor: AppColors.primary,
                          width: MediaQuery.of(context).size.width - 40,
                        ),
                        const SizedBox(width: 16),
                        PromoBannerCard(
                          title: 'Promo Akhir Tahun 🎉',
                          subtitle: 'Gratis ongkir se-Indonesia',
                          primaryColor: Colors.green,
                          width: MediaQuery.of(context).size.width - 40,
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Semua'),
                          child: CategoryChip(
                            label: 'Semua',
                            icon: '🏪',
                            isSelected: _selectedCategory == 'Semua',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Sayur'),
                          child: CategoryChip(
                            label: 'Sayur',
                            icon: '🥬',
                            isSelected: _selectedCategory == 'Sayur',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Buah'),
                          child: CategoryChip(
                            label: 'Buah',
                            icon: '🍎',
                            isSelected: _selectedCategory == 'Buah',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Daging'),
                          child: CategoryChip(
                            label: 'Daging',
                            icon: '🥩',
                            isSelected: _selectedCategory == 'Daging',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Minuman'),
                          child: CategoryChip(
                            label: 'Minuman',
                            icon: '🥤',
                            isSelected: _selectedCategory == 'Minuman',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedCategory = 'Peralatan'),
                          child: CategoryChip(
                            label: 'Peralatan',
                            icon: '🔧',
                            isSelected: _selectedCategory == 'Peralatan',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Products Grid with StreamBuilder
                  StreamBuilder<List<Product>>(
                    stream: _selectedCategory == 'Semua'
                        ? _productService.getProducts()
                        : _productService.getProductsByCategory(_selectedCategory),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Terjadi kesalahan: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      final products = snapshot.data ?? [];

                      if (products.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada produk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Padding(
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
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(product: product);
                          },
                        ),
                      );
                    },
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
}
