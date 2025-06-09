import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<void> submitOrder(String userId, List<Map<String, dynamic>> items) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final orderData = {
        'userId': userId,
        'items': items, 
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      await _firestore.collection('orders').add(orderData);

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = 'Erro ao enviar pedido: $e';
      notifyListeners();
    }
  }

  Future<bool> hasPurchasedBook(String userId, String bookId) async {
    final querySnapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('items.bookId', arrayContains: bookId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
