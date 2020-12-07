import './providers/products.dart';
import './screens/product_detail.dart';
import './screens/products_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Products(),
      child: MaterialApp(
        theme: buildTheme(),
        title: "MERCAN Shop",
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeName: (context) => ProductDetail(),
        },
      ),
    );
  }

  ThemeData buildTheme() {
    return ThemeData(
      accentColor: Colors.red,
      fontFamily: "Lato",
      primarySwatch: Colors.blue,
    );
  }
}