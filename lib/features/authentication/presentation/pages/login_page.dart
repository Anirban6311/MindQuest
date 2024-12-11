import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream/features/authentication/presentation/pages/signup_page.dart';

import '../../../quiz/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;

  late SharedPreferences pref;
  initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
    loadPrefs();
  }

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  void loadPrefs() {
    setState(() {
      isLoggedIn = pref.getBool('isLoggedIn')!;
    });

    if (isLoggedIn) {
      // Automatically navigate to Dashboard if logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  void verifyUserLogin(
      BuildContext context,
      TextEditingController _emailController,
      TextEditingController _passwordController) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email == "asinha@gmail.com" && password == "abcdef") {
      await pref.setBool('isLoggedIn', true);
      setState(() {
        isLoggedIn = true;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successfull")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Welcome back!",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 40),
                    child: Text(
                      "Hello there 👋, sign in to continue!",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return value!.isEmpty ? "Enter Email" : null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            return value!.isEmpty ? "Enter Password" : null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFfeda75),
                              Color(0xFFfa7e1e),
                              Color(0xFFd62976),
                              Color(0xFF962fbf),
                              Color(0xFF4f5bd5),
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              verifyUserLogin(
                                  context, emailController, passwordController);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Do not have an account? ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Signup',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage()),
                                    );
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
