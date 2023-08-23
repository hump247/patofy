import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupHelpers {
  static Future<void> createBackup(BuildContext context) async {
    try {
      // Fetch user account details, incomes, and expenses data
      Map<String, dynamic> accountData = await _fetchUserAccountData();
      List<Map<String, dynamic>> incomesData = await _fetchIncomesData();
      List<Map<String, dynamic>> expensesData = await _fetchExpensesData();

      // Combine all data into a single map
      Map<String, dynamic> dataToBackup = {
        "account": accountData,
        "incomes": incomesData,
        "expenses": expensesData,
      };

      // Convert data to JSON format
      String jsonData = json.encode(dataToBackup);

      // Get the selected storage directory from the user
      Directory? selectedDirectory = await _getSelectedStorageDirectory();

      if (selectedDirectory != null) {
        // Create the directory if it doesn't exist

          // Show the loading dialog
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitFadingCircle(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  SizedBox(height: 16.0),
                  Text('Creating backup file...'),
                ],
              ),
            );
          },
        );
        selectedDirectory.create(recursive: true);

        // Create a new file in the selected directory with the .mbak extension
        File backupFile = File('${selectedDirectory.path}/patofy.mbak');

        // Write the JSON data to the backup file
        await backupFile.writeAsString(jsonData);
        print('Backup file created successfully: ${backupFile.path}');
      } else {
        print('Backup process cancelled or storage permission denied.');
      }
    } catch (e) {
      print('Error during backup: $e');
      // Handle the error as per your requirement. You can show an error message to the user.
    }
  }

  // Method to fetch user account details from FirebaseAuth and Firestore
  static Future<Map<String, dynamic>> _fetchUserAccountData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> accountData = {
      "phoneNumber": user?.phoneNumber,
      "email": user?.email,
      // "firsname": firstname, // Add logic to fetch user names from Firestore based on user UID
      // "password": "", // It is not recommended to save the user's password in plaintext, but you can add the encrypted/hashed version here if necessary.
    };

    // Implement the logic to fetch user names from Firestore based on user UID
    // For example, you can use the FirebaseFirestore.instance to query the data.

    return accountData;
  }

  // Method to fetch incomes data from Firestore
  static Future<List<Map<String, dynamic>>> _fetchIncomesData() async {
    // Replace 'incomes' with the actual collection name where you store incomes in Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('incomes').get();

    List<Map<String, dynamic>> incomesData = [];
    for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      Map<String, dynamic> income = documentSnapshot.data()!;
      incomesData.add(income);
    }

    return incomesData;
  }

  // Method to fetch expenses data from Firestore
  static Future<List<Map<String, dynamic>>> _fetchExpensesData() async {
    // Replace 'expenses' with the actual collection name where you store expenses in Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    List<Map<String, dynamic>> expensesData = [];
    for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      Map<String, dynamic> expense = documentSnapshot.data()!;
      expensesData.add(expense);
    }

    return expensesData;
  }

  static Future<Directory?> _getSelectedStorageDirectory() async {
    // Request WRITE_EXTERNAL_STORAGE permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Handle the case where the user denied the permission.
      // You may want to show a message to the user explaining why the permission is required.
      return null;
    }

    // Allow the user to select a storage directory using file_picker
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null && result.isNotEmpty) {
      Directory selectedDirectory = Directory(result);
      return selectedDirectory;
    }

    return null;
  }
}
