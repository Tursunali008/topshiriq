import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshiriq/model/order.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/model/user.dart';
import 'package:topshiriq/servis/product_httpservis.dart';

class OrderHttpServise {
  final String baseUrl =
      "https://produts-e3019-default-rtdb.firebaseio.com/orders";

  final productHttpServices = ProductServices();

  Future<List<Order>> getorderByUser() async {
    final user = await getUser();
    Uri url = Uri.parse('$baseUrl/${user.id}/orders.json');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Order> orders = [];

      if (data != null) {
        
        data.forEach((key, value) {
          if (value != null) {
            value['id'] = key;
            orders.add(Order.fromJson(value));
          }
        });
      }
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> addToOrder(List<Product> products) async {
    final user = await getUser();
    Order order = Order(id: user.id, products: products, isOrdered: true);
    Uri url = Uri.parse("$baseUrl/${user.id}/orders.json");
    final response = await http.post(
      url,
      body: jsonEncode(order.toMap()),
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
