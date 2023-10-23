import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/colors.dart';
import 'auth/signin.dart';
import 'home_screen.dart'; // Replace with your home screen file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3), // Reduced time for demonstration purposes
      () {
        // Check if the user is logged in and contains data
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // User is logged in, navigate to home screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()), // Replace with your home screen
          );
        } else {
          // User is not logged in or data not available, navigate to signin screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignInScreen()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryRedColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/patofy-logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10),
            Text(
              "Patofy",
              style: TextStyle(fontSize: 34, color: Styles.primaryWhiteColor),
            ),
            const SizedBox(height: 40),
            SpinKitCircle(
              color: Styles.primaryWhiteColor,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
