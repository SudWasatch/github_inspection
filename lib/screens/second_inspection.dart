import 'package:flutter/material.dart';

class SecondInspection extends StatefulWidget {
  const SecondInspection({super.key});

  @override
  State<SecondInspection> createState() => _SecondInspectionState();
}

class _SecondInspectionState extends State<SecondInspection>
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