import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/misc/api_key.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

final timeStamp = DateTime.now();

class OrderModel {
  final String id;
  final double amount;
  final List<CartModel> products;
  final DateTime dateTime;

  OrderModel({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String token;
  final String userID;
  final _url = '${APIKeys.baseUrl}/orders.json?auth=';
  List<OrderModel> _orderItmes = [];

  Orders(
    this.token,
    this._orderItmes, 
    this.userID,
  );

  List<OrderModel> get  orderItmes {
    return [..._orderItmes];
  }

  Future<void> fetchOrders() async {
    try {
      final _res = await http.get(_url + token+'&orderBy="userId"&equalTo="$userID"');
      final _extractData = json.decode(_res.body) as Map<String, dynamic>;
      final List<OrderModel> _ordersList = [];
      if (_extractData != null) {
        _extractData.forEach((orderId, orderData) {
          print('');
          _ordersList.insert(
            0,
            OrderModel(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartModel.fromJson(item))
                  .toList(),
            ),
          );
        });
      }

      _orderItmes = _ordersList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
      {List<CartModel> cartProducts, double totalAmount}) async {
    try {
      var _res = await http.post(_url + token,
          body: json.encode({
            'amount': totalAmount,
            'userId':userID,
            'dateTime': timeStamp.toIso8601String(),
            'products':
                cartProducts.map((cartItem) => cartItem.toJson()).toList(),
          }));
      _orderItmes.insert(
        0,
        OrderModel(
          id: json.decode(_res.body)['name'],
          amount: totalAmount,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print('Add error : => $error');
      throw error;
    }
  }
}
