import 'package:ShopApp/providers/orders.dart' show Orders;
import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:ShopApp/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatelessWidget {
  static const routeName = "/orders_list";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
      drawer: AppDrawer(),
    );
  }
}
