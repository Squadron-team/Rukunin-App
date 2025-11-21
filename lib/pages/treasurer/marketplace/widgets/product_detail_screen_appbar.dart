import 'package:flutter/material.dart';
import 'package:rukunin/style/app_colors.dart';

class ProductDetailScreenAppbar extends StatefulWidget {
  final bool isFavorite;

  const ProductDetailScreenAppbar({
    required this.isFavorite,
    super.key,
  });

  @override
  State<ProductDetailScreenAppbar> createState() =>
      _ProductDetailScreenAppbarState();
}

class _ProductDetailScreenAppbarState extends State<ProductDetailScreenAppbar> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: const Color(0xFFFFF5E6),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: _ActionButton(
          icon: Icons.arrow_back_ios_new,
          iconColor: Colors.black,
          onTap: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: _ActionButton(
            icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
            iconColor: _isFavorite ? Colors.red : Colors.black,
            onTap: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            _buildImage(),
            const SizedBox(height: 20),
            _buildIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          size: 60,
          color: Colors.orange[300],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == 0 ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == 0 ? AppColors.primary : Colors.orange[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
