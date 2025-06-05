import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/models/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference get _cartRef => _firestore
      .collection('users')
      .doc(_userId)
      .collection('cart');

  String _normalizeKey(String key) {
    return key.replaceAll('/', '_');
  }

  Future<void> addToCart(Book book) async {
    final docId = _normalizeKey(book.key);
    final doc = _cartRef.doc(docId);

    final existing = await doc.get();
    if (existing.exists) {
      final currentQty = existing['quantity'] ?? 1;
      await doc.update({'quantity': currentQty + 1});
    } else {
      await doc.set({
        'title': book.title,
        'author': book.author,
        'thumbnailUrl': book.thumbnailUrl,
        'price': book.price,
        'quantity': 1,
        'bookKey': book.key, 
      });
    }
  }

  Future<void> removeFromCart(String bookId) async {
    final docId = _normalizeKey(bookId);
    await _cartRef.doc(docId).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await _cartRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<CartItem>> fetchCartItems() async {
    final snapshot = await _cartRef.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final book = Book(
        key: data['bookKey'],
        title: data['title'],
        author: data['author'],
        thumbnailUrl: data['thumbnailUrl'],
        price: (data['price'] as num).toDouble(),
        description: null, 
      );
      return CartItem(
        id: doc.id,
        book: book,
        quantity: data['quantity'],
        userId: _userId,
      );
    }).toList();
  }

  Stream<List<CartItem>> cartItemsStream() {
    return _cartRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final book = Book(
          key: data['bookKey'],
          title: data['title'],
          author: data['author'],
          thumbnailUrl: data['thumbnailUrl'],
          price: (data['price'] as num).toDouble(),
          description: null,
        );
        return CartItem(
          id: doc.id,
          book: book,
          quantity: data['quantity'],
          userId: _userId,
        );
      }).toList();
    });
  }

  Future<void> updateQuantity(String bookId, int quantity) async {
    final docId = _normalizeKey(bookId);
    if (quantity <= 0) {
      await removeFromCart(bookId);
    } else {
      await _cartRef.doc(docId).update({'quantity': quantity});
    }
  }
}
