import 'package:flutter/material.dart';
import 'login_text_fields.dart';

class LoginViewMobile extends StatelessWidget {
  const LoginViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - Mobile')),
      body: Column(children: [LoginTextFields()]),
    );
  }
}
