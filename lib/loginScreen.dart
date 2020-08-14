import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MemberData {
  String username = "";
  String password = "";
  String tocken = "";
}

class LoginRequest extends StatefulWidget {
  @override

  _LoginRequestState createState() =>  _LoginRequestState();
}

class _LoginRequestState extends State<LoginRequest> {
  TextEditingController _usernameTextFieldController;
  TextEditingController _passwordTextFieldController;
  MemberData user;

  void initState() {
    super.initState();
    _usernameTextFieldController = TextEditingController();
    _passwordTextFieldController = TextEditingController();
  }

  void dispose() {
    _usernameTextFieldController.dispose();
    _passwordTextFieldController.dispose();
    super.dispose();
  }

  Future<String> loginRequest() async {
    http.Response response = await http.post(
      Uri.encodeFull('http://server.server/api/token/'), 
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
        "username": "singun119",
        "password": "1234"
        }
      ), 
    );
    print(response.body);
    // List data = jsonDecode(response.body);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.grey[800],
      body: Center(
        child: SafeArea(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _usernameTextFieldController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: SizedBox(
                      width: 150,
                      child: TextField(
                        obscureText: true,
                        controller: _passwordTextFieldController,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('로그인'),
                    onPressed: loginRequest,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text(
                        "회원가입을 아직 안하셨나요? 회원가입",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ) 
            ),
          )
        ),
      ),
    );
  }

}