import 'package:flutter/cupertino.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("计划书"),
      ),
      child: Center(
        child: Text("计划内容"),
      ),
    );
  }
}
