import 'package:app_livraria/models/review.dart';
import 'package:app_livraria/views/review/review_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookReviewSection extends StatefulWidget {
  final String bookId;

  const BookReviewSection({super.key, required this.bookId});

  @override
  State<BookReviewSection> createState() => _BookReviewSectionState();
}

class _BookReviewSectionState extends State<BookReviewSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewViewModel>().fetchReviews(widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(child: Text(viewModel.error!));
        }

        final reviews = viewModel.reviews;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Avaliações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ReviewForm(bookId: widget.bookId),
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
                      title: Text(review.userName),
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
  bool _loading = false;

  void _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para avaliar.')),
      );
      return;
    }

    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentário não pode ser vazio.')),
      );
      return;
    }

    setState(() => _loading = true);

    final userName = user.email!.split('@')[0];

    final review = Review(
      id: '',
      bookId: widget.bookId,
      userId: user.uid,
      userName: userName,
      content: _controller.text.trim(),
      rating: _rating,
      createdAt: DateTime.now(),
      likeCount: 0,
      likedBy: [],
    );

    await context.read<ReviewViewModel>().addReview(review);

    setState(() => _loading = false);

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
            enabled: !_loading,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loading ? null : _submitReview,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text('Enviar'),
          )
        ],
      ),
    );
  }
}
