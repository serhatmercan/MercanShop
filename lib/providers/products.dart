import 'dart:convert';
import 'package:ShopApp/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'package:flutter/foundation.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [];

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return items.where((element) => element.isFavorite == true).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filter = filterByUser ? "orderBy='userId'&equalTo='$userId'" : "";
    var url =
        "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filter";

    try {
      final productsResponse = await http.get(url);
      final productsData = json.decode(productsResponse.body) as Map<String, dynamic>;
      final List<Product> products = [];

      if (productsData == null) return;

      url =
          "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/favorites/$userId.json?auth=$authToken";
      final favoritesResponse = await http.get(url);
      final favoritesData = json.decode(favoritesResponse.body);

      productsData.forEach((productId, productData) {
        products.add(
          Product(
            id: productId,
            title: productData["title"],
            description: productData["description"],
            price: productData["price"],
            imageUrl: productData["imageUrl"],
            isFavorite: favoritesData == null ? false : favoritesData[productId] ?? false,
          ),
        );
      });

      _items = products;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "userId": userId,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(Product product) async {
    final productIndex = _items.indexWhere((element) => element.id == product.id);
    if (productIndex >= 0) {
      final url =
          "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$authToken";

      await http.patch(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));

      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/products/${id}.json?auth=$authToken";
    final index = _items.indexWhere((element) => element.id == id);
    var product = _items[index];

    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }

    product = null;
  }
}
