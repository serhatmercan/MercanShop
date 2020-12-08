import '../providers/products.dart';
import '../widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = _showOnlyFavorites ? productsData.favorites : productsData.items;

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(10),
      gridDelegate: buildGridDelegate(),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount buildGridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      childAspectRatio: 3 / 2,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    );
  }
}
