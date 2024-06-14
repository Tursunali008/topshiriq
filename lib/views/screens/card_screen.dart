import 'package:flutter/material.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/viewmodel/carts_view_model.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cart;

  CartScreen({
    super.key,
    required this.cart,
  });

  final cartViewModel = CartsViewModel();

  double _calculateTotalPrice(List<Product> products) {
    return products.fold(
        0, (total, product) => total + product.price * product.amount);
  }

  void _buyProducts(BuildContext context) async {
    await cartViewModel.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: FutureBuilder(
        future: cartViewModel.getUserCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final cart = snapshot.data;
          if (cart == null || cart.products.isEmpty) {
            return const Center(
              child: Text("Savatchamiz bum bush"),
            );
          }

          final totalPrice = _calculateTotalPrice(cart.products);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) {
                    final product = cart.products[index];
                    return ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.title),
                      subtitle: Text('Price: \$${product.price.toString()}'),
                      trailing: Text('Amount: ${product.amount.toString()}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 142, 192, 233)),
                  ),
                  onPressed: () => _buyProducts(context),
                  child:
                      Text("Buy (Total: \$${totalPrice.toStringAsFixed(2)})"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
