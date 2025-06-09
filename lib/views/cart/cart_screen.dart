import 'package:app_livraria/core/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:app_livraria/models/cart_item.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'cart_view_model.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFF7A9B6);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color darkPink = Color(0xFFE57373);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF424242);
  static const Color textLight = Color(0xFF757575);
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();

    if (cartVM.isLoading) {
      return Scaffold(
        appBar: AppHeader(title: 'Carrinho', showBack: true),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                AppColors.lightPink.withOpacity(0.1),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryPink,
            ),
          ),
        ),
      );
    }

    if (cartVM.items.isEmpty) {
      return Scaffold(
        appBar: AppHeader(title: 'Carrinho', showBack: true),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                AppColors.lightPink.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.lightPink.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.primaryPink,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Seu carrinho está vazio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione alguns livros para começar suas compras',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('Continuar Comprando'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppHeader(title: 'Carrinho', showBack: true),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.lightPink.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.primaryPink,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cartVM.items.length} ${cartVM.items.length == 1 ? 'item' : 'itens'} no carrinho',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Total: R\$ ${cartVM.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cartVM.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cartVM.items[index];
                  final book = item.book;

                  return Container(
                    padding: const EdgeInsets.all(16),
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
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPink.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.coverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightPink,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.book,
                                  size: 30,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'R\$ ${book.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.lightPink.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 20,
                                    icon: Icon(
                                      Icons.remove_circle_outline,
                                      color: AppColors.primaryPink,
                                    ),
                                    onPressed: () {
                                      final newQty = item.quantity - 1;
                                      cartVM.updateQuantity(book.key, newQty);
                                    },
                                  ),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 20,
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: AppColors.primaryPink,
                                    ),
                                    onPressed: () {
                                      final newQty = item.quantity + 1;
                                      cartVM.updateQuantity(book.key, newQty);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                              ),
                              onPressed: () {
                                cartVM.removeFromCart(book.key);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total do Pedido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'R\$ ${cartVM.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showPaymentDialog(context, cartVM),
                        icon: const Icon(Icons.payment),
                        label: const Text('Finalizar Compra'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, CartViewModel cartVM) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.qr_code,
                color: AppColors.primaryPink,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pagamento via QR Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Escaneie o QR Code abaixo para simular o pagamento',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryPink.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: QrImageView(
                    data: 'https://run.mocky.io/v3/760b4616-5f6e-4698-bfb6-774e84116bd7',
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryPink,
                      strokeWidth: 3,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Processando pagamento...',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    _processPayment(context, cartVM);
  }

  Future<void> _processPayment(BuildContext context, CartViewModel cartVM) async {
    await Future.delayed(const Duration(seconds: 5));

    try {
      final response = await http.get(
        Uri.parse('https://run.mocky.io/v3/760b4616-5f6e-4698-bfb6-774e84116bd7'),
      );

      if (response.statusCode == 200) {
        await cartVM.submitOrder();
        await cartVM.clearCart();
        Navigator.pop(context);
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pedido realizado com sucesso!'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pagamento não confirmado.'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao processar pagamento.'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}