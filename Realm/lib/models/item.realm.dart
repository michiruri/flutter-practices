// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  Item(
    String name,
    bool isChecked,
  ) {
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'isChecked', isChecked);
  }

  Item._();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  bool get isChecked => RealmObjectBase.get<bool>(this, 'isChecked') as bool;
  @override
  set isChecked(bool value) => RealmObjectBase.set(this, 'isChecked', value);

  @override
  Stream<RealmObjectChanges<Item>> get changes =>
      RealmObjectBase.getChanges<Item>(this);

  @override
  Stream<RealmObjectChanges<Item>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Item>(this, keyPaths);

  @override
  Item freeze() => RealmObjectBase.freezeObject<Item>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'name': name.toEJson(),
      'isChecked': isChecked.toEJson(),
    };
  }

  static EJsonValue _toEJson(Item value) => value.toEJson();
  static Item _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'name': EJsonValue name,
        'isChecked': EJsonValue isChecked,
      } =>
        Item(
          fromEJson(name),
          fromEJson(isChecked),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Item._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Item, 'Item', [
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('isChecked', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
