import 'package:flutter/material.dart';
import 'package:rukunin/models/product.dart';
import 'package:rukunin/pages/resident/resident_layout.dart';
import 'package:rukunin/style/app_colors.dart';
import 'package:rukunin/widgets/cards/category_chip.dart';
import 'package:rukunin/widgets/cards/market_promo_card.dart';
import 'package:rukunin/widgets/cards/product_card.dart';
import 'package:rukunin/widgets/search_bar_market.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResidentLayout(
      title: 'Pasar Warga',
      currentIndex: 1,
      body: Column(
        children: [
          const SearchBarMarket(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

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
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const ProductCard(
                          product: Product(
                            name: 'Pisang sehat wenak',
                            seller: 'Ibu Wijaya',
                            price: 'Rp 14.500',
                            badge: 'Buah-buahan',
                            description: 'Buah pisang enak, bergizi, yahut dah pokoknya!'
                          ),
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
}
