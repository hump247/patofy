import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:patofy/constants/colors.dart';

import '../../helpers/backup_helper.dart';
import '../home_screen.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _isRestoring = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.primaryRedColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Styles.primaryWhiteColor,
          ),
        ),
        title: Text(
          'Backup',
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Icon(
                Icons.backup,
                size: 68,
                color: Styles.primaryRedColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children:[
                 _buildParagraph(Icons.done, "Tap the backup button to create a new backup of your data."),
                  _buildParagraph(Icons.done, "A backup file will be created in your selected directory."),
                  _buildParagraph(Icons.done, "To restore your data, tap the restore button."),
                  _buildParagraph(Icons.done, "You will be prompted to confirm the restore operation."),
                  _buildParagraph(Icons.done, "Make sure to store the backup file in a safe location."),
                  _buildParagraph(Icons.done, "You can use the backup file to restore your data on a different device."),
                  _buildParagraph(Icons.done, "The backup file contains all your account details, incomes, and expenses data."),
                ],
                ),
              )
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  await BackupHelpers.createBackup(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Styles.primaryRedColor,
                        borderRadius: BorderRadius.circular(5)),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        "Backup Now",
                        style: TextStyle(color: Styles.primaryWhiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
            GestureDetector(
            onTap: ()async {
              // Implement the restore logic here
              // For now, you can add a print statement to test the tap event
              await  _restoreData();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Styles.primaryBlueColor,
                    borderRadius: BorderRadius.circular(5)),
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Restore Now",
                    style: TextStyle(color: Styles.primaryWhiteColor),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Styles.primaryRedColor,
            child: ListTile(
              leading: Icon(Icons.info, color: Styles.primaryWhiteColor),
              subtitle: Text(
                "Patofy will create new backup files in your selected directory",
                style: TextStyle(color: Styles.primaryWhiteColor),
              ),
            ),
          ),
        ],
      ),
    );
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
  
  Future<void> _restoreData() async {
    setState(() {
      _isRestoring = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isRestoring = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _isRestoring
              ? Center(
                  child: SpinKitDancingSquare(
                    size: 48,
                    color: Styles.primaryRedColor,
                  ),
                )
              : Text("Wait, we are checking your backup."),
        );
      },
    );
  }
}
