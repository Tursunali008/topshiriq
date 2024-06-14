import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/model/user.dart';

class ProductServices {
  final String baseUrl =
      "https://produts-e3019-default-rtdb.firebaseio.com/products.json";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];

      data.forEach((key, value) {
        value['id'] = key;
        loadedProducts.add(Product.fromJson(value));
      });
      return loadedProducts;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final url = Uri.parse(
        "https://produts-e3019-default-rtdb.firebaseio.com/products/$id.json");
    final response = await http.patch(
      url,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }

    await _updateCartProduct(product);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://produts-e3019-default-rtdb.firebaseio.com/products/$id.json");
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<void> _updateCartProduct(Product product) async {
    final user = await getUser();
    final url = Uri.parse(
        'https://produts-e3019-default-rtdb.firebaseio.com/carts/${user.id}/${product.id}.json');
    final response = await http.patch(
      url,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<User> getUser() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? userData = sharedPreferences.getString("userData");
    User user = User.fromMap(jsonDecode(userData!));
    return user;
  }
}
