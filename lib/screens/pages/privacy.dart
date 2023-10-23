import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
        centerTitle: false,
        backgroundColor: Styles.primaryRedColor,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              '''
              PRIVACY POLICY
              Last Updated: july 2023

              Welcome to the Patofy app. This Privacy Policy describes how we collect, use, and share information when you use our app. By using Patofy, you agree to the collection and use of your information in accordance with this Privacy Policy.

              INFORMATION WE COLLECT
              - Personal Information: We may collect personal information such as your name, email address, and other contact details when you register or interact with our app.
              - Financial Information: Patofy securely collects and stores your financial information such as transactions, expenses, and income to provide budgeting and financial analysis features.
              - Usage Information: We collect information about how you use the app, including your interactions, preferences, and settings.

              HOW WE USE YOUR INFORMATION
              - Provide and improve the app's functionality.
              - Personalize your experience and provide tailored recommendations.
              - Analyze usage patterns and perform data analysis to enhance app performance.
              - Communicate with you regarding app updates, new features, and promotions.

              INFORMATION SHARING
              We may share your information with trusted third parties for the following purposes:
              - Service Providers: We engage service providers to assist us in providing and maintaining the app.
              - Legal Requirements: We may share your information to comply with legal obligations or respond to lawful requests.

              DATA SECURITY
              We take reasonable measures to protect your information from unauthorized access, disclosure, or alteration. However, no method of transmission over the internet or electronic storage is completely secure.

              CHANGES TO THE PRIVACY POLICY
              We may update this Privacy Policy from time to time. The updated version will be posted on our website or within the app.

              CONTACT US
              If you have any questions or concerns about this Privacy Policy, please contact us at [email protected]

              ''',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
