import 'package:flutter/material.dart';

class Number extends ChangeNotifier {
  late int counter;

  void increment(Number number) {
    number.counter++;
    notifyListeners();
  }

  void decrement(Number number) {
    number.counter--;
    notifyListeners();
  }

  Number({this.counter = 0});
}
