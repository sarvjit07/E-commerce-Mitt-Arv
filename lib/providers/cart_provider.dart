import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice =>
      _cartItems.fold(0, (total, item) => total + item.price);

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
