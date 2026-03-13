import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp_provider_realm/models/number.dart';

class CountScreen extends StatelessWidget {
  CountScreen({super.key});

  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Consumer<Number>(
      builder: (context, number, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number.counter.toString(),
                    style: TextStyle(
                      color: number.counter == 0
                          ? Colors.black
                          : number.counter > 0
                              ? Colors.red
                              : Colors.yellow,
                      fontSize: 128,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Provider.of<Number>(context, listen: false)
                                  .decrement(number),
                          child: Icon(Icons.remove),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Provider.of<Number>(context, listen: false)
                                  .increment(number),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class fbnfhf extends StatelessWidget {
  const fbnfhf({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Number>(builder: (context, value, child) {
      return Scaffold(
        body: Column(
          children: [
            Text(value.counter.toString()),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Provider.of<Number>(context, listen: false)
                      .decrement(value),
                  child: Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () => (),
                  child: Icon(Icons.remove),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
