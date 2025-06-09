import 'package:app_livraria/core/widgets/book_card.dart';
import 'package:app_livraria/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class BookSection extends StatelessWidget {
  final String title;

  const BookSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Consumer<BookProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300, 
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, 
                      itemBuilder: (context, index) {
                        return Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryPink,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 16,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 14,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(5, (index) => 
                                  Container(
                                    width: 12,
                                    height: 12,
                                    margin: const EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.books.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryPink.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_off,
                          color: AppColors.primaryPink,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Nenhum livro encontrado para "$title"',
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 20),
                    itemCount: provider.books.length,
                    itemBuilder: (context, index) {
                      final book = provider.books[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: BookCard(book: book),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryPink,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.lightPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Novo',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryPink,
            ),
          ),
        ),
      ],
    );
  }
}