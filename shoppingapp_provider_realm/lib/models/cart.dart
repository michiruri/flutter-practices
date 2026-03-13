import 'package:flutter/material.dart';
import 'package:shoppingapp_provider_realm/models/product.dart';

class Cart extends ChangeNotifier {
  final List<CartItem> _cart = [];

  List<CartItem> get items => _cart;
  int get count => _cart.length;
  int get countTotal {
    int counter = 0;
    for (var cartItem in items) {
      counter += cartItem.quantity;
    }
    return counter;
  }

  void add(CartItem cartItem) {
    _cart.add(cartItem);
    notifyListeners();
  }

  void updateQuantity(index, int quantity) {
    _cart[index].quantity = quantity;
    notifyListeners();
  }

  void delete(CartItem cartItem) {
    _cart.remove(cartItem);
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  late int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}
