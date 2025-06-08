import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;
  const AuthGuard({required this.child, super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null && !_navigated) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/auth');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.child;
  }
}
