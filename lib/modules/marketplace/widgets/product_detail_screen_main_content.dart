import 'package:flutter/material.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';
import 'package:rukunin/theme/app_colors.dart';

class ProductDetailScreenMainContent extends StatefulWidget {
  final Product product;

  const ProductDetailScreenMainContent({required this.product, super.key});

  @override
  State<ProductDetailScreenMainContent> createState() =>
      _ProductDetailScreenMainContentState();
}

class _ProductDetailScreenMainContentState
    extends State<ProductDetailScreenMainContent> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedTab == 0
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Deskripsi produk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedTab == 0
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedTab == 1
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Ulasan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedTab == 1
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Tab Content
        Text(
          _selectedTab == 0
              ? widget.product.description
              : 'Ulasan pelanggan akan muncul di sini. Produknya bagus, kualitasnya oke banget, dan pengirimannya juga cepat!',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
        ),
      ],
    );
  }
}
