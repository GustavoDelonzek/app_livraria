import 'package:app_livraria/core/widgets/book_review_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/views/cart/cart_view_model.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final cartViewModel = context.watch<CartViewModel>();
    final alreadyInCart = cartViewModel.isInCart(widget.book.key);
    final description = widget.book.description ?? 'Sem descrição disponível.';

    return Scaffold(
      appBar: AppHeader(
        title: widget.book.title,
        showCart: true,
        showBack: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.lightPink.withOpacity(0.2)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryPink.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            widget.book.coverUrl,
                            height: 280,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 280,
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColors.lightPink,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(Icons.book, size: 100, color: AppColors.primaryPink),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.book.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Icon(Icons.person, size: 18, color: AppColors.primaryPink),
                              const SizedBox(width: 6),
                              Text(
                                widget.book.author,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'R\$ ${widget.book.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 300),
                                  crossFadeState: showFullDescription
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  firstChild: Text(
                                    description.length > 350
                                        ? '${description.substring(0, 350)}...'
                                        : description,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      height: 1.6,
                                      color: AppColors.textDark.withOpacity(0.9),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  secondChild: Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      height: 1.6,
                                      color: AppColors.textDark.withOpacity(0.9),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                                if (description.length > 350)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        minimumSize: const Size(50, 30),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => setState(() {
                                        showFullDescription = !showFullDescription;
                                      }),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            showFullDescription ? 'Mostrar menos' : 'Ler mais',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primaryPink,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            showFullDescription
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            size: 16,
                                            color: AppColors.primaryPink,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: alreadyInCart
                          ? Container(
                              key: const ValueKey('in_cart'),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.check),
                                label: const Text('Já no carrinho'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              key: const ValueKey('add_to_cart'),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPink.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  cartViewModel.addToCart(widget.book);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Livro adicionado ao carrinho!'),
                                      backgroundColor: AppColors.primaryGreen,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_shopping_cart),
                                label: const Text('Adicionar ao Carrinho'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPink,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primaryPink.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Avaliações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BookReviewSection(bookId: widget.book.key),
                  ],
                ),
              ),
            ),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}