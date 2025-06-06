import 'dart:async';
import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/models/book.dart';

class SearchViewModel extends ChangeNotifier {
  final GoogleBooksService _service = GoogleBooksService();

  List<Book> books = [];
  bool isLoading = false;
  bool hasMore = true; 
  int _page = 1;
  String _lastQuery = '';

  Timer? _debounce;

  void onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (text.length < 3) {
      books = [];
      isLoading = false;
      hasMore = true;
      _page = 1;
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (text != _lastQuery) {
        books = [];
        _page = 1;
        hasMore = true;
        _lastQuery = text;
      }
      await _search(text, page: _page, append: false);
    });
  }

  Future<void> loadNextPage() async {
    if (isLoading || !hasMore) return;
    _page++;
    await _search(_lastQuery, page: _page, append: true);
  }

  Future<void> _search(String query, {required int page, required bool append}) async {
    isLoading = true;
    notifyListeners();

    try {
      final newBooks = await _service.fetchBooks(query);

      if (append) {
        books.addAll(newBooks);
      } else {
        books = newBooks;
      }

      hasMore = newBooks.length >= 20; 
    } catch (e) {
      if (!append) books = [];
      hasMore = false;
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
