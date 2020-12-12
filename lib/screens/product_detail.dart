import '../providers/products.dart';
import 'package:ShopApp/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context, listen: false).findByID(productID);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(product),
          buildSliverList(product),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar(Product product) {
    return SliverAppBar(
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: product.id,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product.title),
      ),
      pinned: true,
    );
  }

  SliverList buildSliverList(Product product) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 10),
        Text(
          "\$${product.price}",
          style: TextStyle(color: Colors.grey, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Text(
            product.description,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 800),
      ]),
    );
  }
}
