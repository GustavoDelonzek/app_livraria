import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/providers/book_provider.dart';

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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                isSelected: bookProvider.selectedTabIndex == 0,
                onTap: () => onNavItemTap(0, '/home'),
              ),
              _buildNavItem(
                icon: Icons.search,
                isSelected: bookProvider.selectedTabIndex == 1,
                onTap: () => onNavItemTap(1, '/search'),
              ),
              _buildNavItem(
                icon: Icons.person,
                isSelected: bookProvider.selectedTabIndex == 2,
                onTap: () => onNavItemTap(2, '/profile'),
              ),
              
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isSelected ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 89, 86, 86),
          size: 24,
        ),
      ),
    );
  }
}
