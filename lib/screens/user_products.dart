import 'package:ShopApp/providers/products.dart';
import 'package:ShopApp/screens/edit_product.dart';
import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:ShopApp/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildIconButton(context),
        ],
        title: const Text("Products"),
      ),
      body: buildFutureBuilder(context),
      drawer: AppDrawer(),
    );
  }

  IconButton buildIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () => Navigator.of(context).pushNamed(EditProduct.routeName),
    );
  }

  FutureBuilder<void> buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: _refreshProducts(context),
      builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : buildRefreshIndicator(context),
    );
  }

  RefreshIndicator buildRefreshIndicator(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: Consumer<Products>(
        builder: (ctx, productsData, _) => Padding(
          child: buildListView(productsData),
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  ListView buildListView(Products productsData) {
    return ListView.builder(
      itemBuilder: (_, i) => Column(
        children: [
          UserProductItem(
            productsData.items[i].id,
            productsData.items[i].title,
            productsData.items[i].imageUrl,
          ),
          Divider(),
        ],
      ),
      itemCount: productsData.items.length,
    );
  }
}
