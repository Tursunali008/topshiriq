import 'package:flutter/material.dart';
import 'package:topshiriq/model/order.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/viewmodel/order_view_model.dart';

class OrderScreen extends StatelessWidget {
  final OrderViewModel _orderViewModel = OrderViewModel();

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('orders')),
      ),
      body: FutureBuilder(
        future: _orderViewModel.getUserOrder(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data[index];
                return Column(children: [
                  Text(order.id),
                  ...List.generate(
                    order.products.length,
                    (indexProduct) {
                      return ListTile(
                        leading: Image.network(
                            order.products[indexProduct].imageUrl),
                        title: Text(order.products[indexProduct].title),
                      );
                    },
                  ),
                ]);
              },
            );
          } else {
            return Text("Elsega tushdi");
          }
        },
      ),
    );
  }
}
