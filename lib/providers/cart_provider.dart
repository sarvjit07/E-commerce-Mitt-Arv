import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  }

  void addToCart(Product product) {
    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      // Item already in cart, increase quantity
      _cartItems[existingItemIndex].quantity++;
    } else {
      // Item not in cart, add new
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }
  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    } else if (index >= 0 && _cartItems[index].quantity == 1) {
      removeFromCart(productId);
    }
  }
}
