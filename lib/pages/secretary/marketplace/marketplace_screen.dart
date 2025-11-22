import 'package:flutter/material.dart';
import 'package:rukunin/modules/marketplace/widgets/my_shop_banner.dart';
import 'package:rukunin/repositories/products.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/category_chip.dart';
import 'package:rukunin/widgets/cards/promo_banner_card.dart';
import 'package:rukunin/modules/marketplace/widgets/product_card.dart';
import 'package:rukunin/modules/marketplace/widgets/search_bar_market.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

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

                  // Category Tabs (another horizontal scroll section)
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

                  // Products Grid (static inside vertical scroll)
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
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
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
}
