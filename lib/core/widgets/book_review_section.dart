import 'package:app_livraria/models/review.dart';
import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:app_livraria/views/review/review_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookReviewSection extends StatelessWidget {
  final String bookId;

  const BookReviewSection({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (context, viewModel, _) {
        return FutureBuilder(
          future: viewModel.fetchReviews(bookId),
          builder: (context, snapshot) {
            final reviews = viewModel.reviews;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text('Avaliações',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => ReviewForm(bookId: bookId),
                    );
                  },
                  child: const Text('Escrever uma Avaliação'),
                ),
                const SizedBox(height: 16),
                if (reviews.isEmpty)
                  const Text('Nenhuma avaliação ainda.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(review.userId),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(review.content),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class ReviewForm extends StatefulWidget {
  final String bookId;

  const ReviewForm({super.key, required this.bookId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _controller = TextEditingController();
  int _rating = 5;

  void _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _controller.text.trim().isEmpty) return;

    final review = Review(
      id: '',
      bookId: widget.bookId,
      userId: user.uid,
      content: _controller.text.trim(),
      rating: _rating,
      createdAt: DateTime.now(),
      likeCount: 0,
      likedBy: [],
    );

    await context.read<ReviewViewModel>().addReview(review);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Avalie este livro', style: TextStyle(fontSize: 18)),
          Slider(
            value: _rating.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_rating estrelas',
            onChanged: (value) {
              setState(() => _rating = value.toInt());
            },
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Comentário'),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submitReview,
            child: const Text('Enviar'),
          )
        ],
      ),
    );
  }
}
