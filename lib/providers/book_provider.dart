import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:app_livraria/core/services/open_library_service.dart';
import 'package:app_livraria/models/book.dart';
import 'package:flutter/material.dart';


class BookProvider extends ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  final OpenLibraryService _openLibraryService = OpenLibraryService();
  final GoogleBooksService _googleBooksService = GoogleBooksService();

    void setSelectedTabIndex(int index) {
      if (_selectedTabIndex != index) {
        _selectedTabIndex = index;
        notifyListeners();
      }
    }

  Future<void> fetchBooks(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _googleBooksService.fetchBooks(query);
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
      _books = await _googleBooksService.fetchBooksBySubject(subject);
    } catch (e) {
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchBooksFamous() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _googleBooksService.fetchBooksFamous();
    } catch (e) {
      _books = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
