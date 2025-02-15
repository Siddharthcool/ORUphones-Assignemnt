import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../AuthScreen/login_screen.dart';

class HomeViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  HomeViewModel() {
    _checkUserLoginStatus();
  }

  void _checkUserLoginStatus() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    _navigateToLoginScreen(context);
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginOtpScreen(
          updateVerificationId: (String verificationId) {},
        ),
      ),
    );
  }

  // Call this method when the user is not logged in
  void navigateToLogin(BuildContext context) {
    _navigateToLoginScreen(context);
  }
}
