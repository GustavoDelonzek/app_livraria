import 'package:app_livraria/core/widgets/book_card.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/models/author.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/core/services/google_books_service.dart';

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
      appBar: AppBar(
        title: Text(widget.author.name),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return const Center(child: Text('Nenhum livro encontrado para este autor.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                return BookCard(book: books[index]);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: AppFooter(),
    );
  }
}
