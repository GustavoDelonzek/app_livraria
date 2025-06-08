import 'package:app_livraria/core/widgets/book_illustration.dart';
import 'package:app_livraria/core/widgets/login_form.dart';
import 'package:app_livraria/core/widgets/signup_form.dart';
import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<AuthViewModel>(
          builder: (context, authViewModel, child) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                  
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          child: BookIllustration(),
                        ),
                      ),
                    
                    
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Row(
                                children: [
                                  _buildTabButton(
                                    'Login',
                                    authViewModel.isLoginMode,
                                    () => {
                                      if (!authViewModel.isLoginMode)
                                        authViewModel.toggleAuthMode()
                                    },
                                  ),
                                  SizedBox(width: 40),
                                  _buildTabButton(
                                    'Register',
                                    !authViewModel.isLoginMode,
                                    () => {
                                      if (authViewModel.isLoginMode)
                                        authViewModel.toggleAuthMode()
                                    },
                                  ),
                                ],
                              ),
                            ),
                            
                            Expanded(
                              child: authViewModel.isLoginMode
                                  ? LoginForm()
                                  : SignupForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isActive ? Color.fromRGBO(143, 179, 195,1) : Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? Color.fromRGBO(247, 169, 182, 1) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}