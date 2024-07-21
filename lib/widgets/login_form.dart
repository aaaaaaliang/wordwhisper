import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './register_form.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _errorMessage = '';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/front/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['code'] == 0) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'userId', responseData['data']['userId'].toString());
      await prefs.setString('token', responseData['data']['token']);
      Navigator.pushReplacementNamed(context, '/home'); //没有返回
    } else {
      setState(() {
        _errorMessage = responseData['message'] ?? '注册失败';
      });
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RegisterForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 350,
        height: 400,
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
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CupertinoTextField(
                        controller: _passwordController,
                        placeholder: "密码",
                        obscureText: _obscurePassword,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.only(right: 10),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Icon(
                          _obscurePassword
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash,
                          size: 20,
                        ),
                      ),
                    ],
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
              child: Text("登录"),
              onPressed: _login,
            ),
            SizedBox(height: 20),
            CupertinoButton(
              child: Text("还没有帐号？立即注册"),
              onPressed: _navigateToRegister,
            ),
          ],
        ),
      ),
    );
  }
}
