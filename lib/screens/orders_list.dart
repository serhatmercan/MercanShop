import 'package:ShopApp/providers/orders.dart' show Orders;
import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:ShopApp/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatefulWidget {
  static const routeName = "/orders_list";

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: bodyFutureBuilder(),
      drawer: AppDrawer(),
    );
  }

  FutureBuilder bodyFutureBuilder() {
    return FutureBuilder(
      future: _ordersFuture,
      builder: (ctx, data) {
        if (data.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (data.error == null) {
            return Consumer<Orders>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
              ),
            );
          } else {
            return Center(child: Text("An Error Occured!"));
          }
        }
      },
    );
  }
}
