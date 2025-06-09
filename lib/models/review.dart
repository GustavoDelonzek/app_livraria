import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String bookId;
  final String userId;
  final String userName;
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
    required this.userName,
  });

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      bookId: map['bookId'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      rating: map['rating'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likeCount: map['likeCount'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      userName: map['userName'] ?? '',
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
      'userName': userName,
    };
  }

   Review copyWith({
    String? id,
    String? bookId,
    String? userId,
    String? userName,
    String? content,
    int? rating,
    DateTime? createdAt,
    int? likeCount,
    List<String>? likedBy,
  }) {
    return Review(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
