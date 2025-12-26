import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfuwu/myconfig.dart';
import 'package:myfuwu/views/mainpage.dart';
import 'package:myfuwu/models/user.dart';
import 'package:myfuwu/views/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late double height, width;
  bool visible = true;
  bool isChecked = false;

  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final maxWidth = screenWidth > 420 ? 420.0 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1F3C88),
        title: const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TITLE
                    const Text(
                      "Welcome Back 👋",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue using MyFuwu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // EMAIL
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // PASSWORD
                    TextField(
                      controller: passwordController,
                      obscureText: visible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            visible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => visible = !visible);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // REMEMBER ME
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() => isChecked = value!);
                            prefUpdate(isChecked);
                          },
                        ),
                        const Text("Remember me"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Forgot password
                          },
                          child: const Text("Forgot password?"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // LOGIN BUTTON
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F3C88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: loginuser,
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F3C88),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Just Browsing? "),
                        GestureDetector(
                          onTap: () {
                            User user = User(
                              userId: '0',
                              userEmail: 'guest@email.com',
                              userPassword: 'guest',
                              userOtp: '0000',
                              userRegdate: '0000-00-00',
                              userName: 'Guest',
                              userPhone: '0000000000',
                              userCredit: 0,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(user: user),
                              ),
                            );
                          },
                          child: const Text(
                            "Go Home",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F3C88),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void loginuser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/myfuwu/api/login.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          log(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            log(jsonResponse);
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              //print(resarray['data'][0]);
              user = User.fromJson(resarray['data'][0]);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  // backgroundColor: Colors.green,
                ),
              );
              // Navigator.pop(context);
              // Navigate to home page or dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // Handle successful login here
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
