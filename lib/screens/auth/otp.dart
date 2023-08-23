import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/auth/signin.dart';

class OtpScreen extends StatefulWidget {
  
  const OtpScreen({super.key,});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  List<String> verificationCode = List<String>.filled(6, '');
//   int currentBoxIndex = 0;
//   bool isLoading = false;

//   void _onCodeChanged(String value) {
//     setState(() {
//       verificationCode[currentBoxIndex] = value;
//       if (currentBoxIndex < verificationCode.length - 1) {
//         currentBoxIndex++;
//       } else {
//         // All boxes are filled, simulate verification process
//         isLoading = true;
//         Navigator.push(context, MaterialPageRoute(builder: (_)=> SignInScreen()));
        
//       }
//     });

//     // Move to the next box automatically
//     if (value.isNotEmpty && currentBoxIndex < verificationCode.length - 1) {
//       FocusScope.of(context).nextFocus();
//     }
//   }


//   List<Widget> buildCodeBoxes() {
//     List<Widget> codeBoxes = [];
//     for (int i = 0; i < verificationCode.length; i++) {
//       codeBoxes.add(
//         Container(
//           width: 50,
//           height: 60,
//           margin: EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             border: Border.all(width: 2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: TextFormField(
//               onChanged: (value) => _onCodeChanged(value),
//               maxLength: 1,
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 24),
//               decoration: InputDecoration(
//                 counterText: '',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return codeBoxes;
//   }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?>? _authStateChanges;

  @override
  void initState() {
    super.initState(); 
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges!.listen((user) {
      // Check if the user is not null and their email is verified
      if (user != null && user.emailVerified) {
        // User's email is verified, auto redirect to SignInScreen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email,
                    size: 180,
                    color: Styles.primaryRedColor,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Verify your email address',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  const Center(
                    child: Text(
                      'we have just sent email verification link on your email.Please check the email and click on that link to verify your email address',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                 const Center(
                    child: Text(
                      'if not auto redirected after verification,click resend email link'
                      ,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: resendVerificationLink,
                   child: const Text("Resend Email ink")),
                  const SizedBox(height: 5),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const SignInScreen()));
                  }, child: const Text("back to login"))
                ],
              ),
      ),
    );
  }
   resendVerificationLink() async {
  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
}
}
