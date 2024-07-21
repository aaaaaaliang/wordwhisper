import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/front/home/search'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'query': _searchController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));

      // Check if the 'data' key exists and contains 'answer'
      if (responseData.containsKey('data') &&
          responseData['data'] is Map &&
          responseData['data'].containsKey('answer')) {
        final String answer = responseData['data']['answer'];
        setState(() {
          _searchResults = [answer];
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults = ['Error: Unexpected data format'];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _searchResults = ['Error: ${response.reasonPhrase}'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('搜索页面'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                controller: _searchController,
                placeholder: '输入你想查询的内容',
                onSubmitted: (String value) {
                  _performSearch();
                },
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(_searchResults[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
