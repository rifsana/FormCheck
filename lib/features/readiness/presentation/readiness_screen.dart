import 'package:flutter/material.dart';

class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Readiness Summary')),
      body: const Center(child: Text('Readiness Summary Screen')),
    );
  }
}
