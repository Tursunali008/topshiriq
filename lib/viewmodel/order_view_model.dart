import 'package:topshiriq/model/order.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/servis/order_http_servise.dart';

class OrderViewModel {
  final _orderHttpServices = OrderHttpServise();

  Future<List<Order>> getUserOrder() async {
    return await _orderHttpServices.getorderByUser();
  }

  Future<void> addToOrder(List<Product> products) async {
    return _orderHttpServices.addToOrder(products);
  }

  clearOrder() {}
}
