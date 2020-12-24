// Imports
import 'package:flutter/material.dart';
import 'cidade/cidades.dart';

// Main function - runs the app
void main() => runApp(MyApp());

/*
  MyApp - Main application
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Municípios de SP',
      home: Cidades(),
      theme: ThemeData(
        primaryColor: Color.fromRGBO(33, 33, 37, 1.0),
        dividerColor: Color.fromRGBO(41, 66, 146, 1.0),
      ),
    );
  }
}
