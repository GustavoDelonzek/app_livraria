import 'package:app_livraria/core/widgets/author_section.dart';
import 'package:app_livraria/core/widgets/book_section.dart';
import 'package:app_livraria/providers/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/footer.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          final user = viewModel.currentUser;

         return Scaffold(
          appBar: AppHeader(
            title: 'Livraria',
            showCart: true,
            onSearch: () => Navigator.pushNamed(context, '/search'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(  
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user != null)
                        Text(
                          'Olá, ${user.email}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'Confira as novidades selecionadas para você!',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Popular Lists',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFCE4EC), Color(0xFFFFE0B2)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Romance Fiction',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('15 livros',
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            Text('2',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      ChangeNotifierProvider.value(
                        value: viewModel.medievalProvider,
                        child: const BookSection(title: 'Medieval'),
                      ),

                      const SizedBox(height: 48),
                      ChangeNotifierProvider(
                        create: (_) => AuthorProvider()..loadFamousAuthors(),
                        child: const AuthorSection(title: 'Top Autores'),
                      ),

                      ChangeNotifierProvider.value(
                        value: viewModel.romanceProvider,
                        child: const BookSection(title: 'Romance'),
                      ),

                      const SizedBox(height: 24),
                      ChangeNotifierProvider.value(
                        value: viewModel.sciFiProvider,
                        child: const BookSection(title: 'Ficção Científica'),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const AppFooter(),
        );
        },
      ),
    );
  }
}
