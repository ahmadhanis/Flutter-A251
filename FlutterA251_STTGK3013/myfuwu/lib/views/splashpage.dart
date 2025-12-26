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
              Uri.parse('${MyConfig.baseUrl}/myfuwu/api/login.php'),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1F3C88), Color(0xFF2EC4B6)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // APP ICON
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.handyman_outlined,
                size: 60,
                color: Color(0xFF1F3C88),
              ),
            ),

            const SizedBox(height: 24),

            // APP NAME
            const Text(
              "MyFuWu",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // TAGLINE
            const Text(
              "Local Services, In Hand",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // LOADING INDICATOR
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
