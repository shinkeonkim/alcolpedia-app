import 'package:flutter/material.dart';
import 'package:alcolpedia/registerScreen.dart';
import 'package:alcolpedia/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alcolpedia',
      initialRoute: "/",
      routes: {
        "/" : (context) => LoginRequest(),
        // "/login" : (context) => Loginrequest(),
      },
    );
  }
}