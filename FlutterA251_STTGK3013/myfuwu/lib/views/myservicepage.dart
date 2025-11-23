import 'package:flutter/material.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/shared/mydrawer.dart';

class MyServicePage extends StatefulWidget {
  final User? user;

  const MyServicePage({super.key, this.user});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Service Page')),
      body: Center(child: Text('My Service Page')),
      drawer: MyDrawer(user: widget.user),
    );
  }
}
