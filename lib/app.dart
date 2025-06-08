import 'package:app_livraria/core/widgets/auth_guard.dart';
import 'package:app_livraria/providers/author_provider.dart';
import 'package:app_livraria/providers/book_provider.dart';
import 'package:app_livraria/providers/search_provider.dart';
import 'package:app_livraria/views/auth/auth_screen.dart';
import 'package:app_livraria/views/auth/auth_view_model.dart';
import 'package:app_livraria/views/cart/cart_screen.dart';
import 'package:app_livraria/views/cart/cart_view_model.dart';
import 'package:app_livraria/views/profile/profile_screen.dart';
import 'package:app_livraria/views/profile/profile_view_model.dart';
import 'package:app_livraria/views/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'views/auth/login_view_model.dart';
import 'views/auth/register_view_model.dart';
import 'views/home/home_screen.dart';
import 'views/home/home_view_model.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => AuthorProvider()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Livraria App',
        initialRoute: '/auth',
        routes: {
          '/auth': (_) => const AuthScreen(),
          '/home': (_) => const AuthGuard(child: HomeScreen()),
          '/search': (_) => const AuthGuard(child: SearchScreen()),
          '/cart': (_) => const AuthGuard(child: CartScreen()),
          '/profile': (_) => AuthGuard(child: ProfileScreen()),
        },
      ),
    );
  }
}
