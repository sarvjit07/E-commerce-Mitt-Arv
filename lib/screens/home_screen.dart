import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

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
  double _maxPrice = 1000.0;
  double _minRating = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts();
      productProvider.fetchCategories();
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      Provider.of<ProductProvider>(context, listen: false)
          .searchProducts(query);
    });
  }

  void _onScroll() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout(); // Call logout method
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
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
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
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
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Drawer(
              elevation: 1,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for products...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      Provider.of<ProductProvider>(context, listen: false)
                          .searchProducts(query);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sort By:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  const SizedBox(height: 16),
                  const Text(
                    'Categories:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  const SizedBox(height: 16),
                  const Text(
                    'Price Range:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: RangeValues(
                      _minPrice.clamp(0.0, 900.0),
                      _maxPrice.clamp(1.0, 1000.0),
                    ),
                    min: 0.0,
                    max: 1000.0,
                    divisions: 10,
                    labels: RangeLabels(
                      _minPrice.toStringAsFixed(2),
                      _maxPrice.toStringAsFixed(2),
                    ),
                    onChanged: (values) {
                      setState(() {
                        if (values.start < values.end && values.start < 1000) {
                          _minPrice = values.start.clamp(0.0, 900.0);
                          _maxPrice = values.end.clamp(1.0, 1000.0);
                        }
                      });
                      _applyFilters();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Customer Ratings:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...[4.0, 3.0, 2.0, 1.0].map((rating) {
                    return RadioListTile<double>(
                      title: Text('${rating.toInt()}★ & above'),
                      value: rating,
                      groupValue: _minRating,
                      onChanged: (value) {
                        setState(() {
                          _minRating = value!;
                        });
                        _applyFilters();
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productProvider.products.isEmpty
                    ? const Center(
                        child: Text('No products found for the selected filters.'),
                      )
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
