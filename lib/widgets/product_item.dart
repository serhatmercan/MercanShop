import 'package:ShopApp/providers/auth.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: buildGestureDetector(context, product),
        footer: buildGridTileBar(context, auth, product, cart),
      ),
    );
  }

  GestureDetector buildGestureDetector(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ProductDetail.routeName, arguments: product.id),
      child: buildHero(product),
    );
  }

  Hero buildHero(Product product) {
    return Hero(
      tag: product.id,
      child: buildFadeInImage(product),
    );
  }

  FadeInImage buildFadeInImage(Product product) {
    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: AssetImage("assets/images/product-placeholder.png"),
      image: NetworkImage(product.imageUrl),
    );
  }

  GridTileBar buildGridTileBar(BuildContext context, Auth auth, Product product, Cart cart) {
    return GridTileBar(
      backgroundColor: Colors.black54,
      leading: buildConsumer(context, auth),
      title: buildText(product),
      trailing: buildIconButton(context, cart, product),
    );
  }

  Consumer<Product> buildConsumer(BuildContext context, Auth auth) {
    return Consumer<Product>(
      builder: (ctx, product, _) => IconButton(
        color: Theme.of(context).accentColor,
        icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () => product.toggleFavoriteStatus(auth.token, auth.userId),
      ),
    );
  }

  Text buildText(Product product) {
    return Text(
      product.title,
      textAlign: TextAlign.center,
    );
  }

  IconButton buildIconButton(BuildContext context, Cart cart, Product product) {
    return IconButton(
      color: Theme.of(context).accentColor,
      icon: Icon(Icons.shopping_cart),
      onPressed: () {
        cart.addItem(product.id, product.title, product.price);
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Added Item to Cart !"),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () => cart.deleteSingleItem(product.id),
            ),
          ),
        );
      },
    );
  }
}
