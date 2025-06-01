import 'package:app_livraria/core/services/open_library_service.dart';
import 'package:app_livraria/models/book.dart';
import 'package:flutter/material.dart';


class SearchProvider with ChangeNotifier {
  final _service = OpenLibraryService();

  List<Book> _results = [];
  List<Book> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _results = await _service.fetchBooks(query);
    } catch (e) {
      _results = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
