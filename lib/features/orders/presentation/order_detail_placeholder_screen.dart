import 'package:flutter/material.dart';

class OrderDetailPlaceholderScreen extends StatelessWidget {
  const OrderDetailPlaceholderScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(orderId)),
      body: const Center(child: Text('หน้ารายละเอียด (Day 4)')),
    );
  }
}
