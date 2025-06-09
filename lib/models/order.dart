import 'package:app_livraria/models/cart_item.dart';

class OrderUser {
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  OrderUser({
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((i) => {
        'bookId': i.book.key,
        'title': i.book.title,
        'quantity': i.quantity,
        'price': i.book.price,
      }).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
