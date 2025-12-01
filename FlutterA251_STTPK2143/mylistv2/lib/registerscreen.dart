import 'package:flutter/material.dart';
import 'package:mylistv2/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController passwordController = TextEditingController();
  bool passwordvisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Screen")),
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
              ElevatedButton(
                onPressed: () async {
                  String password = passwordController.text;
                  if (password.isEmpty || password.length < 6) {
                    //snackbar show
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Check your password empty/less than 6 pin number",
                        ),
                      ),
                    );
                    return;
                  }
                  //store password into shared pref
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('password', password);
                  await prefs.setBool('remember', false);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Success")));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Save"),
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
