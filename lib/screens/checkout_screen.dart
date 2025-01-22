import 'package:flutter/material.dart';
import '../models/product.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product> purchasedItems;

  const CheckoutScreen({Key? key, required this.purchasedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Order:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  final item = purchasedItems[index];
                  return ListTile(
                    leading: Image.network(item.image, width: 50, height: 50),
                    title: Text(item.title),
                    subtitle: Text('\$${item.price}'),
                  );
                },
              ),
            ),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 50, color: Colors.green),
                  SizedBox(height: 10),
                  Text('Order placed successfully!', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
