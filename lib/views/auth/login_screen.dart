import 'package:flutter/material.dart';
import 'login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: model.setEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              onChanged: model.setPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            if (model.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                model.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            model.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => model.login(context),
                    child: const Text('Entrar'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Criar conta'),
            )
          ],
        ),
      ),
    );
  }
}
