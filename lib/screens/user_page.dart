import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  String name = '张雪亮';
  String major = '计算机科学与技术';
  String email = 'zhangxueliang@example.com';
  String phone = '123-456-7890';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void updateProfile() {
    setState(() {
      name = nameController.text;
      major = majorController.text;
      email = emailController.text;
      phone = phoneController.text;
    });
    Navigator.pop(context);
  }

  void showEditDialog() {
    nameController.text = name;
    majorController.text = major;
    emailController.text = email;
    phoneController.text = phone;

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('编辑个人信息'),
          content: Column(
            children: [
              CupertinoTextField(
                controller: nameController,
                placeholder: '姓名',
              ),
              CupertinoTextField(
                controller: majorController,
                placeholder: '专业',
              ),
              CupertinoTextField(
                controller: emailController,
                placeholder: '邮箱',
              ),
              CupertinoTextField(
                controller: phoneController,
                placeholder: '电话',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text('保存'),
              onPressed: updateProfile,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.school, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  major,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  email,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  phone,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: CupertinoButton(
                color: Colors.blue,
                child: Text('编辑'),
                onPressed: showEditDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('个人中心'),
        backgroundColor: Colors.blue,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserProfileCard(),
          ],
        ),
      ),
    );
  }
}
