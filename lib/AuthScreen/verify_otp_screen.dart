import 'dart:async';
import 'package:assignment/AuthScreen/confirm_name_screen.dart';
import 'package:assignment/AuthScreen/login_screen.dart';
import 'package:assignment/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment/FirebaseVerification/phoneAuth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;

  const VerifyOtpScreen({super.key, required this.verificationId});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;
  String _errorMessage = '';
  bool isVerifying = false;

  get updateVerificationId => null;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < otpControllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        focusNodes[index].unfocus();
      }
    }
  }

  void _resendOtp() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
      _startCountdown();
    });
  }

  Future<void> _verifyOtp() async {
    String otpCode = otpControllers.map((controller) => controller.text).join();
    if (otpCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      isVerifying = true;
    });

    String? error =
        await PhoneAuthService().verifyOtp(widget.verificationId, otpCode);
    setState(() {
      isVerifying = false;
    });

    if (error == null) {
      await _checkUserStatus();
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  Future<void> _checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ConfirmNameScreen(verificationId: widget.verificationId),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents bottom overflow
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginOtpScreen(
                      updateVerificationId: updateVerificationId)),
            );
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset('lib/images/oru.png')),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'Verify Mobile Number',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Enter the 6-digit OTP sent to your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: otpControllers[index],
                            focusNode: focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                counterText: '', border: InputBorder.none),
                            onChanged: (value) => _onOtpChanged(value, index),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    SizedBox(height: 40),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't receive OTP?",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black87)),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: _canResend ? _resendOtp : null,
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          if (!_canResend)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '$_secondsRemaining sec',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Container(
                        color: Colors.blue,
                        child: TextButton(
                          onPressed: isVerifying ? null : _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            padding:
                                EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: isVerifying
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Verify OTP',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
