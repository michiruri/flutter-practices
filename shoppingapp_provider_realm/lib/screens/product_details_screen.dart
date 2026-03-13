import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp_provider_realm/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (context, products, _) {
        Product product = products.items[index];
        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            actions: [
              IconButton(
                onPressed: () => toggleIsFav(context, product),
                icon: Icon(
                  product.isFav ? Icons.favorite : Icons.favorite_outline,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(product.desc),
                trailing: Text(
                  NumberFormat.currency(symbol: '₱').format(product.price),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  toggleIsFav(BuildContext context, Product product) {
    Provider.of<Products>(context, listen: false).toggleIsFav(product);
  }
}
