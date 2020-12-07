import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findByID(productID);

    return Scaffold(
      appBar: AppBar(title: Text(product.id)),
      body: Text(product.title),
    );
  }
}
