import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecitePage extends StatelessWidget {
  const RecitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.blue,
      navigationBar: CupertinoNavigationBar(
        middle: Text('加油 你一定行的！！！！'),
        backgroundColor: Colors.blue,
        border: null,
      ),
      child: ReciteWidget(),
    );
  }
}

class ReciteWidget extends StatefulWidget {
  const ReciteWidget({super.key});

  @override
  State<ReciteWidget> createState() => _ReciteWidgetState();
}

class _ReciteWidgetState extends State<ReciteWidget> {
  int _counter = 0;
  bool _showMeaning = false;
  List<Map<String, String>> _words = [];

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  Future<void> _fetchWords() async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getString('lastId') ?? '0';
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getString('userId') ?? '';

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/front/home/getWords'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'lastId': lastId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseData['code'] == 0) {
        final List<dynamic> data = responseData['data']['data'];
        setState(() {
          _words = data
              .map((item) => {
                    'english': item['english'].toString(),
                    'chinese': item['chinese'].toString(),
                  })
              .toList();
        });
      } else {
        setState(() {
          _words = [];
          print('Error: ${responseData['message']}');
        });
      }
    } else {
      setState(() {
        // 请求失败处理
        _words = [];
        print('Error: ${response.statusCode}');
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < _words.length - 1) {
        _counter++;
        _showMeaning = false;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _showMeaning = false;
      }
    });
  }

  void _toggleMeaning() {
    setState(() {
      _showMeaning = !_showMeaning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          // 检测手势事件
          child: GestureDetector(
            onTap: _incrementCounter,
            child: Container(
              width: 350,
              height: 350,
              margin: EdgeInsets.only(bottom: 280),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _words.isNotEmpty ? _words[_counter]['english']! : '',
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    if (_showMeaning)
                      Text(
                        _words.isNotEmpty ? _words[_counter]['chinese']! : '',
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        print('Correct');
                      },
                      child: Icon(
                        CupertinoIcons.check_mark,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: _toggleMeaning,
                      child: Icon(
                        CupertinoIcons.info,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        print('Incorrect');
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // 调整按钮之间的间距
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                      onPressed: _decrementCounter,
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    CupertinoButton(
                      onPressed: _incrementCounter,
                      child: Icon(
                        CupertinoIcons.chevron_forward,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
