import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:shop_app/misc/api_key.dart';
import 'package:shop_app/model/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.price,
      this.isFavorite = false});

  String toJson({String userId}) => json.encode({
        // "id": id,
        "description": description,
        "title": title,
        "imgUrl": imageUrl,
        "price": price,
        "userId": userId,
      });

  _setFavorite(bool newBoolVal) {
    isFavorite = newBoolVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus({String token, String userId}) async {
    var _oldStatus = isFavorite;
    _setFavorite(!isFavorite);
    print('isFAv : $isFavorite');
    try {
      final _url =
          '${APIKeys.baseUrl}/userFavorites/$userId/$id.json?auth=$token';

      var res = await http.put(
        _url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (res.statusCode >= 400) {
        _setFavorite(_oldStatus);
        throw HttpException(messge: 'Could Not update..');
      }
      notifyListeners();
    } catch (error) {
      _setFavorite(_oldStatus);
      print('update error : => $error');
      throw error;
    }
  }
}
