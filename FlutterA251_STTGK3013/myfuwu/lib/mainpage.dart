import 'package:flutter/material.dart';
import 'package:myfuwu/loginpage.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/registerpage.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(
        child: Column(
          children: [
            Text('User ID: ${widget.user?.userId}'),
            Text('User Email: ${widget.user?.userEmail}'),
            Text('User Password: ${widget.user?.userPassword}'),
            Text('User OTP: ${widget.user?.userOtp}'),
            Text('User Regdate: ${widget.user?.userRegdate}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the button
          if (widget.user?.userId == '0') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please login first/or register first"),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
