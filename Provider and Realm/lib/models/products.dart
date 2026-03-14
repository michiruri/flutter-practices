import 'package:flutter/material.dart';

class Products extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get items => _products;
  int get count => _products.length;

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void delete(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void toggleIsFav(Product product) {
    product.isFav = !product.isFav;
    notifyListeners();
  }

  void update(Product product, int index) {
    _products[index] = product;
    notifyListeners();
  }

  void updateFromDb(List<Product> updatedProducts) {
    _products.clear();
    _products = updatedProducts;
  }
}

class Product {
  String code;
  String namedesc;
  double price;
  bool isFav;

  Product({
    required this.code,
    required this.namedesc,
    required this.price,
    this.isFav = false,
  });
}
