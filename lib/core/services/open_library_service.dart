import 'dart:convert';
import 'package:app_livraria/models/book.dart';
import 'package:http/http.dart' as http;
import '../../../models/book.dart';

class OpenLibraryService {

  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List docs = data['docs'];

      return docs.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros');
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

  Future<String> fetchBookDescription(String workKey) async {
    final url = Uri.parse('https://openlibrary.org$workKey.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final desc = data['description'];
      if (desc is String) {
        return desc;
      } else if (desc is Map && desc.containsKey('value')) {
        return desc['value'];
      }
    }

    return 'Descrição não disponível.';
  }
}
