import 'package:flutter/material.dart';

class Amenities extends StatefulWidget {
  const Amenities({super.key});

  @override
  State<Amenities> createState() => _AmenitiesState();
}

class _AmenitiesState extends State<Amenities>
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