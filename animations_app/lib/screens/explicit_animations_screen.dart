import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationController2;
  bool isTapped = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explicit Animations'),
        actions: [
          IconButton(
            onPressed: () {
              if (isTapped) {
                animationController.reset();
                animationController2.reset();
              } else {
                animationController.forward().then(
                  (value) => animationController2.forward().then(
                    (value) => animationController2.reverse().then((value) {
                      animationController.reset();
                      animationController2.reset();
                      isTapped = false;
                      setState(() {});
                    }),
                  ),
                );
              }
              isTapped = !isTapped;
              setState(() {});
            },
            icon: Icon(isTapped ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return RotationTransition(
            turns: Tween<double>(begin: 0, end: 10).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.linear,
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 1,
                end: 0,
              ).animate(animationController2),
              child: child,
            ),
          );
        },
        child: Center(
          child: FlutterLogo(size: MediaQuery.of(context).size.width / 2),
        ),
      ),
    );
  }
}
