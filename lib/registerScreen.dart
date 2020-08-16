import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MemberData {
  String username = '';
  String email = '';
  String password1 = '';
  String password2 = '';
}

class Member {
  final String token;
  final List email;
  final List username;
  final List password1;
  final List password2;


  Member ({this.token, this.email, this.username, this.password1, this.password2});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      token: json['token'] as String,
      email: json['email'] as List,
      username: json['username'] as List,
      password1: json['password1'] as List,
      password2: json['password2'] as List,

    );
  }
}


class RegisterRequest extends StatefulWidget {
  const RegisterRequest({Key key}) : super(key: key);

  @override
  _RegisterRequestState createState() => _RegisterRequestState();
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

class _RegisterRequestState extends State<RegisterRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

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
      Uri.encodeFull('http://6f0a909d2095.ngrok.io/rest-auth/registration/'), 
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
          "email" : person.email,
          "username": person.username,
          "password1": person.password1,
          "password2": person.password2,
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
      else if(ret.password1 != null) {
        Fluttertoast.showToast(msg: ret.password1[0]);
      }
      else if(ret.password2 != null) {
        Fluttertoast.showToast(msg: ret.password2[0]);
      }
    }
    else {
      
    }
    print(ret.token);
    print(ret.email);
    print(ret.username);
    print(ret.password1);
    print(ret.password2);
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
    if (passwordField.value != value) {
      return "비밀번호가 서로 다릅니다.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cursorColor = Theme.of(context).cursorColor;
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        // autovalidate: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                ),
                sizedBoxSpace,
                PasswordField(
                  controller: _password1Controller,
                  fieldKey: _passwordFieldKey,
                  helperText: "",
                  labelText: "비밀번호",
                  onFieldSubmitted: (value) {
                    setState(() {
                      person.password1 = value;
                    });
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  controller: _password2Controller,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "비밀번호 확인",
                  ),
                  maxLength: 20,
                  obscureText: true,
                  validator: _validatePassword,
                  onFieldSubmitted: (value) {
                    setState(() {
                      person.password2 = value;
                    });
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: RaisedButton(
                    child: Text("제출"),
                    onPressed: _handleSubmitted,
                  ),
                ),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}