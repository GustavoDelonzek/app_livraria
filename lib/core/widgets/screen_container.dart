import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final Widget child;
  
  const ScreenContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: child,
    );
  }
}
