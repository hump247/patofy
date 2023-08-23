import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';
import 'package:http/http.dart' as http;


//drive import
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

class GoogleDrivePage extends StatefulWidget {
  const GoogleDrivePage({Key? key}) : super(key: key);

  @override
  State<GoogleDrivePage> createState() => _GoogleDrivePageState();
}

class _GoogleDrivePageState extends State<GoogleDrivePage> {
  final bool _isRestoring = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  final auth.ClientId _clientId = auth.ClientId(  
    '846862178299-h5mbtr18jet7h8rcb2a8vodb7hjs6p71.apps.googleusercontent.com',
    '',
);

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
          'Google Drive Backup',
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Icon(
              Icons.backup,
              size: 68,
              color: Styles.primaryRedColor,
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
                  children: [
                    _buildParagraph(Icons.done,
                        "Tap the synchronize button to synchronize your incomes and expenses data to Google Drive cloud storage."),
                    _buildParagraph(Icons.done,
                        "Your incomes and expenses data will be securely stored on Google Drive."),
                    _buildParagraph(Icons.done,
                        "You can access your synchronized data from any device with Google Drive."),
                    _buildParagraph(Icons.done,
                        "Synchronization ensures that your data is always up-to-date across all your devices."),
                    _buildParagraph(Icons.done,
                        "You can restore your data from Google Drive to your device anytime you want."),
                    _buildParagraph(Icons.done,
                        "Google Drive offers free storage space for your backup data."),
                    _buildParagraph(Icons.done,
                        "Your data is encrypted and protected with your Google account credentials."),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  await _createGoogleDriveBackup();
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
                        "Create Google Drive Backup",
                        style: TextStyle(color: Styles.primaryWhiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isRestoring
              ? Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: SpinKitFadingCircle(
                      color: Styles.primaryRedColor,
                      size: 20,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    await _restoreData();
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
                "Patofy will synchronize your incomes and expenses data to Google Drive cloud storage.",
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

  Future<auth.AutoRefreshingAuthClient> _createAuthClient(GoogleSignInAccount googleSignInAccount) async {
    final googleSignInAuthentication = await googleSignInAccount.authentication;
    final credentials = auth.AccessCredentials(
      auth.AccessToken(
        'Bearer',
        googleSignInAuthentication.accessToken!,
        DateTime.now()

        
      ),
      googleSignInAuthentication.idToken,
      [drive.DriveApi.driveFileScope],
    );

    final client = auth.autoRefreshingClient(
      _clientId,
      http.Client() as AccessCredentials,
      credentials as http.Client,
    );
    return client;
  }

Future<void> _createGoogleDriveBackup() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final auth.AutoRefreshingAuthClient client = await _createAuthClient(googleSignInAccount);

      final drive.DriveApi driveApi = drive.DriveApi(client);

      // Implement your synchronization logic here
      // For example, upload files to Google Drive

      // Show success dialog
      _showSuccessDialog("Backup Successful", "Your data has been successfully backed up.");
    }
  } catch (error) {
    print('Error creating Google Drive backup: $error');
    _showErrorDialog("Backup Error", "An error occurred while creating the backup.");
  }
}

Future<void> _restoreData() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final auth.AutoRefreshingAuthClient client = await _createAuthClient(googleSignInAccount);

      final drive.DriveApi driveApi = drive.DriveApi(client);

      // Implement your restore logic here
      // For example, download files from Google Drive

      // Show success dialog
      _showSuccessDialog("Restore Successful", "Your data has been successfully restored.");
    }
  } catch (error) {
    print('Error restoring data: $error');
    _showErrorDialog("Restore Error", "An error occurred while restoring data.");
  }
}


void _showErrorDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Styles.primaryRedColor,
      title: Text(title, style: TextStyle(color: Styles.primaryWhiteColor)),
      content: Text(message, style: TextStyle(color: Styles.primaryWhiteColor)),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

void _showSuccessDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Styles.primaryBlueColor,
      title: Text(title, style: TextStyle(color: Styles.primaryWhiteColor)),
      content: Text(message, style: TextStyle(color: Styles.primaryWhiteColor)),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
}
