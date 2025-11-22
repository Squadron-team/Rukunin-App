import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/pages/resident/marketplace/cart_screen.dart';
import 'package:rukunin/style/app_colors.dart';

class SearchBarMarket extends StatelessWidget {
  const SearchBarMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.goNamed('resident-marketplace-search');
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.search, color: Colors.grey[400]),
                    ),
                    Expanded(
                      child: Text(
                        'Cari produk yang anda cari',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
