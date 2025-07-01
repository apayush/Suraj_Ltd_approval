import 'package:flutter/material.dart';

import 'login_text_fields.dart';

class LoginViewTablet extends StatelessWidget {
  const LoginViewTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - Tablet')),
      body: Row(
        children: [
          Expanded(child: FlutterLogo()),
          const SizedBox(width: 16.0),
          Expanded(child: Column(children: [LoginTextFields()])),
        ],
      ),
    );
  }
}
