import 'dart:async';
import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:app_livraria/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/models/book.dart';

class SearchViewModel extends ChangeNotifier {
  final GoogleBooksService _service = GoogleBooksService();

  List<UserLocal> users = [];
  List<Book> books = [];

  bool isLoading = false;
  bool hasMore = true; 
  int _page = 1;
  String _lastQuery = '';

  Timer? _debounce;

  Future<void> onSearchTextChanged(String query, {bool searchUsers = false}) async {
    if (query.length < 3) {
      books = [];
      users = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    if (searchUsers) {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      users = result.docs
          .map((doc) => UserLocal.fromMap(doc.data(), doc.id))
          .toList();
    } else {
      books = await _service.fetchBooks(query);
    }

    isLoading = false;
    notifyListeners();
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
