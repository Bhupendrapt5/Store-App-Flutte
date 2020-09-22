
import 'package:flutter/foundation.dart';

class CartModel {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartModel({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
  factory CartModel.fromJson(json) {
    return CartModel(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
  Map toJson() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
      };
}

class Cart with ChangeNotifier {
  Map<String, CartModel> _items = {};

  Map<String, CartModel> get items {
    return {..._items};
  }

  int get cartItemLength {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addCartItem({String productId, double price, String title}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartModel(
          price: price,
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeLatestItem(String prodcutId) {
    if (!_items.containsKey(prodcutId)) {
      return;
    }
    if (_items[prodcutId].quantity > 1) {
      _items.update(
        prodcutId,
        (cartItem) => CartModel(
          id: cartItem.id,
          price: cartItem.price,
          title: cartItem.title,
          quantity: cartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(prodcutId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
