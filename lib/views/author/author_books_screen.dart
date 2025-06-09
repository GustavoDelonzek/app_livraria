import 'package:app_livraria/core/widgets/book_card.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/models/author.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/core/services/google_books_service.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class AuthorBooksScreen extends StatefulWidget {
  final Author author;

  const AuthorBooksScreen({super.key, required this.author});

  @override
  State<AuthorBooksScreen> createState() => _AuthorBooksScreenState();
}

class _AuthorBooksScreenState extends State<AuthorBooksScreen> {
  final _googleBooksService = GoogleBooksService();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _googleBooksService.fetchBooksByAuthor(widget.author.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.author.name,
        showBack: true,
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
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            final books = snapshot.data ?? [];

            if (books.isEmpty) {
              return _buildEmptyState();
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildAuthorHeader(books.length),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return BookCard(book: books[index]);
                      },
                      childCount: books.length,
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }

  Widget _buildAuthorHeader(int bookCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryPink],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(widget.author.imageUrl),
                backgroundColor: AppColors.lightGreen,
                onBackgroundImageError: (_, __) {},
                child: widget.author.imageUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primaryGreen,
                      )
                    : null,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            widget.author.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.book_rounded,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  '$bookCount ${bookCount == 1 ? 'livro' : 'livros'} encontrado${bookCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Obras do Autor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Buscando livros de ${widget.author.name}...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Isso pode levar alguns segundos',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ops! Algo deu errado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar os livros de ${widget.author.name}',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Erro: $error',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _booksFuture = _googleBooksService.fetchBooksByAuthor(widget.author.name);
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightPink.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.book_outlined,
                size: 48,
                color: AppColors.primaryPink,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum livro encontrado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Não encontramos livros de ${widget.author.name} em nossa base de dados',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}