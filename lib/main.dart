import 'package:ShopApp/helpers/custom_route.dart';
import 'package:ShopApp/providers/auth.dart';
import 'package:ShopApp/screens/auth_screen.dart';
import 'package:ShopApp/screens/edit_product.dart';
import 'package:ShopApp/screens/orders_list.dart';
import 'package:ShopApp/screens/products_overview.dart';
import 'package:ShopApp/screens/splash.dart';
import 'package:ShopApp/screens/user_products.dart';

import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_detail.dart';
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
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (_, auth, prevProducts) =>
              Products(auth.token, auth.userId, prevProducts == null ? [] : prevProducts.items),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (_, auth, prevOrders) => Orders(auth.token, auth.userId, prevOrders == null ? [] : prevOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          title: "MERCAN Shop",
          home: auth.isAuth
              ? ProductsOverview()
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState == ConnectionState.waiting ? Splash() : AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {
            ProductDetail.routeName: (context) => ProductDetail(),
            ShoppingCart.routeName: (context) => ShoppingCart(),
            OrdersList.routeName: (context) => OrdersList(),
            UserProducts.routeName: (context) => UserProducts(),
            EditProduct.routeName: (context) => EditProduct(),
          },
        ),
      ),
    );
  }

  ThemeData buildTheme() {
    return ThemeData(
      accentColor: Colors.red,
      fontFamily: "Lato",
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionBuilder(),
          TargetPlatform.iOS: CustomPageTransitionBuilder(),
        },
      ),
      primarySwatch: Colors.blue,
    );
  }
}
