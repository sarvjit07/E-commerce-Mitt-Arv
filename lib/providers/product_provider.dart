import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = []; // All products
  List<Product> _filteredProducts = []; // Filtered or searched products
  List<String> _categories = []; // Available categories from API
  bool _isLoading = false;
  bool _isFetchingMore = false;
  int _page = 1;
  final int _limit = 10;

  List<Product> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;

  // Fetch products from API with pagination
  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      _isLoading = true;
      _page = 1; // Reset page on fresh load
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
        _page++;
      }
    } catch (e) {
      print('Error fetching products: $e');
    }

    _isLoading = false;
    _isFetchingMore = false;
    notifyListeners();
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      final url = Uri.parse('https://fakestoreapi.com/products/categories');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        _categories = List<String>.from(json.decode(response.body));
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    notifyListeners();
  }

  // Search products by title
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Apply filters and sorting
  void applyFilters({
    String? category,
    double minPrice = 0.0,
    double maxPrice = double.infinity,
    double minRating = 0.0,
    String sortOption = 'Price',
  }) {
    _filteredProducts = _products.where((product) {
      final matchesCategory = category == null || product.category == category;
      final matchesPrice = product.price >= minPrice && product.price <= maxPrice;
      final matchesRating = product.rating >= minRating;
      return matchesCategory && matchesPrice && matchesRating;
    }).toList();

    // Sort products
    switch (sortOption) {
      case 'Price':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Popularity':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    notifyListeners();
  }
}
