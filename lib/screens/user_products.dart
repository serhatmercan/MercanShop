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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(EditProduct.routeName),
          ),
        ],
        title: const Text("Products"),
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, _) => Padding(
                    child: ListView.builder(
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
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ),
      ),
      drawer: AppDrawer(),
    );
  }
}
