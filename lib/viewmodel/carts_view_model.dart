import 'package:topshiriq/model/cart.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/servis/cart_http_services.dart';

class CartsViewModel {
  final _cartHttpServices = CartHttpServices();

  Future<Cart?> getUserCart() async {
    return await _cartHttpServices.getCartByUser();
  }

  Future<void> addToCart(List<Product> products) async {
    return _cartHttpServices.addToCart(products);
  }

  clearCart() {}
}
