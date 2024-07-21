import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/word_book.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 清空所有状态

    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.blue,
        middle: Text("Home"),
        border: null, // 去掉导航栏下面的分隔线
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.bolt,
                  color: Colors.white,
                ),
                onPressed: () => {Navigator.pushNamed(context, '/rank')},
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.chart_bar,
                  color: Colors.white,
                ),
                onPressed: () => {Navigator.pushNamed(context, '/rank')},
              ),
            ],
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () => _logout(context),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  CupertinoIcons.search,
                  color: Colors.white,
                ),
                onPressed: () => {Navigator.pushNamed(context, '/search')},
              ),
            ],
          ),
        ),
      ),
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            children: [
              Container(
                height: 600, // 固定高度
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
                child: WordBook(),
              ),
              Container(
                width: double.infinity,
                color: Colors.blue, // 保持背景色一致
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu_book, color: Colors.white),
                      onPressed: () {
                        // 处理单词本按钮点击事件
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Colors.white),
                      onPressed: () {
                        // 处理个人中心按钮点击事件
                        Navigator.pushNamed(context, '/user');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
