import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
        title: Text("Reset password",style: TextStyle(color: Styles.primaryWhiteColor),),
        centerTitle: false,
        backgroundColor: Styles.primaryRedColor,
        leading: IconButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (_)=>const HomeScreen()));
        }, icon: const Icon(Icons.arrow_back_ios)),
      ),
    );
  }
}