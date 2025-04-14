import 'package:connectfront/pages/home.dart';
import 'package:connectfront/pages/login.dart';
import 'package:connectfront/pages/register.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => Register(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
      },
    );
  }
}