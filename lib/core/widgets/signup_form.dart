import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class SignupForm extends StatelessWidget {

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
              placeholder: 'seuemail@exemplo.com',
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Password',
              controller: authViewModel.passwordController,
              isPassword: true,
              prefixIcon: Icons.lock_outline,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Confirm Password',
              controller: authViewModel.confirmPasswordController,
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
              text: 'Create Account',
              onPressed: authViewModel.isLoading
                  ? null
                  : () async {
                      bool success = await authViewModel.signup();
                     
                      if (success) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
              isLoading: authViewModel.isLoading,
            ),

            const SizedBox(height: 20),

            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  children: const [
                    TextSpan(text: 'By creating an account you are accepting\nour '),
                    TextSpan(
                      text: 'Terms of Services',
                      style: TextStyle(
                        color: Color.fromRGBO(247, 169, 182, 1),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
