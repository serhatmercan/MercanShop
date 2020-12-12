import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final bool value = isFavorite;
    final url =
        "https://shopapp-8e219-default-rtdb.europe-west1.firebasedatabase.app/favorites/$userId/$id.json?auth=$authToken";

    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        _setFavoriteStatu(value);
      }
    } catch (e) {
      _setFavoriteStatu(value);
    }
  }

  void _setFavoriteStatu(bool value) {
    isFavorite = value;
    notifyListeners();
  }
}
