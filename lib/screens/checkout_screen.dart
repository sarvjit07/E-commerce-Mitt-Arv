import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Order placed successfully!', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Icon(Icons.check_circle, size: 50, color: Colors.green),
          ],
        ),
      ),
    );
  }
}