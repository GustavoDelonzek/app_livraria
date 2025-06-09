import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:app_livraria/models/review.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class ReviewCard extends StatefulWidget {
  final Review review;
  final void Function()? onTapBook;

  const ReviewCard({
    super.key,
    required this.review,
    this.onTapBook,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool liked = false;

  Future<String> _getBookTitle(String bookId) async {
    final service = GoogleBooksService();
    final book = await service.fetchBookById(bookId);
    return book?.title ?? 'Título não encontrado';
  }

  Future<void> _toggleLike(List<dynamic> currentLikedBy) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final reviewDoc = FirebaseFirestore.instance.collection('reviews').doc(widget.review.id);

    if (currentLikedBy.contains(userId)) {
      await reviewDoc.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await reviewDoc.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final reviewDocRef = FirebaseFirestore.instance.collection('reviews').doc(widget.review.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FutureBuilder<String>(
        future: _getBookTitle(widget.review.bookId),
        builder: (context, snapshot) {
          final titleReady = snapshot.hasData && snapshot.data != null;
          final bookTitle = snapshot.connectionState == ConnectionState.waiting
              ? 'Carregando...'
              : snapshot.data ?? 'Título não encontrado';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: titleReady ? widget.onTapBook : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryPink.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: titleReady ? AppColors.textDark : AppColors.textLight,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (titleReady)
                                Text(
                                  'Toque para ver detalhes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primaryPink,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (titleReady)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.primaryPink,
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < widget.review.rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.review.rating}/5',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.review.content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textDark,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(widget.review.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    StreamBuilder<DocumentSnapshot>(
                      stream: reviewDocRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final likedBy = data['likedBy'] ?? <dynamic>[];
                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        final liked = userId != null && likedBy.contains(userId);

                        return Container(
                          decoration: BoxDecoration(
                            color: liked 
                                ? Colors.red.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: liked ? Colors.red : AppColors.textLight,
                                  size: 20,
                                ),
                                onPressed: () => _toggleLike(likedBy),
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                              if (likedBy.isNotEmpty) ...[
                                Text(
                                  likedBy.length.toString(),
                                  style: TextStyle(
                                    color: liked ? Colors.red : AppColors.textLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}