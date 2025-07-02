import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  static const String path = '/landing';
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Landing Page'),
      ),
    );
  }
}