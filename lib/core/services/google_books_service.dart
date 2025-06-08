import 'dart:convert';
import 'package:app_livraria/models/book.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class GoogleBooksService {
  final String apiKey = dotenv.env['GOOGLE_BOOKS_API_KEY']!;

  Future<List<Book>> fetchBooks(String query, {int startIndex = 0}) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=$query&startIndex=$startIndex&maxResults=20&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Book.fromGoogleJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros');
    }
  }

  Future<Book?> fetchBookById(String bookId) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes/$bookId?key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Book.fromGoogleJson(data);
      } else {
        print('Erro na API Google Books: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar livro: $e');
      return null;
    }
  }

  Future<String?> fetchBookTitleFromGoogleBooks(String volumeId) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes/$volumeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['volumeInfo']?['title'] as String?;
    } else {
      print('Erro ao buscar título do livro: ${response.statusCode}');
      return null;
    }
  }

  Future<List<Book>> fetchBooksBySubject(String subject) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=subject:$subject&orderBy=relevance&maxResults=20&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Book.fromGoogleJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros por assunto');
    }
  }

    Future<List<Book>> fetchBooksByAuthor(String authorName) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=inauthor:${Uri.encodeComponent(authorName)}&orderBy=relevance&maxResults=20&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Book.fromGoogleJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros por autor');
    }
  }

  Future<List<Book>> fetchBooksFamous() async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=a&orderBy=relevance&key=$apiKey',
    );

    final response = await http.get(url);

    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => Book.fromGoogleJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar livros por assunto');
    }
  }
}
