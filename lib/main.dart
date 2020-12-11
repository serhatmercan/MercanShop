import 'package:ShopApp/providers/auth.dart';
import 'package:ShopApp/screens/auth_screen.dart';
import 'package:ShopApp/screens/edit_product.dart';
import 'package:ShopApp/screens/orders_list.dart';
import 'package:ShopApp/screens/user_products.dart';

import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_detail.dart';
import './screens/products_overview.dart';
import './screens/shopping_cart.dart';
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
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        title: "MERCAN Shop",
        home: AuthScreen(),
        routes: {
          ProductDetail.routeName: (context) => ProductDetail(),
          ShoppingCart.routeName: (context) => ShoppingCart(),
          OrdersList.routeName: (context) => OrdersList(),
          UserProducts.routeName: (context) => UserProducts(),
          EditProduct.routeName: (context) => EditProduct(),
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
