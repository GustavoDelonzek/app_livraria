import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/models/book.dart';
import 'package:app_livraria/core/widgets/footer.dart';
import 'package:app_livraria/views/cart/cart_view_model.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = context.watch<CartViewModel>();
    final alreadyInCart = cartViewModel.isInCart(book.key);

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart'); 
            },
          ),
        ],
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  book.coverUrl,
                  height: 260, 
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.book, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                book.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Autor: ${book.author}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Preço: R\$ ${book.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 16),
              Text(
                book.description ?? 'Sem descrição disponível.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: alreadyInCart
                    ? null
                    : () {
                        cartViewModel.addToCart(book);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Livro adicionado ao carrinho!')),
                        );
                      },
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(alreadyInCart ? 'Já no carrinho' : 'Adicionar ao Carrinho'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 32), 
              const AppFooter(), 
            ],
          ),
        ),
      ),
    );
  }
}
