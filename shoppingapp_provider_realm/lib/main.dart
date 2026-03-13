import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp_provider_realm/models/cart.dart';
import 'package:shoppingapp_provider_realm/models/number.dart';
import 'package:shoppingapp_provider_realm/models/product.dart';
import 'package:shoppingapp_provider_realm/screens/count_screen.dart';
import 'package:shoppingapp_provider_realm/screens/products_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Number())
      ],
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: CountScreen(),
        );
      },
    );
  }
}
