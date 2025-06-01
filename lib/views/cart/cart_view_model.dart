import 'package:flutter/material.dart';
import '../../../models/book.dart';

class CartViewModel extends ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => _items;

  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void addToCart(Book book) {
    _items.add(book);
    notifyListeners();
  }

  void removeFromCart(Book book) {
    _items.remove(book);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
