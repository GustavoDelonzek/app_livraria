import 'package:app_livraria/core/widgets/author_section.dart';
import 'package:app_livraria/core/widgets/book_section.dart';
import 'package:app_livraria/providers/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/footer.dart';
import 'home_view_model.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

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
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    AppColors.lightPink.withOpacity(0.1),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryPink,
                            AppColors.darkPink,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user != null)
                                  Text(
                                    'Olá, ${user.email?.split('@')[0]}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Descubra sua próxima\nleitura favorita',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Explore nossa coleção de livros selecionados especialmente para você',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.auto_stories,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('500+', 'Livros', Icons.book),
                          _buildDivider(),
                          _buildStatItem('50+', 'Autores', Icons.person),
                          _buildDivider(),
                          _buildStatItem('10+', 'Gêneros', Icons.category),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.lightGreen,
                            AppColors.primaryGreen.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_offer,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Oferta Especial!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Frete grátis em compras acima de R\$ 50',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    ChangeNotifierProvider.value(
                      value: viewModel.medievalProvider,
                      child: const BookSection(title: 'Suspense'),
                    ),


                    ChangeNotifierProvider(
                      create: (_) => AuthorProvider()..loadFamousAuthors(),
                      child: const AuthorSection(title: 'Autores em Destaque'),
                    ),

                    ChangeNotifierProvider.value(
                      value: viewModel.romanceProvider,
                      child: const BookSection(title: 'Romance'),
                    ),


                    ChangeNotifierProvider.value(
                      value: viewModel.sciFiProvider,
                      child: const BookSection(title: 'Ficção Científica'),
                    ),


                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.textDark,
                            AppColors.textDark.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.notifications_active,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Fique por dentro!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Receba notificações sobre novos lançamentos e ofertas especiais',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryPink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Inscrever-se',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const AppFooter(),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.primaryPink,
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}