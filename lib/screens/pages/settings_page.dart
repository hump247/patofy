import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';

import '../auth/reset_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkModeEnabled = false;
  bool isCurrencySignDollar = true;
  bool isCurrencySignBefore = true;
  int decimalPlaces = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Settings',style: TextStyle(color: Styles.primaryRedColor,fontWeight: FontWeight.w800),),
      //   iconTheme: IconThemeData(color: Colors.transparent,),
      //   backgroundColor: Styles.primaryWhiteColor,
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Appearance',style: TextStyle(color: Styles.primaryRedColor),),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text("sorry not working",style:TextStyle(color: Styles.primaryBlackColor.withOpacity(0.09)),),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to the theme settings page
            },
          ),
          ListTile(
            title: const Text('UI Mode'),
            subtitle: Text("sorry not working",style:TextStyle(color: Styles.primaryBlackColor.withOpacity(0.09)),),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to the UI mode settings page
            },
          ),
          ListTile(
            title: const Text('Currency Sign'),
            subtitle: Text("show/hide sign",style:TextStyle(color: Styles.primaryBlackColor.withOpacity(0.09)),),
            trailing: Switch(
              activeTrackColor: Styles.primaryRedColor,
              value: isCurrencySignDollar,
              onChanged: (value) {
                setState(() {
                  isCurrencySignDollar = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                isCurrencySignDollar = !isCurrencySignDollar;
              });
            },
          ),
          ListTile(
            title: const Text('Currency Position'),
            subtitle: Text("show/hide postion",style:TextStyle(color: Styles.primaryBlackColor.withOpacity(0.09)),),
            trailing: Switch(
              
              activeTrackColor: Styles.primaryRedColor,
              value: isCurrencySignBefore,
              onChanged: (value) {
                setState(() {
                  isCurrencySignBefore = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                isCurrencySignBefore = !isCurrencySignBefore;
              });
            },
          ),
          ListTile(
            title: const Text('Decimal Places'),
            subtitle: Slider(
              value: decimalPlaces.toDouble(),
              label: "$decimalPlaces",
              thumbColor: Styles.primaryRedColor,
              activeColor: Styles.primaryRedColor,
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  decimalPlaces = value.toInt();
                });
              },
            ),
          ),
          ListTile(
            title: Text('Security',style: TextStyle(color: Styles.primaryRedColor)),
            subtitle: const Text('Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordPage()));
            },
          ),
          ListTile(
            title: Text('Notification',style: TextStyle(color: Styles.primaryRedColor)),
            subtitle: const Text('Remind every day'),
            trailing: Switch(
              activeTrackColor: Styles.primaryRedColor,
              value: isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                isDarkModeEnabled = !isDarkModeEnabled;
              });
            },
          ),
        ],
      ),
    );
  }
}
