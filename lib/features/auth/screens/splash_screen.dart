//  import 'package:flutter/material.dart';
// import 'dart:async';
// import 'onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
// Timer(Duration(seconds: 3), () {
//   Navigator.of(context).pushReplacement(
//     MaterialPageRoute(builder: (_) => OnboardingScreen()),
//   );
// });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Color(0xff6759FF),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/onboarding_images/home.png'),
//               SizedBox(height: 20),
//               Text(
//                 'Home Services',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onservice/features/auth/screens/onboarding_screen.dart';
import 'package:onservice/features/auth/screens/signInScreen.dart';
import 'package:onservice/my_home.dart';
import '../../../firebase_options2.dart'; // Import the second firebase_options.dart file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //_initializeFirebase();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    });
  }

/*
  _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _checkAuthState();
    } catch (e) {
      // Handle initialization error
      print('Firebase initialization error: $e');
      _showErrorScreen();
    }
  }
*/
  _checkAuthState() async {
    try {
      await Future.delayed(const Duration(seconds: 3), () {});
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const MyHome(), // Navigate to MyHome if user is signed in
          ),
        );
      } else {
        // User is not signed in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const SignInScreen(), // Navigate to SignInScreen if user is not signed in
          ),
        );
      }
    } catch (e) {
      // Handle error checking auth state
      print('Error checking auth state: $e');
      _showErrorScreen();
    }
  }

  _showErrorScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(
              'Error initializing Firebase. Please try again later.',
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff6759FF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/home.png'),
              SizedBox(height: 20),
              Text(
                'Home Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
