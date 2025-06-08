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
