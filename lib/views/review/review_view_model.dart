import 'package:app_livraria/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Review> _reviews = [];
  List<Review> get reviews => _reviews;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;


  Future<bool> hasUserBoughtBook(String userId, String bookId) async {
    try {
      final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final items = data['items'] as List<dynamic>?;

        if (items != null) {
          final bought = items.any((item) => item['bookId'] == bookId);
          if (bought) return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }


  Review? getUserReview(String userId, String bookId) {
    try {
      return _reviews.firstWhere((r) => r.userId == userId && r.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addOrUpdateReview(Review review) async {
    try {
      _loading = true;
      notifyListeners();

      final existingReview = getUserReview(review.userId, review.bookId);

      if (existingReview != null) {
        await _firestore.collection('reviews').doc(existingReview.id).set(review.toMap());
        final index = _reviews.indexWhere((r) => r.id == existingReview.id);
        _reviews[index] = review;
      } else {
        final docRef = await _firestore.collection('reviews').add(review.toMap());
        final newReview = review.copyWith(id: docRef.id);
        _reviews.insert(0, newReview);
      }

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _error = 'Erro ao enviar avaliação.';
      notifyListeners();
    }
  }

  Future<void> fetchReviews(String bookId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('bookId', isEqualTo: bookId)
          .orderBy('createdAt', descending: true)
          .get();

      _reviews = snapshot.docs
          .map((doc) => Review.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      _error = 'Erro ao carregar avaliações.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(Review review) async {
    try {
      final docRef = await _firestore.collection('reviews').add(review.toMap());

      final newReview = Review(
        id: docRef.id,
        bookId: review.bookId,
        userId: review.userId,
        userName: review.userName,
        content: review.content,
        rating: review.rating,
        createdAt: review.createdAt,
        likeCount: review.likeCount,
        likedBy: review.likedBy,
      );

      _reviews.insert(0, newReview);
      notifyListeners();

      fetchReviews(review.bookId);
    } catch (e) {
      _error = 'Erro ao enviar avaliação.';
      notifyListeners();
    }
  }
}
