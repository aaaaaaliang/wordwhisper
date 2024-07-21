import 'package:flutter/cupertino.dart';
import '../widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.blue,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Word Whisper'),
      ),
      child: const LoginForm(),
    );
  }
}
