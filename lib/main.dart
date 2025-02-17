import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/ima ges/image1.png',
            fit: BoxFit.cover, // Заполняет весь экран
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
