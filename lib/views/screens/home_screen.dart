import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/servis/product_httpservis.dart';
import 'package:topshiriq/viewmodel/carts_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductServices productServices = ProductServices();
  final CartsViewModel cartsViewModel = CartsViewModel();
  List<Product> products = [];
  List<Product> displayedProducts = [];
  List<Product> cart = [];
  bool isGridView = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    getUserCart();
  }

  void getUserCart() async {
    final userCart = await cartsViewModel.getUserCart();
    if (userCart != null) {
      setState(() {
        cart = userCart.products;
      });
    }
  }

  void fetchProducts() async {
    products = await productServices.fetchProducts();
    setState(() {
      displayedProducts = products;
    });
  }

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void _searchProducts(String query) {
    setState(() {
      searchQuery = query;
      displayedProducts = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleFavorite(String id) async {
    final index = products.indexWhere((product) => product.id == id);
    if (index != -1) {
      setState(() {
        products[index].isFavorite = !products[index].isFavorite;
      });
      await productServices.updateProduct(products[index].id, products[index]);
      fetchProducts();
    }
  }

  void _addToCart(Product product) async {
    int index = cart.indexWhere((pro) {
      return pro.id == product.id;
    });
    if (index == -1) {
      setState(() {
        cart.add(product);
      });
      await cartsViewModel.addToCart(cart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProducts,
              decoration: InputDecoration(
                labelText: tr('serch'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr('cotegory'),
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: _toggleView,
                ),
              ],
            ),
          ),
          Expanded(
            child: isGridView ? _buildGridView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: displayedProducts.length,
      itemBuilder: (context, index) {
        final product = displayedProducts[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: displayedProducts.length,
      itemBuilder: (context, index) {
        final product = displayedProducts[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 189,
            width: double.infinity,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${tr('price')}: \$${product.price.toString()}'),
                Text('${tr('amount')}: ${product.amount.toString()}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(product.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () =>  _addToCart(product) ,
                      
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
