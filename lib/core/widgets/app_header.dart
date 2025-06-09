import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/views/cart/cart_view_model.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppColors.lightPink.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            if (showBack) ...[
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightPink.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.primaryPink,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: showBack ? TextAlign.left : TextAlign.center,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (onSearch != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.lightPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryPink,
                ),
                onPressed: onSearch,
                tooltip: 'Buscar',
              ),
            ),
          if (onMore != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.lightPink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.primaryPink,
                ),
                onPressed: onMore,
                tooltip: 'Mais opções',
              ),
            ),
          if (showCart)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Consumer<CartViewModel>(
                builder: (context, cartVM, child) {
                  final itemCount = cartVM.items.length;
                  
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightPink.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart_rounded,
                            color: AppColors.primaryPink,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cart');
                          },
                          tooltip: 'Carrinho',
                        ),
                      ),
                      if (itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              itemCount > 99 ? '99+' : itemCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}