import 'package:app_livraria/core/widgets/author_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/providers/author_provider.dart';

class AuthorSection extends StatelessWidget {
  final String title;

  const AuthorSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthorProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.authors.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Nenhum autor encontrado.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.authors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final author = provider.authors[index];
                  return AuthorCard(author: author);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
