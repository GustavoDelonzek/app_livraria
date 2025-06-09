import 'package:app_livraria/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  final BookProvider medievalProvider = BookProvider();
  final BookProvider romanceProvider = BookProvider();
  final BookProvider sciFiProvider = BookProvider();

  HomeViewModel() {
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([
      medievalProvider.fetchBooksBySubject('suspense'),
      romanceProvider.fetchBooksBySubject('romance'),
      sciFiProvider.fetchBooksBySubject('fiction'),
    ]);
    notifyListeners(); 
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
