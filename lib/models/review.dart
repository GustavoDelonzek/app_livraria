// lib/models/review.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String bookId;
  final String userId;
  final String content;
  final int rating;
  final int likeCount;
  final List<String> likedBy;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.likeCount,
    required this.likedBy,
  });

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      bookId: map['bookId'],
      userId: map['userId'],
      content: map['content'],
      rating: map['rating'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likeCount: map['likeCount'],
      likedBy: List<String>.from(map['likedBy']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'userId': userId,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'likedBy': likedBy,
    };
  }
}
