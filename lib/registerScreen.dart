import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MemberData {
  String username = "";
  String password = "";
  String tocken = "";
}

class RegisterRequest extends StatefulWidget {
  @override
  _RegisterRequestState createState() =>  _RegisterRequestState();
}

class _RegisterRequestState extends State<RegisterRequest> {

  Future<String> registerRequest() async {
    http.Response response = await http.get(
      Uri.encodeFull('http://jsonplaceholder.typicode.com/posts'), 
      headers: {"Accept": "application/json"}
    );
    print(response.body);
    List data = jsonDecode(response.body);
    print("--------");
    print(data[1]['title']);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: '아이디를 입력해주세요.'
            //   ),
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: '비밀번호를 입력해주세요.'
            //   ),
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: '비밀번호를 한번 더 입력해주세요.'
            //   ),
            // ),
            RaisedButton(
              child: Text('회원가입'),
              onPressed: registerRequest,
            ),
            Text(
              "회원가입을 아직 안하셨나요? 회원가입"
            )
          ],
        ),
      ),

    );
  }

}