import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Initially fetch products
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });

    // Search functionality
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

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search),
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
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: productProvider.products.length + 1,
                    itemBuilder: (context, index) {
                      if (index == productProvider.products.length) {
                        return productProvider.isFetchingMore
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      final product = productProvider.products[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to Product Detail Page
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
