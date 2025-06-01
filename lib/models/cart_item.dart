import 'package:app_livraria/models/book.dart';

class CartItem {
  final String? id;
  final Book book;
  final int quantity;
  final String userId;

  String get coverUrl => book.coverUrl;

  CartItem({
    this.id,
    required this.book,
    required this.quantity,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'book': book.toMap(),
      'quantity': quantity,
      'userId': userId,
    };
  }

  factory CartItem.fromMap(String id, Map<String, dynamic> map) {
    return CartItem(
      id: id,
      book: Book.fromMap(map['book']),
      quantity: map['quantity'],
      userId: map['userId'],
    );
  }
}