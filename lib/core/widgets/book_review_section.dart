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
  final Color primaryColor = const Color.fromRGBO(143, 179, 195, 1);
  final Color accentColor = const Color.fromRGBO(247, 169, 182, 1);

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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.rate_review),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Você precisa estar logado para avaliar.')),
                    );
                    return;
                  }

                  final hasBought = await context
                      .read<ReviewViewModel>()
                      .hasUserBoughtBook(user.uid, widget.bookId);

                  if (!hasBought) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Você só pode avaliar livros que comprou.')),
                    );
                    return;
                  }

                 showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ReviewForm(bookId: widget.bookId),
                    ),
                  ),
                );

                },
                label: const Text('Escrever uma Avaliação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              review.userName[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < review.rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  review.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
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

  final Color primaryColor = const Color.fromRGBO(143, 179, 195, 1);
  final Color accentColor = const Color.fromRGBO(247, 169, 182, 1);

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
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Avalie este livro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: accentColor,
                inactiveTrackColor: primaryColor.withOpacity(0.3),
                thumbColor: accentColor,
                overlayColor: accentColor.withOpacity(0.2),
              ),
              child: Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_rating estrelas',
                onChanged: (value) {
                  setState(() => _rating = value.toInt());
                },
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              enabled: !_loading,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Comentário',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Enviar Avaliação',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
