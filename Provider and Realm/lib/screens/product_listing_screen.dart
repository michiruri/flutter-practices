import 'package:capitis_mad2_assignment_3/models/cart.dart';
import 'package:capitis_mad2_assignment_3/models/cart_db.dart';
import 'package:capitis_mad2_assignment_3/models/products.dart';
import 'package:capitis_mad2_assignment_3/models/product_db.dart';
import 'package:capitis_mad2_assignment_3/screens/cart_listing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class ProductListingScreen extends StatelessWidget {
  ProductListingScreen({super.key});

  final codeCtrl = TextEditingController();
  final namedescCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  bool isConfirmDeleteDialogueClosed = false;
  bool isFavsOnly = false;
  List<CartItem> cart = [];
  List<Product> products = [];

  late Realm realm;

  void initRealm() {
    var config = Configuration.local([ProductDb.schema, CartDb.schema]);
    realm = Realm(config);
  }

  void updateProductsDb(BuildContext context) {
    products = Provider.of<Products>(context, listen: false).items;
    realm.write(
      () {
        realm.deleteAll<ProductDb>();
        for (var product in products) {
          realm.add(
            ProductDb(
              product.code,
              product.namedesc,
              product.price,
              product.isFav,
            ),
          );
        }
      },
    );
    updateCartDb(context);
  }

  void updateCartDb(BuildContext context) {
    List<CartItem> cart = Provider.of<Cart>(context, listen: false).items;

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

  void getProductDb(BuildContext context) {
    List<ProductDb> productDb = realm.all<ProductDb>().toList();
    if (productDb.isNotEmpty) {
      List<Product> updatedProducts = [];
      for (var product in productDb) {
        updatedProducts.add(
          Product(
            code: product.code,
            namedesc: product.namedesc,
            price: product.price,
            isFav: product.isFav,
          ),
        );
      }
      Provider.of<Products>(context, listen: false)
          .updateFromDb(updatedProducts);
    } else {
      products.clear();
    }
    products = Provider.of<Products>(context, listen: false).items;
  }

  @override
  Widget build(BuildContext context) {
    initRealm();
    getProductDb(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('View Products'),
        actions: [
          Card(
            color: Colors.blue.shade900,
            child: IconButton(
              onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => CartListingScreen(),
              )),
              icon: Icon(Icons.shopping_cart_outlined),
            ),
          ),
          IconButton(
            onPressed: () => showAddProductDialogue(context),
            icon: Icon(Icons.add),
          ),
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () => filterAll(context),
                child: Text(
                  'All',
                  style: TextStyle(letterSpacing: 1),
                ),
              ),
              MenuItemButton(
                onPressed: () => filterIsFavsOnly(context),
                child: Text(
                  'Favorites Only',
                  style: TextStyle(letterSpacing: 1),
                ),
              ),
            ],
            builder: (context, controller, _) {
              return IconButton(
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: Icon(Icons.more_vert),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<Products>(
          builder: (context, value, _) {
            checkFilter(value);
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
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
                      leading: IconButton(
                        onPressed: () => toggleIsFav(context, product),
                        icon: product.isFav
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_outline),
                      ),
                      title: Text(product.namedesc),
                      trailing: IconButton(
                        onPressed: () => addCartItem(context, product),
                        icon: Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showAddProductDialogue(BuildContext context) {
    clearTextFieldCtrls();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: namedescCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name/Desc',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => validateInput(context, 'Add'),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void validateInput(BuildContext context, String action, {index}) {
    List<String> filter = ['.'];
    int decimalCounter = 0;
    bool isValid = false;
    String errorMessage = '';
    for (var i = 0; i <= 9; i++) {
      filter.add(i.toString());
    }

    if (codeCtrl.text.trim().isNotEmpty &&
        namedescCtrl.text.trim().isNotEmpty &&
        priceCtrl.text.trim().isNotEmpty) {
      for (var i = 0; i < priceCtrl.text.length; i++) {
        if (filter.contains(priceCtrl.text[i]) &&
            !priceCtrl.text.contains(' ')) {
          isValid = true;
          if (priceCtrl.text[i] == '.') {
            decimalCounter++;
          }
          if (decimalCounter > 1) {
            isValid = false;
            break;
          }
        } else {
          isValid = false;
          errorMessage = 'Error! Invalid amount.';
          break;
        }
      }
    } else {
      errorMessage = 'Error! All fields must not be empty.';
    }
    if (isValid) {
      Product product = Product(
          code: codeCtrl.text.trim(),
          namedesc: namedescCtrl.text.trim(),
          price: double.parse(priceCtrl.text),
          isFav: index != null ? products[index].isFav : false);
      action == 'Add'
          ? addProduct(context, product)
          : updateProduct(context, product, index);
    } else {
      showSnackBarMessage(context, errorMessage);
    }
  }

  void addProduct(BuildContext context, Product product) {
    Provider.of<Products>(context, listen: false).add(product);
    updateProductsDb(context);
    Navigator.of(context).pop();
    String message = 'Successfully added ${namedescCtrl.text.trim()}.';
    showSnackBarMessage(context, message);
    clearTextFieldCtrls();
  }

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void clearTextFieldCtrls() {
    codeCtrl.clear();
    namedescCtrl.clear();
    priceCtrl.clear();
  }

  void showConfirmDeleteDialogue(
      BuildContext context, int index, Product product) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text.rich(
            TextSpan(
              text: 'Confirm delete ',
              children: [
                TextSpan(
                  text: product.namedesc,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ?',
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
              onPressed: () => deleteProduct(context, index),
              child: Text('Yes'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Provider.of<Products>(context, listen: false).notify();
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void deleteProduct(BuildContext context, int index) {
    String deletedProduct = products[index].namedesc;
    cart = Provider.of<Cart>(context, listen: false).items;
    bool cartItemExists = false;
    int cartItemIndex = -1;
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].product.code == products[index].code) {
        cartItemExists = true;
        cartItemIndex = i;
        break;
      }
    }
    if (cartItemExists) {
      Provider.of<Cart>(context, listen: false).delete(cartItemIndex);
    }
    Provider.of<Products>(context, listen: false).delete(index);

    updateProductsDb(context);
    Navigator.of(context).pop();
    showSnackBarMessage(context, 'Successfuly deleted $deletedProduct.');
  }

  void addCartItem(BuildContext context, Product product) {
    Provider.of<Cart>(context, listen: false).add(product);
    Provider.of<Cart>(context, listen: false).update(product);
    updateCartDb(context);
    showSnackBarMessage(context, 'Added ${product.namedesc} to the cart!');
  }

  void toggleIsFav(BuildContext context, Product product) {
    Provider.of<Products>(context, listen: false).toggleIsFav(product);
    Provider.of<Cart>(context, listen: false).update(product);
    updateProductsDb(context);
  }

  void checkFilter(Products value) {
    if (isFavsOnly) {
      products = value.items
          .where(
            (product) => product.isFav,
          )
          .toList();
    } else {
      products = value.items;
    }
  }

  void filterAll(BuildContext context) {
    isFavsOnly = false;
    Provider.of<Products>(context, listen: false).notify();
  }

  void filterIsFavsOnly(BuildContext context) {
    isFavsOnly = true;
    Provider.of<Products>(context, listen: false).notify();
  }

  void showProductDetails(BuildContext context, Product product, int index) {
    codeCtrl.text = product.code;
    namedescCtrl.text = product.namedesc;
    priceCtrl.text = product.price.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: namedescCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name/Desc',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Price',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => validateInput(context, 'Update', index: index),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void updateProduct(BuildContext context, Product product, int index) {
    Provider.of<Products>(context, listen: false).update(product, index);
    Provider.of<Cart>(context, listen: false).update(product);
    updateProductsDb(context);
    Navigator.of(context).pop();
    showSnackBarMessage(context, 'Successfully updated ${product.namedesc}.');
  }
}
