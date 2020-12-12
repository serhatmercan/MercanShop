import '../providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: buildContainer(context),
      confirmDismiss: (direction) => buildShowDialog(context),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => Provider.of<Cart>(context, listen: false).deleteItem(productId),
      child: buildCard(),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      color: Theme.of(context).errorColor,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.only(right: 20),
      child: buildIcon(),
    );
  }

  Icon buildIcon() {
    return Icon(
      Icons.delete,
      color: Colors.white,
      size: 40,
    );
  }

  Future<bool> buildShowDialog(BuildContext context) {
    return showDialog(
      builder: (ctx) => AlertDialog(
        actions: [
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ],
        content: Text("Do you want to delete the item from the cart ?"),
        title: Text("Info"),
      ),
      context: context,
    );
  }

  Card buildCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: buildListTile(),
      ),
    );
  }

  ListTile buildListTile() {
    return ListTile(
      leading: buildCircleAvatar(),
      subtitle: Text("Total: \$${(price * quantity)}"),
      title: Text(title),
      trailing: Text("$quantity x"),
    );
  }

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FittedBox(
          child: Text("\$$price"),
        ),
      ),
    );
  }
}
