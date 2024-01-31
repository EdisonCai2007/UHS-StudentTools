import 'package:flutter/material.dart';
import 'HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home Screen ABC",
      home: HomeScreen(),
    );
  }
}