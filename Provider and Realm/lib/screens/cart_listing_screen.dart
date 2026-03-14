import 'package:capitis_mad2_assignment_3/models/cart.dart';
import 'package:capitis_mad2_assignment_3/models/cart_db.dart';
import 'package:capitis_mad2_assignment_3/models/product_db.dart';
import 'package:capitis_mad2_assignment_3/models/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class CartListingScreen extends StatelessWidget {
  CartListingScreen({super.key});

  final codeCtrl = TextEditingController();
  final namedescCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  List<CartItem> cart = [];
  List<Product> products = [];

  late Realm realm;

  void initRealm() {
    var config = Configuration.local([CartDb.schema, ProductDb.schema]);
    realm = Realm(config);
  }

  void getCartDb(BuildContext context) {
    List<CartDb> cartDb = realm.all<CartDb>().toList();
    if (cartDb.isNotEmpty) {
      List<CartItem> updatedCart = [];
      for (var item in cartDb) {
        updatedCart.add(
          CartItem(
            product: Product(
              code: item.code,
              namedesc: item.namedesc,
              price: item.price,
              isFav: item.isFav,
            ),
            quantity: item.quantity,
          ),
        );
      }
      Provider.of<Cart>(context, listen: false).updateFromDb(updatedCart);
    } else {
      cart.clear();
    }
    cart = Provider.of<Cart>(context, listen: false).items;
  }

  void updateCartDb(BuildContext context) {
    cart = Provider.of<Cart>(context, listen: false).items;
    realm.write(
      () {
        realm.deleteAll<CartDb>();
        for (var item in cart) {
          realm.add(
            CartDb(
              item.product.code,
              item.product.namedesc,
              item.product.price,
              item.product.isFav,
              item.quantity,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initRealm();
    getCartDb(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              var product = cart[index].product;
              int quantity = cart[index].quantity;
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) =>
                    showConfirmDeleteDialogue(context, index, product),
                background: Card(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Card(
                  child: ListTile(
                    onTap: () => showProductDetails(context, product, index),
                    leading: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: product.isFav
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_outline),
                    ),
                    title: Text(product.namedesc),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              decreaseQuantity(context, index, product),
                          icon: Icon(Icons.arrow_left),
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () => increaseQuantity(context, product),
                          icon: Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void toggleIsFav(BuildContext context, Product product) {
    Provider.of<Products>(context, listen: false).toggleIsFav(product);
    Provider.of<Cart>(context, listen: false).update(product);
  }

  void decreaseQuantity(BuildContext context, int index, Product product) {
    List<CartItem> cart = Provider.of<Cart>(context, listen: false).items;
    for (var cartItem in cart) {
      if (cartItem.product == product) {
        cartItem.quantity--;
        if (cartItem.quantity <= 0) {
          cartItem.quantity = 1;
          showConfirmDeleteDialogue(context, index, product);
          break;
        }
        Provider.of<Cart>(context, listen: false).notify();
      }
    }
    updateCartDb(context);
  }

  void increaseQuantity(BuildContext context, Product product) {
    Provider.of<Cart>(context, listen: false).add(product);
    updateCartDb(context);
  }

  void showProductDetails(BuildContext context, Product product, int index) {
    codeCtrl.text = product.code;
    namedescCtrl.text = product.namedesc;
    priceCtrl.text = product.price.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('View Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                readOnly: true,
                controller: codeCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: namedescCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name/Desc',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                readOnly: true,
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showConfirmDeleteDialogue(
      BuildContext context, int index, Product product) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove Item'),
          content: Text.rich(
            TextSpan(
              text: 'Confirm remove ',
              children: [
                TextSpan(
                  text: product.namedesc,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' from the cart?',
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => removeCartItem(context, index, product),
              child: Text('Yes'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Provider.of<Cart>(context, listen: false).notify();
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void removeCartItem(BuildContext context, int index, Product product) {
    Provider.of<Cart>(context, listen: false).delete(index);
    updateCartDb(context);
    Navigator.of(context).pop();
    showSnackBarMessage(context, 'Succesfully deleted ${product.namedesc}.');
  }

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
