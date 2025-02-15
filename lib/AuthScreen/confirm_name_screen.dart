import 'package:assignment/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfirmNameScreen extends StatefulWidget {
  final String verificationId;

  const ConfirmNameScreen({super.key, required this.verificationId});

  @override
  _ConfirmNameScreenState createState() => _ConfirmNameScreenState();
}

class _ConfirmNameScreenState extends State<ConfirmNameScreen> {
  final TextEditingController nameController = TextEditingController();
  String errorMessage = ''; // Error message
  bool isNameValid = false; // Track if the name is valid

  // Validate name input
  void validateName(String value) {
    setState(() {
      if (value.isNotEmpty && RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
        errorMessage = ''; // Clear error if valid
        isNameValid = true; // Name is valid
      } else {
        errorMessage = 'Invalid name. Only alphabets allowed.'; // Show error if invalid
        isNameValid = false; // Name is invalid
      }
    });
  }

  // Function to save the name and phone number in Firestore
  Future<void> saveUserNameToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && isNameValid) {
        // Create a reference to the users collection in Firestore
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        // Save phone number and name to Firestore using the user's UID
        await users.doc(user.uid).set({
          'name': nameController.text,  // Store the name
          'phoneNumber': user.phoneNumber, // Store the phone number
        }, SetOptions(merge: true));  // Merge data if the document already exists

        // Navigate to the home screen or next screen after saving
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the actual home screen
        );
      }
    } catch (e) {
      print("Error saving name to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenPadding = MediaQuery.of(context).padding.top;

    double buttonHeight = screenHeight * 0.08; // Button height
    double spacing = screenHeight * 0.02; // Spacing

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenPadding + 40), // Adjusted for different screens

              // Centered Company Logo
              Center(
                child: Image.asset(
                  'lib/images/oru.png',
                ),
              ),
              SizedBox(height: spacing),

              // Welcome Text
              Center(
                child: Text(
                  'Confirm Name',
                  style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),

              // Instruction Text
              Center(
                child: Text(
                  'Enter your name to continue',
                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.black87),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),

              // Name Input Field
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Please tell us your name', // Updated label text
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  validateName(value); // Validate name
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")), // Allow only letters and spaces
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Error message for invalid name
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.04),
                ),
              SizedBox(height: screenHeight * 0.1),

              // Next button
              SizedBox(height: spacing),
              Container(
                width: double.infinity,
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: isNameValid ? Colors.blue : Colors.grey, // Enable button only if valid
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: isNameValid
                      ? () {
                          saveUserNameToFirestore(); // Save the name and move to the next screen
                        }
                      : null, // Disable button if name is invalid
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm Name',
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
