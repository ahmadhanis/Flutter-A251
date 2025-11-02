import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/views/mainpage.dart';
import 'package:myfuwu/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autologin();
    // Future.delayed(Duration(seconds: 3), () {
    //   if (!mounted) return;
    //   User user = User(userId: '0', userEmail: 'guest@email.com',   userPassword: 'guest', userOtp: '0000', userRegdate: '0000-00-00');
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => MainPage(user: user)),
    //   );
    // });
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http
            .post(
              Uri.parse(
                '${MyConfig.baseUrl}/myfuwu/api/login.php',
              ),
              body: {'email': email, 'password': password},
            )
            .then((response) {
              if (response.statusCode == 200) {
                var jsonResponse = response.body;
                // print(jsonResponse);
                var resarray = jsonDecode(jsonResponse);
                if (resarray['status'] == 'success') {
                  //print(resarray['data'][0]);
                  User user = User.fromJson(resarray['data'][0]);
                  if (!mounted) return;
                  Future.delayed(Duration(seconds: 2), () {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(user: user),
                      ),
                    );
                  });
                } else {
                  Future.delayed(Duration(seconds: 3), () {
                    if (!mounted) return;
                    User user = User(
                      userId: '0',
                      userEmail: 'guest@email.com',
                      userPassword: 'guest',
                      userOtp: '0000',
                      userRegdate: '0000-00-00',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(user: user),
                      ),
                    );
                  });
                }
              } else {
                Future.delayed(Duration(seconds: 3), () {
                  if (!mounted) return;
                  User user = User(
                    userId: '0',
                    userEmail: 'guest@email.com',
                    userPassword: 'guest',
                    userOtp: '0000',
                    userRegdate: '0000-00-00',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(user: user),
                    ),
                  );
                });
              }
            });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          if (!mounted) return;
          User user = User(
            userId: '0',
            userEmail: 'guest@email.com',
            userPassword: 'guest',
            userOtp: '0000',
            userRegdate: '0000-00-00',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage(user: user)),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/myfuwu.png', scale: 3),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
