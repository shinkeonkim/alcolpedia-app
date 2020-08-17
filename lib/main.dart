import 'package:alcolpedia/StandByScreen.dart';
import 'package:flutter/material.dart';
import 'package:alcolpedia/registerScreen.dart';
import 'package:alcolpedia/loginScreen.dart';
import 'package:alcolpedia/MainScreen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Alcolpedia());
}

class Alcolpedia extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alcolpedia',
      initialRoute: "/",
      routes: {
        "/" : (context) => StandByScreen(),
        "/login" : (context) => LoginRequest(),
        "/register": (context) => RegisterRequest(),
        "/standby": (context) => StandByScreen(),
        "/main": (context) => MainScreen(),
      },
    );
  }
}