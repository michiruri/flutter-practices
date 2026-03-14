import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../models/item.dart';

class ItemListingScreen extends StatefulWidget {
  const ItemListingScreen({super.key});

  @override
  State<ItemListingScreen> createState() => _ItemState();
}

class _ItemState extends State<ItemListingScreen> {
  late Realm realm;
  late RealmResults<Item> items;
  final itemCtrl = TextEditingController();

  void initRealm() {
    var config = Configuration.local([Item.schema]);
    realm = Realm(config);
  }

  void loadItems() {
    items = realm.all<Item>();
    setState(() {});
  }

  void addItem() {
    if (itemCtrl.text.isNotEmpty) {
      realm.write(
        () => realm.add(
          Item(itemCtrl.text, false),
        ),
      );
      loadItems();
      itemCtrl.clear();
    }
  }

  void updateIsChecked(int index, bool? value) {
    realm.write(
      () => items[index].isChecked = value!,
    );
    loadItems();
  }

  void checkAllItems() {
    bool allChecked = true;
    items.forEach((element) {
      if (element.isChecked == false) {
        allChecked = false;
      }
    });
    realm.write(
      () => items.forEach(
        (element) => element.isChecked = !allChecked,
      ),
    );

    loadItems();
  }

  void deleteCheckedItem() {
    realm.write(
      () => realm.deleteMany<Item>(items.where(
        (element) => element.isChecked == true,
      )),
    );
    loadItems();
  }

  @override
  void initState() {
    super.initState();
    initRealm();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black,
        leading: IconButton(
          onPressed: () => checkAllItems(),
          icon: Icon(Icons.check_circle_outline),
        ),
        title: Text(
          'Shopping List',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => deleteCheckedItem(),
            icon: Icon(Icons.cleaning_services),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: itemCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Item',
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () => addItem(),
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        minTileHeight: 70,
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            side: BorderSide(color: Colors.grey, width: 2),
                            activeColor: Colors.grey,
                            value: item.isChecked,
                            onChanged: (value) => updateIsChecked(index, value),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
