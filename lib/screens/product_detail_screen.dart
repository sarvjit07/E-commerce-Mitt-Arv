import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display product image
            Image.network(product.image),
            const SizedBox(height: 16.0),
            // Display product title and price
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),
            // Display product description
            Text(
              product.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // Display product ratings
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(product.rating.toString()),
              ],
            ),
            const SizedBox(height: 16.0),
            // Display reviews section (dummy reviews for now)
            const Text(
              'Reviews:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Column(
              children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text('This is review #${i + 1}'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Add to cart button
            ElevatedButton(
              onPressed: () {
                // Add to cart logic
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}