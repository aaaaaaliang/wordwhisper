import 'package:flutter/cupertino.dart';

import './screens/login_page.dart';
import './screens/home_page.dart';
import './screens/recite_page.dart';
import './screens/user_page.dart';
import './screens/leader_board.dart';
import './screens/search_page.dart';
import './screens//plan_page.dart';

bool isLoggedIn = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: "Word Whisper",
      theme: CupertinoThemeData(
        primaryColor: Color.fromARGB(255, 22, 129, 175),
      ),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/recite': (context) => const RecitePage(),
        '/user': (context) => const UserPage(),
        '/rank': (context) => const LeaderboardPage(),
        '/search': (context) => const SearchPage(),
        '/plan': (context) => const PlanPage(),
      },
    );
  }
}
