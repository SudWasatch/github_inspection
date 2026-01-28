import 'package:flutter/material.dart';
import 'package:github_inspection/providers/providers.dart';
import 'package:github_inspection/screens/first_inspection.dart';
import 'package:github_inspection/screens/home_screen.dart';
import 'package:github_inspection/screens/login_screen.dart';
import 'package:github_inspection/screens/main_screen.dart';
import 'package:github_inspection/screens/spalsh_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ALLInspectionProvider()),
        ChangeNotifierProvider(create: (context) => InspectionProvider()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => LatProvider()),
        ChangeNotifierProvider(create: (context) => LongProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final latProvider = context.read<LatProvider>();
            final longProvider = context.read<LongProvider>();
            return LocationProvider(
              latProvider: latProvider,
              longProvider: longProvider,
            );
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/ls': (BuildContext context) => const LoginScreen(),
        '/gs': (BuildContext context) => const MainScreen(),
        '/hs': (BuildContext context) => const HomeScreen(),
        '/fi': (BuildContext context) => const FirstInspection(),
      },
    );
  }
}
