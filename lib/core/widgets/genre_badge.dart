import 'package:flutter/material.dart';

class GenreBadge extends StatelessWidget {
  final String genre;
  
  const GenreBadge({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColorForGenre(genre),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        genre,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getTextColorForGenre(genre),
        ),
      ),
    );
  }
  
  Color _getColorForGenre(String genre) {
  switch (genre.toLowerCase()) {
    case 'ficção':
      return Colors.indigo[100]!;
    case 'romance':
      return Colors.pink[100]!;
    case 'mistério':
      return Colors.deepPurple[100]!;
    case 'fantasia':
      return Colors.teal[100]!;
    case 'terror':
      return Colors.red[100]!;
    case 'suspense':
      return Colors.brown[100]!;
    case 'história':
      return Colors.orange[100]!;
    case 'autoajuda':
      return Colors.green[100]!;
    case 'biografia':
      return Colors.amber[100]!;
    case 'aventura':
      return Colors.cyan[100]!;
    case 'ciência':
      return Colors.blue[100]!;
    case 'tecnologia':
      return Colors.grey[300]!;
    default:
      return Colors.grey[100]!;
  }
}

Color _getTextColorForGenre(String genre) {
  switch (genre.toLowerCase()) {
    case 'ficção':
      return Colors.indigo[900]!;
    case 'romance':
      return Colors.pink[900]!;
    case 'mistério':
      return Colors.deepPurple[900]!;
    case 'fantasia':
      return Colors.teal[900]!;
    case 'terror':
      return Colors.red[900]!;
    case 'suspense':
      return Colors.brown[900]!;
    case 'história':
      return Colors.orange[900]!;
    case 'autoajuda':
      return Colors.green[900]!;
    case 'biografia':
      return Colors.amber[900]!;
    case 'aventura':
      return Colors.cyan[900]!;
    case 'ciência':
      return Colors.blue[900]!;
    case 'tecnologia':
      return Colors.grey[800]!;
    default:
      return Colors.grey[800]!;
  }
}
}
