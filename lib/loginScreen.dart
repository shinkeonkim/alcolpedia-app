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
  TextEditingController _controller;
  MemberData user;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
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
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (String value) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thanks!'),
                          content: Text('You typed "$value".'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (String value) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thanks!'),
                          content: Text('You typed "$value".'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              RaisedButton(
                child: Text('로그인'),
                onPressed: loginRequest,
              ),
              Text(
                "회원가입을 아직 안하셨나요? 회원가입"
              )
            ],
          ) 
        ),
      ),

    );
  }

}