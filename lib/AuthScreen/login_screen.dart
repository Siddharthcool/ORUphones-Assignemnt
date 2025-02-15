import 'package:assignment/FirebaseVerification/phoneAuth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assignment/AuthScreen/verify_otp_screen.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key, required void Function(String newVerificationId) updateVerificationId});

  @override
  _LoginOtpScreenState createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool value = false; // Checkbox state
  String errorMessage = ''; // Error message for phone number validation
  bool isLoading = false; // Loading state for OTP request

  // Function to validate phone number
  void validatePhoneNumber(String value) {
    setState(() {
      if (value.length < 10) {
        errorMessage = 'Phone number must be exactly 10 digits';
      } else if (value.length == 10 && int.tryParse(value) != null) {
        errorMessage = ''; // Clear error message if valid
      } else {
        errorMessage = 'Invalid phone number';
      }
    });
  }

  // Function to save phone number to Firestore
  Future<void> savePhoneNumberToFirestore(String phoneNumber) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.add({
        'phone_number': phoneNumber,
        'created_at': Timestamp.now(), // Store the current timestamp
      });
      print("Phone number saved to Firestore!");
    } catch (e) {
      print("Error saving phone number to Firestore: $e");
    }
  }

  // Function to format phone number to E.164 format
  String formatPhoneNumber(String phoneNumber) {
    // Assuming the country code is India (+91)
    return '+91${phoneNumber.trim()}';
  }

  // Function to send OTP (Uses PhoneAuthService)
  void sendOtp() async {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.length != 10 || errorMessage.isNotEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Save phone number to Firestore
    await savePhoneNumberToFirestore(phoneNumber);

    String formattedPhoneNumber = formatPhoneNumber(phoneNumber); // Format to E.164

    PhoneAuthService().sendOtp(
      phoneNumber: formattedPhoneNumber,
      onCodeSent: (verificationId) {
        setState(() {
          isLoading = false;
        });

        // Navigate to Verify OTP Screen and pass phone number as well
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              verificationId: verificationId,
            ),
          ),
        );
      },
      onError: (error) {
        setState(() {
          errorMessage = error;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenPadding = MediaQuery.of(context).padding.top;
    double buttonHeight = screenHeight * 0.08;
    double spacing = screenHeight * 0.02;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenPadding + 40),
              Center(
                child: Image.asset('lib/images/oru.png'),
              ),
              SizedBox(height: spacing),
              Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  'Signin to continue',
                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter phone number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
                maxLength: 10,
                onChanged: validatePhoneNumber,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: screenHeight * 0.02),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
                ),
              SizedBox(height: screenHeight * 0.1),
              Row(
                children: [
                  Checkbox(value: value, onChanged: (newValue) => setState(() => value = newValue ?? false)),
                  Text(
                    'Accept terms and conditions',
                    style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              Container(
                width: double.infinity,
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: (value && errorMessage.isEmpty) ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: (value && errorMessage.isEmpty) ? sendOtp : null,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_right_alt, color: Colors.white, size: screenWidth * 0.07),
                          ],
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
