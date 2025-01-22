import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};

  Map<int, CartItem> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
    } else {
      _cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems.remove(product.id);
      notifyListeners();
    }
  }

  void increaseQuantity(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    if (_cartItems.containsKey(product.id) && _cartItems[product.id]!.quantity > 1) {
      _cartItems[product.id]!.quantity--;
    } else {
      _cartItems.remove(product.id);
    }
    notifyListeners();
  }
  
void clearCart() {
  _cartItems.clear();
  notifyListeners();
}
  double get totalPrice {
    return _cartItems.values.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
