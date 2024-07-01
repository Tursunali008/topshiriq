import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshiriq/model/cart.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/model/user.dart';
import 'package:topshiriq/servis/product_httpservis.dart';

class CartHttpServices {
  final String baseUrl =
      "https://produts-e3019-default-rtdb.firebaseio.com/carts";

  final productHttpServices = ProductServices();

  Future<Cart?> getCartByUser() async {
    final user = await getUser();
    Uri url = Uri.parse('$baseUrl/${user.id}.json');

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Product> products = [];
    Cart? cart;
    if (data != null) {
      data.forEach((key, value) {
        value['id'] = key;
        products.add(Product.fromJson(value));
      });
      cart = Cart(
        id: user.id,
        products: products,
      );
      print(cart);
    }

    return cart;
  }

  Future<void> addToCart(List<Product> products) async {
    final user = await getUser();
    Cart cart = Cart(id: user.id, products: products);
    Uri url = Uri.parse("$baseUrl/${user.id}.json");
    final response = await http.put(
      url,
      body: jsonEncode(cart.toMap()),
    );
    final data = jsonDecode(response.body);

    print(data);
  }

  Future<User> getUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");
    User user = User.fromMap(jsonDecode(userData!));
    return user;
  }
}
