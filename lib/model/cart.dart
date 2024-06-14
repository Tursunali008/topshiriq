import 'package:topshiriq/model/product.dart';

class Cart {
  final String id;
  List<Product> products;

  Cart({
    required this.id,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> pros = {};
    for (var product in products) {
      pros[product.id] = product.toJson();
    }
    return pros;
  }
}
