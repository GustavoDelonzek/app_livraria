import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_livraria/core/services/google_books_service.dart';
import 'package:app_livraria/models/review.dart';

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
      // Já curtiu, remove
      await reviewDoc.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Não curtiu ainda, adiciona
      await reviewDoc.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewDocRef = FirebaseFirestore.instance.collection('reviews').doc(widget.review.id);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: FutureBuilder<String>(
        future: _getBookTitle(widget.review.bookId),
        builder: (context, snapshot) {
          final titleReady = snapshot.hasData && snapshot.data != null;
          final bookTitle = snapshot.connectionState == ConnectionState.waiting
              ? 'Carregando...'
              : snapshot.data ?? 'Título não encontrado';

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: titleReady ? widget.onTapBook : null,
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded,
                          color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          bookTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: titleReady ? Colors.deepPurple : Colors.grey,
                            decoration: titleReady
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.review.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.review.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Publicado em ${widget.review.createdAt.day}/${widget.review.createdAt.month}/${widget.review.createdAt.year}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
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

                        return Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                color: liked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(likedBy),
                            ),
                            Text(
                              likedBy.length.toString(),
                              style: TextStyle(
                                color: liked ? Colors.red : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
