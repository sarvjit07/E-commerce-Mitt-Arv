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
  double _minPrice = 0.0;
  double _maxPrice = 1000.0; // Update max price to 1000
  double _minRating = 0.0;
  double _maxRating = 5.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts();
      productProvider.fetchCategories(); // Fetch available categories
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      Provider.of<ProductProvider>(context, listen: false).searchProducts(query);
    });
  }

  void _onScroll() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !productProvider.isFetchingMore) {
      productProvider.fetchProducts(isLoadMore: true);
    }
  }

  void _applyFilters() {
    Provider.of<ProductProvider>(context, listen: false).applyFilters(
      category: _selectedCategory,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating,
      maxRating: _maxRating,
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
                // Sort Dropdown
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
                // Category Dropdown
                DropdownButton<String?>(
                  value: _selectedCategory,
                  items: (['All'] + productProvider.categories)
                      .map((category) => DropdownMenuItem(
                            value: category == 'All' ? null : category,
                            child: Text(category),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RangeSlider(
              values: RangeValues(
                _minPrice.clamp(0.0, 1000.0), // Set the max value to 1000
                _maxPrice.clamp(0.0, 1000.0), // Set the max value to 1000
              ),
              min: 0.0,
              max: 1000.0, // Set max value for price range to 1000
              divisions: 10,
              labels: RangeLabels(
                _minPrice.toStringAsFixed(2),
                _maxPrice.toStringAsFixed(2),
              ),
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start.clamp(0.0, 1000.0);
                  _maxPrice = values.end.clamp(0.0, 1000.0);
                });
                _applyFilters();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RangeSlider(
              values: RangeValues(
                _minRating.clamp(0.0, 5.0),
                _maxRating.clamp(0.0, 5.0),
              ),
              min: 0.0,
              max: 5.0,
              divisions: 5,
              labels: RangeLabels(
                _minRating.toStringAsFixed(1),
                _maxRating.toStringAsFixed(1),
              ),
              onChanged: (values) {
                setState(() {
                  _minRating = values.start.clamp(0.0, 5.0);
                  _maxRating = values.end.clamp(0.0, 5.0);
                });
                _applyFilters();
              },
            ),
          ),
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productProvider.products.isEmpty
                    ? const Center(child: Text('No products found for the selected filters.'))
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
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
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
