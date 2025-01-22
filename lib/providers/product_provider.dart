import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  final int _limit = 10;

  List<Product> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;

  // Fetch products from API
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      notifyListeners();
    } else {
      _isFetchingMore = true;
      notifyListeners();
    }

    try {
      final url = Uri.parse('https://fakestoreapi.com/products?_page=$_page&_limit=$_limit');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (isLoadMore) {
          // Append the new products to the existing list
          _products.addAll(data.map((item) => Product.fromJson(item)).toList());
        } else {
          // Set the new products list
          _products = data.map((item) => Product.fromJson(item)).toList();
        }
        _page++;
      }
    } catch (e) {
      // Handle errors
      print('Error fetching products: $e');
    }

    // Set loading states
    if (isLoadMore) {
      _isFetchingMore = false;
    } else {
      _isLoading = false;
    }

    notifyListeners();
  }

  // Search products by name
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products
          .where((product) => product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
