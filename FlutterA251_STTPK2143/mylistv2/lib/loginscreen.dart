import 'package:flutter/material.dart';
import 'package:mylistv2/mainscreen.dart';
import 'package:mylistv2/registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool isCheck = false;
  String password = "";

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    loadPref();

    // Fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ------------------------------
  // BUILD UI
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌈 Modern Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E3B8E), Color(0xFF6A1B9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: screenWidth < 500 ? screenWidth * 0.9 : 380,

              // ⚪ Glass-like Card UI
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),

                  // 🔑 Login title
                  const Text(
                    "Enter PIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "Unlock your MyList V2 account",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔢 PIN input field
                  TextField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.2),
                      counterText: "",
                      hintText: "Enter 6-digit PIN",
                      hintStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // 🔘 Remember Me
                  Row(
                    children: [
                      Text(
                        "Remember Me",
                        style: TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Checkbox(
                        value: isCheck,
                        checkColor: Colors.white,
                        activeColor: Colors.purpleAccent,
                        onChanged: (value) async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          if (value == true) {
                            if (passwordController.text.length < 6) {
                              showMessage("Please enter a 6-digit PIN first!");
                              return;
                            }
                            prefs.setBool('remember', true);
                            showMessage("Preference saved!");
                          } else {
                            prefs.setBool('remember', false);
                            passwordController.clear();
                            showMessage("Preference removed!");
                          }

                          setState(() => isCheck = value!);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🚀 Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF8E3B8E),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        "Unlock",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🛠 Set / Change PIN
                  GestureDetector(
                    onTap: () {
                      if (password.isNotEmpty) {
                        //showenterpinDialog(); to check if password/pin is not empty
                        showEnterPinDialog();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Set / Change PIN",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // LOGIN LOGIC
  // ------------------------------
  void _handleLogin() {
    if (password.isEmpty) {
      showMessage("Please set PIN first!");
      return;
    }

    if (passwordController.text == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      showMessage("Wrong PIN!");
    }
  }

  // ------------------------------
  // SHOW MESSAGE
  // ------------------------------
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ------------------------------
  // LOAD SHARED PREFS
  // ------------------------------
  Future<void> loadPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    password = prefs.getString('password') ?? '';
    isCheck = prefs.getBool('remember') ?? false;

    if (isCheck) {
      passwordController.text = password;
    }
    setState(() {});
  }

  void showEnterPinDialog() {
    TextEditingController pinController = TextEditingController();
    bool isVisible = false;

    showDialog(
      context: context,
      barrierDismissible: false, // cannot close by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                "Enter PIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              content: SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      obscureText: !isVisible,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "6-digit PIN",
                        counterText: "",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            isVisible = !isVisible;
                          }),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    final enteredPin = pinController.text.trim();

                    if (enteredPin.isEmpty || enteredPin.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("PIN must be 6 digits.")),
                      );
                      return;
                    }

                    if (enteredPin == password) {
                      Navigator.pop(context); // close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Incorrect PIN!")),
                      );
                    }
                  },
                  child: const Text("Unlock"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
