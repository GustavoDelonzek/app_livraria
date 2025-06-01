import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/book.dart';
import 'cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: vm.items.isEmpty
          ? const Center(child: Text('Seu carrinho está vazio'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.items.length,
                    itemBuilder: (_, index) {
                      final book = vm.items[index];
                      return ListTile(
                        leading: Image.network(
                          book.coverUrl,
                          width: 40,
                          errorBuilder: (_, __, ___) => const Icon(Icons.book),
                        ),
                        title: Text(book.title),
                        subtitle: Text('R\$ ${book.price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => vm.removeFromCart(book),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total: R\$ ${vm.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Aqui pode ir lógica de finalizar compra
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compra finalizada!')),
                          );
                          vm.clearCart();
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
