import 'package:flutter/material.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/viewmodel/carts_view_model.dart';
import 'package:topshiriq/viewmodel/order_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cartViewModel = CartsViewModel();
  final orderViewModel = OrderViewModel();
  List<Product> order = [];

  double _calculateTotalPrice(List<Product> products) {
    return products.fold(
        0, (total, product) => total + product.price * product.amount);
  }

  void _buyProducts(BuildContext context) async {
    try {
      List<Product> productsToBuy =
          (await cartViewModel.getUserCart())!.products;

      await orderViewModel.addToOrder(productsToBuy);

      await cartViewModel.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('order_placed_success')),
        ),
      );

      setState(() {
        order.addAll(productsToBuy);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('order_failed', args: [e.toString()])),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: cartViewModel.getUserCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(tr('error_occurred')), // Localized error message
            );
          }

          final cart = snapshot.data;
          if (cart == null || cart.products.isEmpty) {
            return Center(
              child: Text(tr('cart_empty')), // Localized empty cart message
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
                      subtitle: Text(
                          '${tr('price')}: \$${product.price.toString()}'), // Localized price text
                      trailing:
                          Text('${tr('amount')}: ${product.amount.toString()}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      {_buyProducts(context), cartViewModel.clearCart()},
                  child: Text(tr('buy_button',
                      args: ['\$${totalPrice.toStringAsFixed(2)}'])),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
