import 'package:app_livraria/models/user.dart';
import 'package:app_livraria/providers/book_provider.dart';
import 'package:app_livraria/views/profile/profile_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoginMode = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoginMode => _isLoginMode;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   UserLocal? localCurrentUser;

  void toggleAuthMode() {
    _isLoginMode = !_isLoginMode;
    _clearError();
    clearControllers();
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    _clearError();
    if (!_validateLoginForm()) return false;

    _setLoading(true);

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      final user = _auth.currentUser;

      if (user != null) {
        await Provider.of<ProfileViewModel>(context, listen: false)
            .fetchOrCreateUser(user.uid, user.email!);

        _clearError();
        return true;
      } else {
        _setError('Erro ao autenticar. Tente novamente.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Erro ao fazer login.');
      return false;
    } catch (e) {
      print('$e');
      _setError('Erro inesperado. Tente novamente. $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signup(BuildContext context) async {
    _clearError();
    if (!_validateSignupForm()) return false;

    _setLoading(true);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      final user = _auth.currentUser;
      if (user != null) {
        await Provider.of<ProfileViewModel>(context, listen: false)
        .fetchOrCreateUser(user.uid, user.email!);
        _clearError();
        return true;
      } else {
        _setError('Erro ao cadastrar. Tente novamente.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Erro ao cadastrar usuário.');
      return false;
    } catch (e) {
      _setError('Erro inesperado. Tente novamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  bool _validateLoginForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _setError('Por favor, preencha todos os campos.');
      return false;
    }
    if (!_isValidEmail(emailController.text)) {
      _setError('Por favor, insira um email válido.');
      return false;
    }
    return true;
  }

  bool _validateSignupForm() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _setError('Por favor, preencha todos os campos.');
      return false;
    }
    if (!_isValidEmail(emailController.text)) {
      _setError('Por favor, insira um email válido.');
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _setError('As senhas não coincidem.');
      return false;
    }
    if (passwordController.text.length < 6) {
      _setError('A senha deve ter pelo menos 6 caracteres.');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> forgotPassword() async {
    if (!_isValidEmail(emailController.text)) {
      _setError('Por favor, insira um email válido para recuperação.');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      _setError('Email de recuperação enviado com sucesso.');
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Erro ao enviar email de recuperação.');
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    BookProvider().setSelectedTabIndex(0);
    localCurrentUser = null;
    notifyListeners();
  }
}
