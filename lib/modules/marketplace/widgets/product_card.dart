import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rukunin/modules/marketplace/models/product.dart';
import 'package:rukunin/theme/app_colors.dart';
import 'package:rukunin/utils/formatter/currency_formatter.dart';
import 'package:rukunin/l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed(
          'resident-product-detail',
          pathParameters: {'productId': product.id},
          extra: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        cacheWidth: 400,
                        cacheHeight: 400,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10), // Reduced from 12
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, // Reduced from 8
                        vertical: 3, // Reduced from 4
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(38),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.badge,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 6), // Reduced from 8
                    // Product Name - Fixed height
                    SizedBox(
                      height: 34, // Reduced from 36
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.2, // Reduced from 1.3
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 3), // Reduced from 4
                    // Seller - Fixed height
                    SizedBox(
                      height: 15, // Reduced from 16
                      child: Text(
                        product.seller,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.2, // Reduced from 1.3
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const Spacer(),

                    // Price and Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            CurrencyFormatter.format(product.price),
                            style: const TextStyle(
                              fontSize: 13, // Reduced from 14
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6), // Reduced from 8
                        Container(
                          width: 30, // Reduced from 32
                          height: 30, // Reduced from 32
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 16, // Reduced from 18
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3), // Reduced from 4
                    // Stock only - Fixed height
                    SizedBox(
                      height: 16, // Reduced from 18
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 13, // Reduced from 14
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 3), // Reduced from 4
                          Flexible(
                            child: Text(
                              '${l10n.stock}: ${product.stock}',
                              style: TextStyle(
                                fontSize: 11, // Reduced from 12
                                color: Colors.grey[600],
                                height: 1.2, // Reduced from 1.3
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
