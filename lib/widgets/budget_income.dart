import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';

import '../screens/home_screen.dart';

class BudgetedIncomeTab extends StatefulWidget {
  const BudgetedIncomeTab({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BudgetedIncomeTabState createState() => _BudgetedIncomeTabState();
}

class _BudgetedIncomeTabState extends State<BudgetedIncomeTab> {
  String selectedDuration = '';
  List<TableRow> tableRows = [];

  Map<String, double> expensesByCategory = {};

  void fetchDataBasedOnDuration(String duration) async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid; // Get the authenticated user's ID

        // Construct the Firestore collection path based on the user ID and the appropriate collection name
        String collectionPath =
            'users/$userId/expenses'; // Change 'expenses' to the appropriate collection name where you store the data

        // Fetch data from Firestore
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection(collectionPath).get();

        // Filter the fetched data based on the selected duration
        DateTime currentDate = DateTime.now();
        DateTime startDate;
        if (duration == '1 Month') {
          startDate = DateTime(currentDate.year, currentDate.month, 1);
        } else if (duration == '3 Months') {
          startDate = DateTime(currentDate.year, currentDate.month - 2, 1);
        } else if (duration == '6 Months') {
          startDate = DateTime(currentDate.year, currentDate.month - 5, 1);
        } else if (duration == '12 Months') {
          startDate = DateTime(currentDate.year - 1, currentDate.month, 1);
        } else {
          // Invalid duration, do something or show an error message
          return;
        }

        Map<String, double> expensesByCategory = {};
        for (var doc in querySnapshot.docs) {
          double amount = doc['amount'] ?? 0.0;
          String category = doc['category'] ?? 'Unknown';
          DateTime createdAt = doc['createdAt'].toDate();
          if (createdAt.isAfter(startDate)) {
            if (expensesByCategory.containsKey(category)) {
              expensesByCategory[category] =
                  expensesByCategory[category]! + amount;
            } else {
              expensesByCategory[category] = amount;
            }
          }
        }

        // Now you have the total expenses for each category within the selected duration in the 'expensesByCategory' map.

        // Update the table with the fetched data
        // expensesByCategory.forEach((category, totalAmount) {
        //   expenseRows.add(
        //     TableRow(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(category),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(totalAmount.toStringAsFixed(2)), // Display the total amount rounded to 2 decimal places
        //         ),
        //         const Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Text(''), // Placeholder for description (if required)
        //         ),
        //       ],
        //     ),
        //   );
        // });

        // setState(() {
        //   tableRows = expenseRows;
        // });

        // Display a Snackbar to inform the user that data has been fetched.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wait while we prepared your $duration expense budget"),
        ));
      } else {
        // User is not authenticated or the authentication token has expired.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("User not authenticated. Please log in."),
        ));
      }
    } catch (error) {
      // Handle any errors that might occur during fetching data.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error fetching data. Please try again later."),
      ));
    }
  }

  void addTableRow() {
    List<TableRow> expenseRows = [];
    expensesByCategory.forEach((category, totalAmount) {
      expenseRows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(category),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(totalAmount.toStringAsFixed(
                  2)), // Display the total amount rounded to 2 decimal places
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(''), // Placeholder for description (if required)
            ),
          ],
        ),
      );
    });

    setState(() {
      tableRows = expenseRows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Choose duration',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Fill in the box below of the income budget',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        child: ActionChip(
                          label: const Text('1 Month'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = '1 Month';
                            });
                            fetchDataBasedOnDuration('1 Month');
                          },
                          backgroundColor: selectedDuration == '1 Month'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == '1 Month'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ActionChip(
                        label: const Text('3 Months'),
                        onPressed: () {
                          setState(() {
                            selectedDuration = '3 Months';
                          });
                          fetchDataBasedOnDuration('3 Month');
                        },
                        backgroundColor: selectedDuration == '3 Months'
                            ? Styles.primaryBlackColor
                            : null,
                        labelStyle: TextStyle(
                          color: selectedDuration == '3 Months'
                              ? Styles.primaryWhiteColor
                              : Styles.primaryBlackColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ActionChip(
                        label: const Text('6 Months'),
                        onPressed: () {
                          setState(() {
                            selectedDuration = '6 Months';
                          });
                          fetchDataBasedOnDuration('6 Month');
                        },
                        backgroundColor: selectedDuration == '6 Months'
                            ? Styles.primaryBlackColor
                            : null,
                        labelStyle: TextStyle(
                          color: selectedDuration == '6 Months'
                              ? Styles.primaryWhiteColor
                              : Styles.primaryBlackColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ActionChip(
                        label: const Text('12 Months'),
                        onPressed: () {
                          setState(() {
                            selectedDuration = '12 Months';
                          });
                          fetchDataBasedOnDuration('12 Month');
                        },
                        backgroundColor: selectedDuration == '12 Months'
                            ? Styles.primaryBlackColor
                            : null,
                        labelStyle: TextStyle(
                          color: selectedDuration == '12 Months'
                              ? Styles.primaryWhiteColor
                              : Styles.primaryBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(3),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      children: const [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Category',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...tableRows,
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: addTableRow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.primaryRedColor,
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                color: Styles.primaryWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Styles.primaryRedColor),
                  child: Center(
                    child: Text(
                      "Finish",
                      style: TextStyle(
                          color: Styles.primaryWhiteColor, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
