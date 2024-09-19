import 'package:flutter/material.dart';

class AuthLoadingPage extends StatefulWidget {
  const AuthLoadingPage({super.key});

  @override
  State<AuthLoadingPage> createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends State<AuthLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text('AUTH LOADING'),
        ),
      ),
    );
  }
}
