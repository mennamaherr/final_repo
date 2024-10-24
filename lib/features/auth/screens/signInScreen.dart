import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onservice/widgets/ButtonNavBar.dart';
import '../../../LogIn with google/google_auth.dart';
import 'signUpScreen.dart';

import '../../../forgetpassword/forgetpassword.dart';
import '../../../phone_auth/phone_login.dart';
import '../services/authentication.dart';
import '../widgets/snackbar.dart';
import '../../../my_home.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

 // Function to validate email format
  String? validateEmail(String value) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);

    if (value.isEmpty) {
      return "Email address must not be empty";
    } else if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    } else if (value.contains(' ')) {
      return "Email must not contain spaces";
    }


    List<String> validDomains = ['gmail.com', 'yahoo.com', 'outlook.com'];
    String domain = value.split('@').last;
    if (!validDomains.contains(domain)) {
      return "Email domain is not supported";
    }

    return null;
  }


  // Function to validate password
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password must not be empty";
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long";
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must contain at least one special character";
    }

    return null;
  }

  void _signIn() async {
    if (formkey.currentState!.validate()) {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHome()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please verify your email before logging in.'),
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
      await _authService.signInWithEmail(email, password);
    } else {
      print("Please fill in all fields");

    }
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ButtonNavBar(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  bool visible = true;

  var formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 60.0,
                left: 24.0,
                bottom: 24.0,
                right: 24.0,
              ),
              child: Column(
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hi! Welcome back,you'v been missed",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
            Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  bottom: 24.0,
                  right: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email"),
                    TextFormField(
                      style: const TextStyle(fontSize: 10),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => validateEmail(value!),
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: "example@gmail.com",
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Password"),
                    TextFormField(
                      style: const TextStyle(fontSize: 10),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: visible,
                      validator: (value) => validatePassword(value!),
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              visible = !visible;
                              setState(() {});
                            },
                            icon: visible == true
                                ? const Icon(
                                    Icons.remove_red_eye,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                  )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.centerRight,
                        child: ForgotPassword()),
                    // MyButtons(onTap: loginUser, text: "Log In"),

                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        _signIn();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6759FF),
                        minimumSize: Size(double.infinity,
                            50), // Set minimum width and height
                      ),
                      child: const Text(
                        "sign in",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Or sign in with",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () async {
                          await _authService.signInWithGoogle();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ButtonNavBar(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Image.asset(
                                "assets/images/1.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const PhoneAuthentication(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xff6759FF),
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xff6759FF),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
