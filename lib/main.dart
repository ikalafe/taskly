import 'package:flutter/material.dart';
import 'package:taskly/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taskly",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(21, 21, 21, 1.0),
        // primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
