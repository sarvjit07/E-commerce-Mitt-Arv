import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSortOption = 'Price';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (!provider.isFetchingMore) {
        provider.fetchProducts(isLoadMore: true);
      }
    }
  }

  void _applyFilters() {
    Provider.of<ProductProvider>(context, listen: false).applyFilters(
      category: _selectedCategory,
      sortOption: _selectedSortOption,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartProvider.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartProvider.cartItems.length.toString(),
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedSortOption,
                  items: ['Price', 'Popularity', 'Rating']
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSortOption = value!;
                    });
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<String?>(
                  value: _selectedCategory,
                  items: ['Electronics', 'Fashion', 'Home', 'All']
                      .map((option) => DropdownMenuItem(
                            value: option == 'All' ? null : option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
Expanded(
  child: productProvider.isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
          controller: _scrollController,
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            final product = productProvider.products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: ProductCard(product: product),
            );
          },
        ),
),
        ],
      ),
    );
  }
}
