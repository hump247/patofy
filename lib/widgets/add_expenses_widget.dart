import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:patofy/services/expenses_services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../model/epenses_model.dart';
import 'category_widget.dart';

class AddExpensesWidget extends StatefulWidget {
  const AddExpensesWidget({Key? key}) : super(key: key);

  @override
  State<AddExpensesWidget> createState() => _AddExpensesWidgetState();
}

class _AddExpensesWidgetState extends State<AddExpensesWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  User? _currentUser;

  List<Category> selectedCategories = []; // Store the selected categories

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _onCalculatePressed() async {
    setState(() {
      String details = _detailsController.text;
      String categoryText = selectedCategories.map((category) => category.name).join(', ');
      double amount = double.tryParse(_amountController.text) ?? 0;
      String createdAt = DateFormat('yyyy-MM-dd').format(DateTime.now());

      String userId = _currentUser?.uid ?? "";

      Expense expense = Expense(
        id: "", // You can generate a unique ID or leave it empty if Firestore generates it automatically
        details: details,
        category: categoryText,
        amount: amount,
        createdAt: createdAt,
        userId: userId,
      );

      ExpenseFirestoreService().addExpense(expense);

      _amountController.text = "";
      _detailsController.text = "";

      _showNotification('Expense Added', 'You have successfully added an expense.');

      Navigator.pop(context);
    });
  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics =const AndroidNotificationDetails(
      'Congratulations', // Replace 'channel_id' with your own channel ID
      'You have added the Expenses successfully', // Replace 'channel_name' with your own channel name
       
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'new_expense',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.primaryRedColor,
        title: Text(
          'New Expense',
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
              style: TextStyle(fontSize: 18.0, color: Styles.primaryWhiteColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'Details',
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: 'Amount in Tsh',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: GestureDetector(
                onTap: () async {
                  // Navigate to the IncomeCategoryPage and wait for the selected categories
                  List<Category>? selectedCategories = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryPage()),
                  );

                  // If selected categories are not null, update the input field with them
                  if (selectedCategories != null && selectedCategories.isNotEmpty) {
                    setState(() {
                      this.selectedCategories = selectedCategories;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Styles.primaryRedColor,
                  ),
                  child: Center(
                    child: Text(
                      "Choose Category",
                      style: TextStyle(color: Styles.primaryWhiteColor),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: GestureDetector(
                onTap: _onCalculatePressed,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Styles.primaryRedColor,
                  ),
                  child: Center(
                    child: Text(
                      "Add Expense",
                      style: TextStyle(color: Styles.primaryWhiteColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
