import 'package:flutter/material.dart';
import 'package:app_livraria/models/author.dart';
import 'package:app_livraria/views/author/author_books_screen.dart';

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
      child: Column(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: NetworkImage(author.imageUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Text(
            author.name,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
