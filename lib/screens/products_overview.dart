import '../widgets/products_grid.dart';
import 'package:flutter/material.dart';

class ProductsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ProductsGrid(),
    );
  }

  AppBar buildAppBar() => AppBar(title: Text("MERCAN Shop"));
}
