import 'dart:math';

import 'package:animations_app/main.dart';
import 'package:animations_app/screens/hero_screen.dart';
import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  Widget? mainChild;
  Widget child1 = Container(
    key: UniqueKey(),
    width: 200,
    height: 200,
    color: Colors.blue,
    alignment: Alignment.center,
    child: Text(
      'Tap me to see a surprise',
      style: TextStyle(color: Colors.white),
    ),
  );
  Widget child2 = Text(key: UniqueKey(), 'Surprise!');
  bool isTapped = false;

  Random rand = Random();
  double width = 0;
  double height = 0;
  double top = 0;
  double right = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainChild = child1;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 32;
    width = MediaQuery.of(context).size.width - 32;
    return Scaffold(
      appBar: AppBar(title: Text('Implicit Animations')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: isTapped ? top : 132,
              right: isTapped ? right : null,
              child: SizedBox(
                width: width,
                child: ElevatedButton(
                  onPressed: () {
                    isTapped = true;
                    do {
                      double randTop = rand.nextDouble() * height;
                      double randRight = rand.nextDouble() * width;
                      top = randTop;
                      right = randRight;
                    } while (top > 32 &&
                        top < height - 64 &&
                        right > 32 &&
                        right < width - 64);
                    setState(() {});
                  },
                  child: Text('Login'),
                ),
              ),
            ),
          ],
        ),
      ),
      // body: GestureDetector(
      //   onTap: () {
      //     isTapped = !isTapped;
      //     setState(() {});
      //   },
      //   child: Stack(
      //     children: [
      //       Center(child: Text('Surprise!!!')),
      //       AnimatedPositioned(
      //         top: isTapped ? 0 : MediaQuery.of(context).size.height / 3,
      //         right: MediaQuery.of(context).size.width / 2 - 100,
      //         duration: Duration(seconds: 1),
      //         child: AnimatedOpacity(
      //           opacity: isTapped ? 0 : 1,
      //           duration: Duration(seconds: 1),
      //           child: AnimatedRotation(
      //             turns: isTapped ? 10 : 0,
      //             duration: Duration(seconds: 1),
      //             child: Container(
      //               width: 200,
      //               height: 200,
      //               color: Colors.blue,
      //               alignment: Alignment.center,
      //               child: Text(
      //                 'Tap for a surprise',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // body: ListView.builder(
      //   itemCount: 5,
      //   itemBuilder: (context, index) {
      //     int n = index + 1;
      //     return Card(
      //       child: ListTile(
      //         onTap:
      //             () => Navigator.of(context).push(
      //               MaterialPageRoute(builder: (context) => HeroScreen(n: n)),
      //             ),
      //         leading: Hero(tag: 'FlutterLogo-$n', child: FlutterLogo()),
      //         title: Text(n.toString()),
      //       ),
      //     );
      //   },
      // ),
      // body: GestureDetector(
      //   onTap: () {
      //     isTapped = !isTapped;
      //     mainChild = isTapped ? child1 : child2;
      //     setState(() {});
      //   },
      //   child: Center(
      //     child: AnimatedSwitcher(
      //       duration: Duration(seconds: 1),
      //       child: mainChild,
      //     ),
      //   ),
      // ),
      // body: GestureDetector(
      //   onTap:
      //       () => setState(() {
      //         isTapped = !isTapped;
      //       }),
      //   child: AnimatedContainer(
      //     duration: Duration(milliseconds: 500),
      //     curve: Curves.linear,
      //     height: 200,
      //     width: 200,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(isTapped ? 100 : 0),
      //       color: isTapped ? Colors.blue : Colors.red,
      //     ),
      //   ),
      // ),
    );
  }
}
