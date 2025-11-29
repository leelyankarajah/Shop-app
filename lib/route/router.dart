import 'package:flutter/material.dart';
import 'package:shop/screens/auth/views/forgot_password_screen.dart';
import 'package:shop/screens/auth/views/home_screen.dart';
import 'package:shop/screens/auth/views/login_screen.dart';
import 'package:shop/screens/auth/views/signup_screen.dart';
import 'package:shop/screens/auth/views/cart_screen.dart';
import 'package:shop/screens/auth/views/offers_screen.dart';
import 'package:shop/route/route_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case logInScreenRoute:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case homeScreenRoute:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case signUpScreenRoute:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case forgotPasswordScreenRoute:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    case cartScreenRoute:
      return MaterialPageRoute(builder: (_) => const CartScreen());
    case offersScreenRoute:
      return MaterialPageRoute(builder: (_) => const OffersScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('No route defined for this page')),
        ),
      );
  }
}
