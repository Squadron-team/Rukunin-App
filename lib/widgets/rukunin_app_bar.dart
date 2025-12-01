import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RukuninAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotification;

  const RukuninAppBar({
    required this.title,
    this.showNotification = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: showNotification
          ? [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                onPressed: () => context.push('/notifications'),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
