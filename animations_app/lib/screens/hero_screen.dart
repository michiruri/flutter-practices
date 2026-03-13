import 'package:flutter/material.dart';

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key, required this.n});

  final int n;

  @override
  State<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hero Screen')),
      body: Center(
        child: Hero(
          tag: 'FlutterLogo-${widget.n}',
          child: FlutterLogo(size: MediaQuery.of(context).size.width),
        ),
      ),
    );
  }
}
