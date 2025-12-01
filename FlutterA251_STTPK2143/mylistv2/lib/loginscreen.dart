import 'package:flutter/material.dart';
import 'package:mylistv2/mainscreen.dart';
import 'package:mylistv2/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  bool passwordvisible = false;
  bool isCheck = false;
  String password = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: passwordController,
                obscureText: passwordvisible,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordvisible = !passwordvisible;
                      });
                    },
                    icon: Icon(
                      passwordvisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                  labelText: "Password",
                  hintText: "Enter Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Remember Me'),
                  Spacer(),
                  Checkbox(
                    value: isCheck,
                    onChanged: (value) async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (value == true) {
                        password = passwordController.text;
                        if (password.isEmpty || password.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please set password first!"),
                            ),
                          );
                          return;
                        }
                        prefs.setBool('remember', true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Preference saved!")),
                        );
                      } else {
                        prefs.setBool('remember', false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Preference removed!")),
                        );
                        password = "";
                        passwordController.text = "";
                        setState(() {});
                      }
                      setState(() {
                        isCheck = value!;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (password == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please set password first!"),
                      ),
                    );
                    return;
                  }
                  if (passwordController.text == password) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Wrong password!")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Login"),
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text("Set Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    password = prefs.getString('password') ?? '';
    isCheck = prefs.getBool('remember') ?? false;
    print(password);
    if (isCheck) {
      passwordController.text = password;
    }
    setState(() {});
  }
}
