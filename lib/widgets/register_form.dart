import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = '';
  bool __obscurePassword = true;

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = '密码和确认密码不匹配';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/front/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    final responseData = jsonDecode(response.body);
    // responseData["code"]==0
    if (response.statusCode == 200 && responseData['code'] == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = responseData['message'] ?? '注册失败';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("注册"),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 350,
          height: 450,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.person, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _usernameController,
                      placeholder: "用户名",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(CupertinoIcons.lock, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _passwordController,
                      placeholder: "密码",
                      obscureText: __obscurePassword,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(CupertinoIcons.lock, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: _confirmPasswordController,
                      placeholder: "确认密码",
                      obscureText: __obscurePassword,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              CupertinoButton(
                color: Colors.blue,
                child: Text("注册"),
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
