import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_livraria/core/services/cart_service.dart';
import 'package:app_livraria/models/cart_item.dart';
import 'package:app_livraria/models/book.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  bool isLoading = true;
  late final StreamSubscription _cartSub;

  CartViewModel() {
    _cartSub = _cartService.cartItemsStream().listen((cartItems) {
      _items = cartItems;
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _cartSub.cancel();
    super.dispose();
  }

  Future<void> addToCart(Book book) => _cartService.addToCart(book);
  Future<void> removeFromCart(String bookId) => _cartService.removeFromCart(bookId);
  Future<void> updateQuantity(String bookId, int qty) => _cartService.updateQuantity(bookId, qty);
  Future<void> clearCart() => _cartService.clearCart();

  double get totalPrice => _items.fold(0.0, (total, item) => total + item.book.price * item.quantity);

  bool isInCart(String bookId) {
    return _items.any((item) => item.book.key == bookId);
  }
}
