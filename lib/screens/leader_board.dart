import 'package:flutter/cupertino.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("排行榜"),
      ),
      child: Center(
        child: Text("排行榜内容"),
      ),
    );
  }
}
