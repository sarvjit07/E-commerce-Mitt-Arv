import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String apiBaseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error in API call: $e');
      rethrow;
    }
  }
}
