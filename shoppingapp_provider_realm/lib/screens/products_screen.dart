import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp_provider_realm/models/cart.dart';
import 'package:shoppingapp_provider_realm/models/product.dart';
import 'package:shoppingapp_provider_realm/screens/cart_items_screen.dart';
import 'package:shoppingapp_provider_realm/screens/product_details_screen.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, _) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => CartItemsScreen(),
                    )),
                    icon: Icon(Icons.shopping_cart),
                  ),
                  if (cart.countTotal != 0)
                    Positioned(
                      right: 0,
                      bottom: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue.shade900,
                        ),
                        child: Text(
                          cart.countTotal.toString(),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () => showAddDialogue(context),
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Consumer<Products>(
        builder: (context, products, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: products.count,
              itemBuilder: (BuildContext context, int index) {
                Product product = products.items[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) => deleteProduct(context, product),
                  child: Card(
                    child: ListTile(
                      onTap: () =>
                          Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(index: index),
                      )),
                      leading: IconButton(
                        onPressed: () => (),
                        icon: Icon(
                          product.isFav
                              ? Icons.favorite
                              : Icons.favorite_outline,
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        '${product.desc} - ${NumberFormat.currency(symbol: '₱').format(product.price)}',
                      ),
                      trailing: IconButton(
                        onPressed: () => addCartItem(context, product),
                        icon: Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showAddDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Description',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Price',
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
              onPressed: () => addProduct(context),
              child: Text('Add'),
            )
          ],
        );
      },
    );
  }

  void addProduct(BuildContext context) {
    if (nameCtrl.text.isNotEmpty &&
        descCtrl.text.isNotEmpty &&
        priceCtrl.text.isNotEmpty) {
      Provider.of<Products>(context, listen: false).add(
        Product(
          id: Provider.of<Products>(context, listen: false).newId,
          name: nameCtrl.text,
          desc: descCtrl.text,
          price: double.parse(priceCtrl.text),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void addCartItem(BuildContext context, Product product) {
    int quantity = 1;
    int index = -1;
    var cart = Provider.of<Cart>(context, listen: false).items;

    for (var i = 0; i < cart.length; i++) {
      if (cart[i].product.id == product.id) {
        quantity = cart[i].quantity + 1;
        index = i;
        break;
      }
    }

    if (index >= 0) {
      Provider.of<Cart>(context, listen: false).updateQuantity(index, quantity);
    } else {
      Provider.of<Cart>(context, listen: false).add(CartItem(product: product));
    }
  }

  void deleteProduct(BuildContext context, Product product) {
    Provider.of<Products>(context, listen: false).delete(product);
  }
}
