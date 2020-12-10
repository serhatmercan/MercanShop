import 'package:ShopApp/providers/products.dart';
import 'package:ShopApp/widgets/app_drawer.dart';

import '../screens/shopping_cart.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) => {
          setState(() {
            _isLoading = false;
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text("Only Favorites"),
              value: FilterOptions.Favorites,
            ),
            PopupMenuItem(
              child: Text("Show All"),
              value: FilterOptions.All,
            ),
          ],
          onSelected: (FilterOptions selectedValue) {
            setState(() {
              _showOnlyFavorites = selectedValue == FilterOptions.Favorites;
            });
          },
        ),
        Consumer<Cart>(
          builder: (_, cart, child) => Badge(
            child: child,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).pushNamed(ShoppingCart.routeName),
          ),
        ),
      ],
      title: Text("MERCAN Shop"),
    );
  }
}
