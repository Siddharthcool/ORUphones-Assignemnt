import 'package:assignment/AuthScreen/login_screen.dart';
import 'package:assignment/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Add the function definition for updating the verification ID
  void updateVerificationId(String newVerificationId) {
    // Your logic to handle the new verification ID goes here.
    // You can pass it to the next screen as needed.
    print("Verification ID: $newVerificationId");
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Splash delay

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // User is not logged in, navigate to Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginOtpScreen(
              updateVerificationId:
                  updateVerificationId), // Pass the updateVerificationId function
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'lib/images/oru.png', // Replace with your splash logo
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
