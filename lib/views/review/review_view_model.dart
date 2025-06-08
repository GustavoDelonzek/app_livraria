import 'package:app_livraria/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  Future<void> fetchReviews(String bookId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('bookId', isEqualTo: bookId)
        .orderBy('createdAt', descending: true)
        .get();

    _reviews = snapshot.docs
        .map((doc) => Review.fromMap(doc.data(), doc.id))
        .toList();
    notifyListeners();
  }

 Future<void> addReview(Review review) async {
    await _firestore.collection('reviews').add(review.toMap());
    await Future.delayed(const Duration(seconds: 1));
    await fetchReviews(review.bookId);
  }
}