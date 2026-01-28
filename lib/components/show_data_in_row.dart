import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDataInRow extends StatefulWidget {
  final String str1;
  final String str2;
  const ShowDataInRow({super.key, required this.str1, required this.str2});

  @override
  State<ShowDataInRow> createState() => _ShowDataInRowState();
}

class _ShowDataInRowState extends State<ShowDataInRow>
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              widget.str1,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: Text(
              ':',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              widget.str2.toUpperCase(),
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
