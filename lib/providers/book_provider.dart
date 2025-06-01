import 'package:app_livraria/core/services/open_library_service.dart';
import 'package:app_livraria/models/book.dart';
import 'package:flutter/material.dart';


class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  final OpenLibraryService _openLibraryService = OpenLibraryService();

  Future<void> fetchBooks(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _openLibraryService.fetchBooks(query);
    } catch (e) {
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBooksBySubject(String subject) async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _openLibraryService.fetchBooksBySubject(subject);
    } catch (e) {
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
