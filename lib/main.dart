import 'package:flutter/material.dart';

void main() {
  runApp(const InBlackOrdersApp());
}

class InBlackOrdersApp extends StatelessWidget {
  const InBlackOrdersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'InBlack Orders',
      home: Scaffold(body: SizedBox.shrink()),
    );
  }
}
