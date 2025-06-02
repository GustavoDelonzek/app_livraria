import 'package:flutter/material.dart';
import 'package:app_livraria/models/author.dart';

class AuthorCard extends StatelessWidget {
  final Author author;
  final VoidCallback? onTap;

  const AuthorCard({
    super.key,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
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
