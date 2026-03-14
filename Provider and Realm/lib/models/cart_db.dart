import 'package:realm/realm.dart';

part 'cart_db.realm.dart';

@RealmModel()
class _CartDb {
  late String code;
  late String namedesc;
  late double price;
  late bool isFav;

  late int quantity;
}
