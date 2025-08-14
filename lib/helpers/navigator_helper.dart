import 'package:flutter/material.dart';

void goToLogin(BuildContext context, {bool replace = false}) {
  replace
      ? Navigator.pushReplacementNamed(context, '/login')
      : Navigator.pushNamed(context, '/login');
}

void goToRegister(BuildContext context, {bool replace = false}) {
  replace
      ? Navigator.pushReplacementNamed(context, '/register')
      : Navigator.pushNamed(context, '/register');
}

void goToForgotPassword(BuildContext context) {
  Navigator.pushNamed(context, '/forgot-password');
}

void goToHome(BuildContext context, {bool replace = false}) {
  replace
      ? Navigator.pushReplacementNamed(context, '/home')
      : Navigator.pushNamed(context, '/home');
}

void goToWelcome(BuildContext context, {bool replace = false}) {
  replace
      ? Navigator.pushReplacementNamed(context, '/welcome')
      : Navigator.pushNamed(context, '/welcome');
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}
