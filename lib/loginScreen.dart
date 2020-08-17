import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:alcolpedia/settings.dart';

class MemberData {
  String username = '';
  String email = '';
  String password = '';
}

class Member {
  final String token;
  final List email;
  final List username;
  final List password;


  Member ({this.token, this.email, this.username, this.password});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      token: json['token'] as String,
      email: json['email'] as List,
      username: json['username'] as List,
      password: json['password1'] as List,

    );
  }
}


class LoginRequest extends StatefulWidget {
  const LoginRequest({Key key}) : super(key: key);

  @override
  _LoginRequestState createState() => _LoginRequestState();
}


class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.controller,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      key: widget.fieldKey,
      obscureText: _obscureText,
      cursorColor: Theme.of(context).cursorColor,
      maxLength: 20,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            // semanticLabel: _obscureText
            //     ? GalleryLocalizations.of(context)
            //         .demoTextFieldShowPasswordLabel
            //     : GalleryLocalizations.of(context)
            //         .demoTextFieldHidePasswordLabel,
          ),
        ),
      ),
    );
  }
}

class _LoginRequestState extends State<LoginRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  MemberData person = MemberData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  // Autovalidate _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  Member fetchMember(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return Member.fromJson(parsed);
  }


  void _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
    //   _autoValidateMode =
    //       AutovalidateMode.always; // Start validating on every change.
      showInSnackBar(
        "내용을 올바르게 작성해주세요.",
      );
      return;
    } 
    form.save();
    http.Response response = await http.post(
      Uri.encodeFull(Settings().apiServer+'rest-auth/login/'), 
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
          "email" : _emailController.text,
          "username": _usernameController.text,
          "password": person.password,
        }
      ), 
    );

    print(response.body);

    Member ret = fetchMember(response.body);

    if(ret.token == null || ret.token == "") {
      if(ret.email != null) {
        Fluttertoast.showToast(msg: ret.email[0]);
      }
      else if(ret.username != null) {
        Fluttertoast.showToast(msg: ret.username[0]);
      }
      else if(ret.password != null) {
        Fluttertoast.showToast(msg: ret.password[0]);
      }
    }
    else {
      print("success...");
      final storage = FlutterSecureStorage();
      storage.write(key: "token", value: ret.token);
      Navigator.popAndPushNamed(context, "/main");
    }
    return;
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "유저명을 입력해주세요.";
    }
    return null;
  }

  String _validatePassword(String value) {
    final passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty) {
      return "비밀번호를 입력해주세요.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 20);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 300,
            height: 400,
            child: Card(
              child: Form(
                key: _formKey,
                // autovalidate: _autoValidateMode,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.down,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sizedBoxSpace,
                        TextFormField(
                          controller: _usernameController,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                            filled: true,
                            icon: const Icon(Icons.person),
                            hintText: "유저명",
                            labelText: "유저명",
                          ),
                          onSaved: (value) {
                            person.username = value;
                          },
                          onChanged: (value) {
                            person.username = value;
                          },
                          validator: _validateName,
                        ),
                        sizedBoxSpace,
                        TextFormField(
                          controller: _emailController,
                          cursorColor: cursorColor,
                          decoration: InputDecoration(
                            filled: true,
                            icon: const Icon(Icons.email),
                            hintText: "이메일 주소",
                            labelText:"이메일",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            person.email = value;
                          },
                          onChanged: (value) {
                            person.email = value;
                          },
                        ),
                        sizedBoxSpace,
                        PasswordField(
                          controller: _passwordController,
                          fieldKey: _passwordFieldKey,
                          helperText: "",
                          labelText: "비밀번호",
                          onFieldSubmitted: (value) {
                            setState(() {
                              person.password = value;
                            });
                          },
                          validator: _validatePassword,
                        ),
                        sizedBoxSpace,
                        Center(
                          child: RaisedButton(
                            child: Text("제출"),
                            onPressed: _handleSubmitted,
                          ),
                        ),
                        sizedBoxSpace,
                        Padding(
                            padding: const EdgeInsets.all(2),
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}