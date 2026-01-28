import 'package:flutter/material.dart';

class Screeen extends StatefulWidget {
  const Screeen({super.key});

  @override
  State<Screeen> createState() => _ScreeenState();
}

class _ScreeenState extends State<Screeen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: const Text("you are on Screen page"));
  }
}
