import 'package:flutter/material.dart';

class ThirdInspection extends StatefulWidget {
  const ThirdInspection({super.key});

  @override
  State<ThirdInspection> createState() => _ThirdInspectionState();
}

class _ThirdInspectionState extends State<ThirdInspection>
    with SingleTickerProviderStateMixin {
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
    return const Placeholder();
  }
}