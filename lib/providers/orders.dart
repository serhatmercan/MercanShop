import './cart.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken";

    final response = await http.get(url);
    final List<OrderItem> orderItems = [];
    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data == null) return;

    data.forEach((orderId, orderData) {
      orderItems.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          products: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = orderItems;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "amount": total,
            "dateTime": timestamp.toIso8601String(),
            "products": cartProducts
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "quantity": e.quantity,
                      "price": e.price,
                    })
                .toList(),
          },
        ),
      );

      final order = OrderItem(
        id: json.decode(response.body)["name"],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      );

      _orders.add(order);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
