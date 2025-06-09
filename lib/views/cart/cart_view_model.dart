import 'dart:async';

import 'package:app_livraria/models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> submitOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final order = OrderUser(
      userId: user.uid,
      items: items,
      total: totalPrice,
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('orders').add(order.toMap());
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
