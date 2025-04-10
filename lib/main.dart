import 'package:flutter/material.dart';
import 'about_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(), // Start on HomePage
      routes: {
        '/about': (context) => AboutPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
