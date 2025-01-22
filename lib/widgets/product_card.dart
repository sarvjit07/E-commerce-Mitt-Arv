import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.network(
          product.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${product.price}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Rating: ${product.rating.toString()}'), // Directly use the rating
          ],
        ),
      ),
    );
  }
}
