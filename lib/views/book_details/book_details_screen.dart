import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/views/cart/cart_view_model.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capa do livro
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.book.coverUrl,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 260,
                    width: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Título e autor
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Autor: ${widget.book.author}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Preço: R\$ ${widget.book.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 16),

            // Estrelas de avaliação (estático por enquanto)
            Row(
              children: List.generate(
                5,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição (com expansão opcional)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: showFullDescription
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                description.length > 200
                    ? '${description.substring(0, 200)}...'
                    : description,
                style: const TextStyle(fontSize: 16),
              ),
              secondChild: Text(description, style: const TextStyle(fontSize: 16)),
            ),
            if (description.length > 200)
              TextButton(
                onPressed: () => setState(() => showFullDescription = !showFullDescription),
                child: Text(showFullDescription ? 'Mostrar menos' : 'Ler mais'),
              ),

            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: alreadyInCart
                  ? ElevatedButton.icon(
                      key: const ValueKey('in_cart'),
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: const Text('Já no carrinho'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    )
                  : ElevatedButton.icon(
                      key: const ValueKey('add_to_cart'),
                      onPressed: () {
                        cartViewModel.addToCart(widget.book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Livro adicionado ao carrinho!')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Adicionar ao Carrinho'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
            ),

            const SizedBox(height: 32),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
