import 'package:flutter/material.dart';

class BookIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Image.asset(
          'assets/images/login_image.png', 
         
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
