import 'package:app_livraria/core/widgets/book_section.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_view_model.dart';
import '../../../core/widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeViewModel, _) {
          final user = homeViewModel.currentUser;

          return Scaffold(
            appBar: AppBar(
            title: const Text('Livraria'),
            actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  if (user != null)
                    Text('Olá, ${user.email}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),

                  ChangeNotifierProvider.value(
                    value: homeViewModel.bestSellerProvider,
                    child: const BookSection(title: 'Best Sellers'),
                  ),

                  ChangeNotifierProvider.value(
                    value: homeViewModel.romanceProvider,
                    child: const BookSection(title: 'Romance'),
                  ),

                  ChangeNotifierProvider.value(
                    value: homeViewModel.sciFiProvider,
                    child: const BookSection(title: 'Ficção Científica'),
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
