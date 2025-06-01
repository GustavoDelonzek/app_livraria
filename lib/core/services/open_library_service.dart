import 'dart:convert';
import 'package:app_livraria/models/book.dart';
import 'package:http/http.dart' as http;
import '../../../models/book.dart';

class OpenLibraryService {
  Future<List<Book>> fetchBooks(String query) async {
    final url = Uri.parse('https://openlibrary.org/search.json?q=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List docs = data['docs'];

      return docs.take(10).map((doc) => Book.fromJson(doc)).toList();
    } else {
      throw Exception('Erro ao buscar livros da Open Library');
    }
  }

  Future<List<Book>> fetchBooksBySubject(String subject) async {
    final url = Uri.parse('https://openlibrary.org/subjects/$subject.json?limit=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final works = data['works'] as List;

      return works.map((work) => Book.fromSubjectJson(work)).toList();
    } else {
      throw Exception('Failed to load books by subject');
    }
  }
}
