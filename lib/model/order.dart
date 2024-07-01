import 'package:topshiriq/model/product.dart';

class Order {
  final String id;
  bool isOrdered;
  List<Product> products;

  Order({
    required this.id,
    required this.isOrdered,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List<dynamic>? ?? [];
    List<Product> productsList = productsJson
        .map((productJson) =>
            Product.fromJson(productJson as Map<String, dynamic>))
        .toList();
    return Order(
      id: json['id'] ?? '',
      isOrdered:
          json['isOrdered'] ?? false, 
      products: productsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isOrdered': isOrdered,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
