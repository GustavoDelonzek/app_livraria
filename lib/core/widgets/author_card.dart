import 'package:flutter/material.dart';
import 'package:app_livraria/models/author.dart';
import 'package:app_livraria/views/author/author_books_screen.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class AuthorCard extends StatelessWidget {
  final Author author;

  const AuthorCard({
    super.key,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuthorBooksScreen(author: author),
          ),
        );
      },
      child: Container(
        width: 120,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        author.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.primaryGreen,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryGreen,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              author.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 4),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Autor Popular', 
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}