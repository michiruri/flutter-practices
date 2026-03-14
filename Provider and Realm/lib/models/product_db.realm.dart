// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_db.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ProductDb extends _ProductDb
    with RealmEntity, RealmObjectBase, RealmObject {
  ProductDb(
    String code,
    String namedesc,
    double price,
    bool isFav,
  ) {
    RealmObjectBase.set(this, 'code', code);
    RealmObjectBase.set(this, 'namedesc', namedesc);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'isFav', isFav);
  }

  ProductDb._();

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
  Stream<RealmObjectChanges<ProductDb>> get changes =>
      RealmObjectBase.getChanges<ProductDb>(this);

  @override
  Stream<RealmObjectChanges<ProductDb>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ProductDb>(this, keyPaths);

  @override
  ProductDb freeze() => RealmObjectBase.freezeObject<ProductDb>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'code': code.toEJson(),
      'namedesc': namedesc.toEJson(),
      'price': price.toEJson(),
      'isFav': isFav.toEJson(),
    };
  }

  static EJsonValue _toEJson(ProductDb value) => value.toEJson();
  static ProductDb _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'code': EJsonValue code,
        'namedesc': EJsonValue namedesc,
        'price': EJsonValue price,
        'isFav': EJsonValue isFav,
      } =>
        ProductDb(
          fromEJson(code),
          fromEJson(namedesc),
          fromEJson(price),
          fromEJson(isFav),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ProductDb._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ProductDb, 'ProductDb', [
      SchemaProperty('code', RealmPropertyType.string),
      SchemaProperty('namedesc', RealmPropertyType.string),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('isFav', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
