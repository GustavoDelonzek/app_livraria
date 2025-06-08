import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class LoginForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Consumer<AuthViewModel>(

      builder: (context, authViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Email',
              controller: authViewModel.emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Password',
              controller: authViewModel.passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline,
            ),

            const SizedBox(height: 30),

            if (authViewModel.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  authViewModel.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),

            CustomButton(
              text: 'Login',
              onPressed: authViewModel.isLoading
                  ? null
                  : () async {
                      bool success = await authViewModel.login(context);

                      if (success) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
              isLoading: authViewModel.isLoading,
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: authViewModel.isLoading
                    ? null
                    : () => authViewModel.forgotPassword(),
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
