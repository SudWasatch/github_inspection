import 'package:flutter/material.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:provider/provider.dart';

class ThemeStateApp extends StatefulWidget {
  const ThemeStateApp({super.key});

  @override
  State<ThemeStateApp> createState() => _ThemeStateAppState();
}

class _ThemeStateAppState extends State<ThemeStateApp> {
  bool _isToggled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isToggled ? Icons.nightlight : Icons.wb_sunny_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        setState(() {
          _isToggled = !_isToggled;
        });
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    );
  }
}
