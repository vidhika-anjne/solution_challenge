import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'homepage.dart';
import 'package:flutter_svg/svg.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _signup() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup Successful! Welcome ${userCredential.user?.email}')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()), // Redirect to HomePage
      );
    } catch (e) {
      print("Signup failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isDesktop = screenSize.width > 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/desktop_welcome2.jpg', // Use a high-quality AI/Education theme image
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20),
              child: Container(
                width: isDesktop ? 900 : double.infinity,
                height: isDesktop ? 500 : null,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Glass effect
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left Side Image (Only for Desktop)
                    if (isDesktop)
                      Expanded(
                        child: Container(
                          child : SvgPicture.asset(
                            'images/sigup.svg',
                            width: screenSize.width * 0.35,
                            height: screenSize.height * 0.6,
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => CircularProgressIndicator(),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                          ),
                        ),
                      ),

                    // Right Side - Signup Form
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Create an Account',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),

                            // Email Field
                            _buildTextField(_emailController, 'Email', Icons.email, false),

                            SizedBox(height: 15),

                            // Password Field
                            _buildTextField(_passwordController, 'Password', Icons.lock, true),

                            SizedBox(height: 15),

                            // Confirm Password Field
                            _buildTextField(_confirmPasswordController, 'Confirm Password',
                                Icons.lock_outline, true),

                            SizedBox(height: 25),

                            // Signup Button
                            ElevatedButton(
                              onPressed: _signup,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Sign Up',
                                  style: TextStyle(fontSize: 18,
                                  // fontFamily: 'Nexa',
                                      fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              ),
                            ),

                            SizedBox(height: 15),

                            // Existing User? Login Here
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? ", style: TextStyle(fontSize: 14)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon, bool isObscure) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
