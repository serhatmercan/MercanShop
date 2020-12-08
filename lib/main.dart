import 'package:ShopApp/screens/shopping_cart.dart';

import './providers/cart.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        title: "MERCAN Shop",
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeName: (context) => ProductDetail(),
          ShoppingCart.routeName: (context) => ShoppingCart(),
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
