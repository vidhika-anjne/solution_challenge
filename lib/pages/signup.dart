import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'login.dart'; // Import the LoginPage
import 'homepage.dart'; // Import your HomePage here
import 'teacher_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Function to validate email and password
  String? validateEmail(String email) {
    if (!email.contains('@gmail.com')) {
      return 'Please enter a valid Gmail address.';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 4) {
      return 'Password must be at least 4 characters.';
    }
    if (!RegExp(r'(?=.*[0-9])').hasMatch(password)) {
      return 'Password must contain at least one number.';
    }
    if (!RegExp(r'(?=.*[!@#$%^&*])').hasMatch(password)) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  Future<void> _signup() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      // Validate email and password
      if (validateEmail(email) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validateEmail(email)!)),
        );
        return;
      }

      if (validatePassword(password) != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validatePassword(password)!)),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      // Create user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Signup Successful! Welcome ${userCredential.user?.email}')),
      );

      // Navigate to Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage()), // Redirect to MyHomePage
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TeacherHomePage(),), // Redirect to MyHomePage
      );

    } catch (e) {
      print("Signup failed: $e");
      String errorMessage = "An error occurred during signup.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage =
                'The email address is already in use by another account.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'An unknown error occurred.';
            break;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Signup',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            // Enter password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true, // Hides the password
            ),
            SizedBox(height: 20),
            // Confirm password field
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: true, // Hides the password
            ),
            SizedBox(height: 30),
            // Signup button
            ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Signup',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Existing user? Login here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Existing user? ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to Login Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Login here',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
