import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/providers/book_provider.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        void onNavItemTap(int index, String routeName) {
          bookProvider.setSelectedTabIndex(index);
          Navigator.pushReplacementNamed(context, routeName);   
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'Início',
                    isSelected: bookProvider.selectedTabIndex == 0,
                    onTap: () => onNavItemTap(0, '/home'),
                  ),
                  _buildNavItem(
                    icon: Icons.search_rounded,
                    label: 'Buscar',
                    isSelected: bookProvider.selectedTabIndex == 1,
                    onTap: () => onNavItemTap(1, '/search'),
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    isSelected: bookProvider.selectedTabIndex == 2,
                    onTap: () => onNavItemTap(2, '/profile'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryPink.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primaryPink
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? Colors.white
                    : AppColors.textLight,
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 11 : 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected 
                    ? AppColors.primaryPink
                    : AppColors.textLight,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}