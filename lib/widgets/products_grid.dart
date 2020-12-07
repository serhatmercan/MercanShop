import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(10),
      gridDelegate: buildGridDelegate(),
      itemBuilder: (ctx, i) => buildItemBuilder(products, i),
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

  ProductItem buildItemBuilder(List<Product> products, int i) {
    return ProductItem(
      products[i].id,
      products[i].title,
      products[i].imageUrl,
    );
  }
}
