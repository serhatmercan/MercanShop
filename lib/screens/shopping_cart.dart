import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatelessWidget {
  static const routeName = "/shopping_cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Shopping List")),
      body: Column(
        children: [buildCard(context, cart), SizedBox(height: 10), buildExpanded(cart)],
      ),
    );
  }

  Card buildCard(BuildContext context, Cart cart) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total", style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Spacer(),
            buildChip(context, cart),
            OrderButton(cart: cart),
          ],
        ),
      ),
    );
  }

  Chip buildChip(BuildContext context, Cart cart) {
    return Chip(
      backgroundColor: Theme.of(context).primaryColor,
      label: Text(
        "\$${cart.totalAmount.toStringAsFixed(2)}",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Expanded buildExpanded(Cart cart) {
    return Expanded(
      child: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (ctx, i) => CartItem(
          cart.items.values.toList()[i].id,
          cart.items.keys.toList()[i],
          cart.items.values.toList()[i].price,
          cart.items.values.toList()[i].quantity,
          cart.items.values.toList()[i].title,
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;

    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER"),
    );
  }
}
