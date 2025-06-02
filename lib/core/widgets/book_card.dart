import 'package:flutter/material.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/views/book_details/book_details_screen.dart';
import 'package:app_livraria/core/services/open_library_service.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final service = OpenLibraryService();
        final description = await service.fetchBookDescription(book.key);
        final bookWithDescription = book.copyWith(description: description);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailsScreen(book: bookWithDescription),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          book.coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.book, size: 40)),
        ),
      ),
    );
  }
}
