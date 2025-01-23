import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  final int _limit = 10;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;

  // Fetch products with pagination
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _page = 1; // Reset page if not loading more
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
          _products.addAll(data.map((item) => Product.fromJson(item)).toList());
        } else {
          _products = data.map((item) => Product.fromJson(item)).toList();
        }

        _page++; // Increment page for next load
      }
    } catch (e) {
      print('Error fetching products: $e');
    }

    _isLoading = false;
    _isFetchingMore = false;
    notifyListeners();
  }
}
