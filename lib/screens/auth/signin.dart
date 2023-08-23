import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';
import 'package:patofy/screens/auth/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? emailError;

  String? pswError;
  bool _isSigningIn = false;

  Future<void> _signIn() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || !isValidEmail(email)) {
      emailError = 'Please enter a valid email address.';
      return;
    }

    if (password.isEmpty) {
      pswError = 'Please enter your password.';
      return;
    }

     setState(() {
      _isSigningIn = true; // Set _isSigningIn to true before starting the sign-in process
    });

    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null || !userCredential.user!.emailVerified) {
        emailError = 'email not verified. please verify your email';
        return;
      } else {
         setState(() {
        _isSigningIn = false; // Set _isSigningIn back to false after successful sign-in
      });
        // Navigate to the home screen if login is successful
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      pswError ="Invalid email or password.try again";
      setState(() {
        _isSigningIn = false; // Set _isSigningIn back to false if an error occurs during sign-in
      });
    }
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Sign In ',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 300.0,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const UnderlineInputBorder(),
                      errorText: emailError,
                    ),
                  ),
                ),
                const SizedBox(height: 1.0),
                SizedBox(
                  width: 300.0,
                  child: TextFormField(
                    controller: _passwordController,
                    decoration:  InputDecoration(
                      labelText: 'Password',
                      border: const UnderlineInputBorder(),
                      errorText: pswError,
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                
                height: 50.0,
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: _isSigningIn ? null : _signIn, // Disable button while signing in
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryRedColor,
                      ),
                      child: Text(
                        _isSigningIn ? 'please wait...' : 'Sign In', // Show different text based on _isSigningIn
                        style: TextStyle(color: Styles.primaryWhiteColor),
                      ),
                    ),
                    if (_isSigningIn) // Show the loading indicator when signing in
                      Positioned.fill(
                        child: Center(
                          child: SpinKitCircle(
                            color: Styles.primaryWhiteColor,
                            size: 30.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
