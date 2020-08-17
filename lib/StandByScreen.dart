import 'package:alcolpedia/MainScreen.dart';
import 'package:alcolpedia/loginScreen.dart';
import 'package:alcolpedia/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StandByScreen extends StatefulWidget {
  @override
  _StandByScreenState createState() => _StandByScreenState();
}

class _StandByScreenState extends State<StandByScreen> {
  
  String token = "";
  final storage = FlutterSecureStorage();
  
  Future<String> getToken() async {
    Future<String> jwt = storage.read(key: "token");  
    if(jwt == null) return "";
    return jwt;
  }
  
  Future<bool> verifyToken() async{
    String token = await getToken(); 
    http.Response response = await http.post(
        Uri.encodeFull(Settings().apiServer+'api/token/verify/'), 
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "token" : token,
          }
        ), 
    );

    final parsed = await json.decode(response.body).cast<String, dynamic>();
    if(parsed['token'] == token) {
      return true;
    }
    return false;
  }
  
  _loadToken() async {
    String jwt = await getToken();
    setState(() {
      token = (jwt ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: verifyToken(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if(snapshot.hasData == false) {
                return CircularProgressIndicator();
              }
              else if(snapshot.hasError) {
                  return LoginRequest();
              }
              else {
                if(snapshot.data == true) {
                  return MainScreen();
                }
                else {
                  return LoginRequest();
                }
              }
          },

        ),
      );
  }
}