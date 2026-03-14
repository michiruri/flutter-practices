import 'package:realm/realm.dart';

part 'item.realm.dart';

@RealmModel()
class _Item {
  late String name;
  late bool isChecked;
}
