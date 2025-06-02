import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_livraria/models/cart_item.dart';
import 'cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>(); // Reutiliza a instância global

    if (cartVM.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (cartVM.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carrinho')),
        body: const Center(child: Text('Seu carrinho está vazio.')),
      );
    }

    return Scaffold(
      appBar:AppHeader(title: 'Carrinho', showBack: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartVM.items.length,
              itemBuilder: (context, index) {
                final item = cartVM.items[index];
                final book = item.book;

                return ListTile(
                  leading: Image.network(
                    book.coverUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
                  ),
                  title: Text(book.title, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Autor: ${book.author}', overflow: TextOverflow.ellipsis),
                  trailing: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            final newQty = item.quantity - 1;
                            cartVM.updateQuantity(book.key!, newQty);
                          },
                        ),
                        Flexible(
                          child: Text('${item.quantity}',
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center),
                        ),
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            final newQty = item.quantity + 1;
                            cartVM.updateQuantity(book.key!, newQty);
                          },
                        ),
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartVM.removeFromCart(book.key!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R\$ ${cartVM.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Função de compra ainda não implementada.')),
                    );
                  },
                  child: const Text('Finalizar Compra'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
