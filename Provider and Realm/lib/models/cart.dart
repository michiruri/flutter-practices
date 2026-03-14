import 'package:capitis_mad2_assignment_3/models/products.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  List<CartItem> _cart = [];

  List<CartItem> get items => _cart;
  int get count => _cart.length;

  void add(Product product) {
    bool itemExists = false;
    for (var cartItem in _cart) {
      if (cartItem.product.code == product.code) {
        cartItem.quantity++;
        itemExists = true;
        break;
      }
    }
    !itemExists ? _cart.add(CartItem(product: product)) : null;
    update(product);
    notifyListeners();
  }

  void updateQuantity() {
    notifyListeners();
  }

  void delete(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void update(Product product) {
    for (var cartItem in _cart) {
      if (cartItem.product.code == product.code) {
        cartItem.product.code = product.code;
        cartItem.product.namedesc = product.namedesc;
        cartItem.product.price = product.price;
        cartItem.product.isFav = product.isFav;
      }
    }
    notifyListeners();
  }

  void updateFromDb(List<CartItem> updatedCart) {
    _cart.clear();
    _cart = updatedCart;
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}
