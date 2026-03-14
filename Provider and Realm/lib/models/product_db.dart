import 'package:realm/realm.dart';

part 'product_db.realm.dart';

@RealmModel()
class _ProductDb {
  late String code;
  late String namedesc;
  late double price;
  late bool isFav;
}
