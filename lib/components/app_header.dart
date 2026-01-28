import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("assets/img.png", scale: 3),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Inspection \n Mobile-App",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
              letterSpacing: 1.0,
              wordSpacing: 2.0,
              shadows: [
                Shadow(color: Colors.grey, offset: Offset(2, 2), blurRadius: 5),
              ],
            ),
          ),
        ),
        Container(
          height: 5.0,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}