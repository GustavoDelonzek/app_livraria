import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value;
    _clearError();
  }

  void setPassword(String value) {
    _password = value;
    _clearError();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  bool _validate() {
    if (_email.isEmpty || _password.isEmpty) {
      _setError('Por favor, preencha email e senha.');
      return false;
    }
    if (!_email.contains('@')) {
      _setError('Por favor, insira um email válido.');
      return false;
    }
    return true;
  }

  Future<void> login(BuildContext context) async {
    if (!_validate()) return;

    _setLoading(true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Erro ao fazer login.');
    } catch (e) {
      _setError('Erro inesperado. Tente novamente.');
    } finally {
      _setLoading(false);
    }
  }
}
