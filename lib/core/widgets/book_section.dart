import 'package:app_livraria/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_card.dart';


class BookSection extends StatelessWidget {
  final String title;

  const BookSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.books.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Nenhum livro encontrado para $title.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.books.length,
                itemBuilder: (context, index) {
                  final book = provider.books[index];
                  return BookCard(book: book);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
