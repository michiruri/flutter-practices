// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_db.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class CartDb extends _CartDb with RealmEntity, RealmObjectBase, RealmObject {
  CartDb(
    String code,
    String namedesc,
    double price,
    bool isFav,
    int quantity,
  ) {
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'namedesc', namedesc);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'isFav', isFav);
    RealmObjectBase.set(this, 'quantity', quantity);
  }

  CartDb._();

  @override
  String get code => RealmObjectBase.get<String>(this, 'code') as String;
  @override
  set code(String value) => RealmObjectBase.set(this, 'code', value);

  @override
  String get namedesc =>
      RealmObjectBase.get<String>(this, 'namedesc') as String;
  @override
  set namedesc(String value) => RealmObjectBase.set(this, 'namedesc', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  bool get isFav => RealmObjectBase.get<bool>(this, 'isFav') as bool;
  @override
  set isFav(bool value) => RealmObjectBase.set(this, 'isFav', value);

  @override
  int get quantity => RealmObjectBase.get<int>(this, 'quantity') as int;
  @override
  set quantity(int value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  Stream<RealmObjectChanges<CartDb>> get changes =>
      RealmObjectBase.getChanges<CartDb>(this);

  @override
  Stream<RealmObjectChanges<CartDb>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<CartDb>(this, keyPaths);

  @override
  CartDb freeze() => RealmObjectBase.freezeObject<CartDb>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'code': code.toEJson(),
      'namedesc': namedesc.toEJson(),
      'price': price.toEJson(),
      'isFav': isFav.toEJson(),
      'quantity': quantity.toEJson(),
    };
  }

  static EJsonValue _toEJson(CartDb value) => value.toEJson();
  static CartDb _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'code': EJsonValue code,
        'namedesc': EJsonValue namedesc,
        'price': EJsonValue price,
        'isFav': EJsonValue isFav,
        'quantity': EJsonValue quantity,
      } =>
        CartDb(
          fromEJson(code),
          fromEJson(namedesc),
          fromEJson(price),
          fromEJson(isFav),
          fromEJson(quantity),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(CartDb._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, CartDb, 'CartDb', [
      SchemaProperty('code', RealmPropertyType.string),
      SchemaProperty('namedesc', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('isFav', RealmPropertyType.bool),
      SchemaProperty('quantity', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
