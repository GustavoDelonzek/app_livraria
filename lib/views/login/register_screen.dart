import 'package:flutter/material.dart';
import 'register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: model.setEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: model.setPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => model.register(context),
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
