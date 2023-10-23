import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
        title: Text("About Patofy", style: TextStyle(color: Styles.primaryWhiteColor)),
        centerTitle: false,
        backgroundColor: Styles.primaryRedColor,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About Patofy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
                const SizedBox(height: 16),
              _buildParagraph(Icons.check, "Patofy is a digital money tracker app designed to help you manage your finances with ease."),
              _buildParagraph(Icons.check, "With Patofy, you can effortlessly track your incomes, expenses, and savings."),
              _buildParagraph(Icons.check, "Our mission is to empower you with a smart financial helper and assistant AI that makes budgeting and financial planning a breeze."),
              _buildParagraph(Icons.check, "Patofy uses advanced AI algorithms to provide personalized insights and suggestions based on your spending habits."),
              _buildParagraph(Icons.check, "We believe that everyone deserves financial freedom, and Patofy is here to guide you on your journey to financial success."),
              _buildParagraph(Icons.check, "Experience the power of Patofy and take control of your finances today."),
              const SizedBox(height: 24),// Adding some space between paragraphs
              GestureDetector(
                onTap: () {
                  _launchMap();
                },
                child: Container(
                  color: Styles.primaryBlueColor,
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Text(
                      "Location: Dodoma Makulu",
                      style: TextStyle(fontSize: 18, color: Styles.primaryWhiteColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  _launchPhone();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Styles.primaryBlackColor,
                  child: Center(
                    child: Text(
                      "Developer: 0672084262",
                      style: TextStyle(fontSize: 18, color: Styles.primaryWhiteColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  _launchEmail();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Styles.primaryRedColor,
                  child: Center(
                    child: Text(
                      "Email: info@patofy.com",
                      style: TextStyle(fontSize: 18, color: Styles.primaryWhiteColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  _launchWebsite();
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Styles.primaryBlueColor,
                  child: Center(child:   Text(
                    "Website: www.patofy.com",
                    style: TextStyle(fontSize: 18, color: Styles.primaryWhiteColor),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Method to launch Google Maps with the specified location address
  void _launchMap() async {
    const String address = "Dodoma Makulu";
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    // ignore: deprecated_member_use
    if (await canLaunch(googleMapsUrl)) {
      // ignore: deprecated_member_use
      await launch(googleMapsUrl);
    } else {
      print("Error launching Google Maps.");
    }
  }

  // Method to launch the phone dialer with the specified phone number
  void _launchPhone() async {
    const String phoneNumber = "0672084262";
    const String phoneUrl = "tel:$phoneNumber";
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      print("Error launching phone dialer.");
    }
  }

  // Method to launch the default email app with the specified email address
  void _launchEmail() async {
    const String emailAddress = "lucianojackson79@gmail.com";
    const String emailUrl = "mailto:$emailAddress";
    // ignore: deprecated_member_use
    if (await canLaunch(emailUrl)) {
      // ignore: deprecated_member_use
      await launch(emailUrl);
    } else {
      print("Error launching email app.");
    }
  }

  // Method to launch the default web browser to the specified website URL
  void _launchWebsite() async {
    const String websiteUrl = "https://lucianojr.netlify.app";
    if (await canLaunch(websiteUrl)) {
      await launch(websiteUrl);
    } else {
      print("Error launching web browser.");
    }
  }

   Widget _buildParagraph(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Styles.primaryBlackColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Styles.primaryBlackColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


