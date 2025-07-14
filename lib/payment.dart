import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final courseName = args?['courseName'] ?? 'Payment';
    final price = args?['price'] ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Text(
          'Payment for $courseName\nPrice: $price',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
