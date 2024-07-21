import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WordBook extends StatefulWidget {
  const WordBook({super.key});

  @override
  State<WordBook> createState() => _WordBookState();
}

class _WordBookState extends State<WordBook> {
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');
    if (token != null && userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost:8000/api/front/home'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
            'userId': userId,
          },
        );
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['code'] == 0) {
          await prefs.setString(
              'wordsToLearn', responseData['data']['wordsToLearn'].toString());
          await prefs.setString('wordsToReview',
              responseData['data']['wordsToReview'].toString());
          await prefs.setString(
              'lastId', responseData['data']['lastId'].toString());
          setState(() {
            _errorMessage = '';
          });
        } else {
          setState(() {
            _errorMessage = '请求失败: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = '请求失败: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = '没有找到token或userId';
      });
    }
  }

  Future<Map<String, String>> _getWordCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final wordsToLearn = prefs.getString('wordsToLearn') ?? '15';
    final wordsToReview = prefs.getString('wordsToReview') ?? '0';
    final lastId = prefs.getString('lastId') ?? '1';
    return {
      'wordsToLearn': wordsToLearn,
      'wordsToReview': wordsToReview,
      'lastId': lastId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        FutureBuilder<Map<String, String>>(
          future: _getWordCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('加载数据失败');
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Text('没有数据');
            }

            final wordsToLearn = snapshot.data!['wordsToLearn'];
            final wordsToReview = snapshot.data!['wordsToReview'];
            // final lastId = snapshot.data!['lastId'];

            return Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Icon(
                          Icons.menu_book,
                          size: 80,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Row(
                                    children: [
                                      Text(
                                        "四级词汇大全",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "修改",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200,
                                          color:
                                              Color.fromARGB(255, 63, 63, 63),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    // 点击事件处理
                                    print("Button Pressed");
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 8.0, left: 20), // 添加一点上边距
                            width: 200, // 设置固定宽度
                            child: Column(
                              children: [
                                LinearProgressIndicator(
                                  value: 15 / 4440, // 当前进度值
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.blue,
                                  minHeight: 5,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "15 / 4440",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "今日计划",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "需新学",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          Text(
                            "需复习",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "$wordsToLearn 词",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          Text(
                            "$wordsToReview 词",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: CupertinoButton(
                    color: Colors.blue,
                    child: Text(
                      "开始背单词吧！",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/recite');
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
