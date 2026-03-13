import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp_provider_realm/models/cart.dart';
import 'package:shoppingapp_provider_realm/models/product.dart';

class CartItemsScreen extends StatelessWidget {
  const CartItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, _) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index) {
                CartItem cartItem = cart.items[index];
                Product product = cartItem.product;
                int quantity = cartItem.quantity;
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) => deleteCartItem(context, cartItem),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        child: Text(quantity.toString()),
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        '${product.desc} - ${NumberFormat.currency(symbol: '₱').format(product.price)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => removeQuantity(context, cartItem),
                            icon: Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () => addQuantity(context, product),
                            icon: Icon(Icons.add),
                          ),
                        ],
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

  void deleteCartItem(BuildContext context, CartItem cartItem) {
    Provider.of<Cart>(context, listen: false).delete(cartItem);
  }

  void removeQuantity(BuildContext context, CartItem cartItem) {
    Product product = cartItem.product;
    int quantity = 0;
    int index = -1;
    var cart = Provider.of<Cart>(context, listen: false).items;
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].product.id == product.id) {
        quantity = cart[i].quantity - 1;
        index = i;
        break;
      }
    }
    if (quantity == 0) {
      Provider.of<Cart>(context, listen: false).delete(cartItem);
    } else {
      Provider.of<Cart>(context, listen: false).updateQuantity(index, quantity);
    }
  }

  void addQuantity(BuildContext context, Product product) {
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
    Provider.of<Cart>(context, listen: false).updateQuantity(index, quantity);
  }
}
