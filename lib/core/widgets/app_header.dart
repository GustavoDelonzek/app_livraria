import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCart;
  final bool showBack;
  final VoidCallback? onSearch;
  final VoidCallback? onMore;

  const AppHeader({
    super.key,
    required this.title,
    this.showCart = false,
    this.showBack = false,
    this.onSearch,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        if (onSearch != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
        if (onMore != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: onMore,
          ),
        if (showCart)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
