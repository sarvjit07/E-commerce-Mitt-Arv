import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product> purchasedItems;

  const CheckoutScreen({Key? key, required this.purchasedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    void completePurchase() {
      // Show confirmation popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Purchase Successful!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Thank you for your purchase!'),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the cart items
      cartProvider.clearCart();

      // Redirect to the home page after 5 seconds
      Timer(const Duration(seconds: 5), () {
        Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the home page
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: purchasedItems.length,
              itemBuilder: (context, index) {
                final product = purchasedItems[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.title),
                  subtitle: Text('Price: \$${product.price}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: completePurchase,
              child: const Text('Complete Purchase'),
            ),
          ),
        ],
      ),
    );
  }
}
