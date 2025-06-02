import 'package:app_livraria/utils/famous_authors.dart';
import 'package:flutter/material.dart';
import '../models/author.dart';

class AuthorProvider extends ChangeNotifier {
  List<Author> _authors = [];
  bool _isLoading = false;

  List<Author> get authors => _authors;
  bool get isLoading => _isLoading;

  Future<void> loadFamousAuthors() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _authors = famousAuthors;
    _isLoading = false;
    notifyListeners();
  }
}
