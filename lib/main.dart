// import 'dart:io';
import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
// Firebase web configuration
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAzw5sNPyHoWhHEOsLr_U6ww_IqP5cnVoE",
    authDomain: "solutionc-b2fa7.firebaseapp.com",
    projectId: "solutionc-b2fa7",
    storageBucket: "solutionc-b2fa7.firebasestorage.app",
    messagingSenderId: "769538353402",
    appId: "1:769538353402:web:1a57b18763c4d0a4968143",
    measurementId: "G-55F4J5DJL2"
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(options: firebaseOptions); 

  runApp(MaterialApp(
    home: WelcomePage(),
    debugShowCheckedModeBanner: false,
  ));
}