import 'package:flutter/material.dart';

class Products extends ChangeNotifier {
  final List<Product> _products = [
    Product(id: 1, name: 'Kiamoy', desc: 'Dried Prune/Plum', price: 69)
  ];

  List<Product> get items => _products;
  int get count => _products.length;
  int get newId {
    int id = 0;
    if (_products.isNotEmpty) {
      id = _products[_products.length - 1].id + 1;
    }
    return id;
  }

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void toggleIsFav(Product product) {
    product.isFav = !product.isFav;
    notifyListeners();
  }

  void delete(Product product) {
    _products.remove(product);
    notifyListeners();
  }
}

class Product {
  final int id;
  final String name;
  final String desc;
  final double price;
  late bool isFav;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    this.isFav = false,
  });
}
