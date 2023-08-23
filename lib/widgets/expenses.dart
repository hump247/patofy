import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';

import '../model/epenses_model.dart';
import '../services/expenses_services.dart';
import 'add_expenses_widget.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key, required String sortingOption});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {

    String actualExpenseAmount = "0.00"; // Initialize with a default value
  List<Expense> expenseList = []; // Initialize an empty list to store Expense data

  @override
  void initState() {
    super.initState();
    fetchExpenseData(); // Fetch Expense data when the widget is initialized
  }

  void fetchExpenseData() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String currentUserId = user.uid;
      List<Expense> fetchedExpenseList = await ExpenseFirestoreService().getExpensesForUser(currentUserId);
      double totalExpenseAmount = 0.0;

      // Calculate the total Expense amount
      for (Expense expense in fetchedExpenseList) {
        totalExpenseAmount += expense.amount;
      }

      // Update the state with the actual Expense amount and Expense data
      setState(() {
        actualExpenseAmount = totalExpenseAmount.toStringAsFixed(2);
        expenseList = fetchedExpenseList;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 18.0),
                child: Container(
                  color: Styles.primaryRedColor.withOpacity(0.2),
                  height: 90,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: 90,
                        color: Styles.primaryWhiteColor.withOpacity(0.5),
                        child: Icon(
                          Icons.attach_money,
                          color: Styles.primaryRedColor,
                          size: 90,
                        ),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            child: Text(
                              "Your Expenses",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text("Actual"),
                                    Text(
                                      actualExpenseAmount,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 19,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Budgeted",
                                      style: TextStyle(color: Styles.primaryGreenColor),
                                    ),
                                    Text(
                                      "0.00",
                                      style: TextStyle(color: Styles.primaryGreenColor),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // Display the list of income data
              ExpenseListWidget(expenseList: expenseList),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Styles.primaryRedColor,
            onPressed: () {
              // Handle the add new button press here
              Navigator.push(context, MaterialPageRoute(builder: (_) =>  const AddExpensesWidget()));
            },
            child: Text(
              '+',
              style: TextStyle(fontSize: 26, color: Styles.primaryWhiteColor),
            ),
          ),
        ),
      ],
    );
  }
}

class ExpenseListWidget extends StatefulWidget {
  final List<Expense> expenseList;

  const ExpenseListWidget({super.key, required this.expenseList});

  @override
  State<ExpenseListWidget> createState() => _ExpenseListWidgetState();
}

class _ExpenseListWidgetState extends State<ExpenseListWidget> {


  @override
  Widget build(BuildContext context) {
    if (widget.expenseList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Styles.primaryRedColor,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.expenseList.length,
        itemBuilder: (context, index) {
          Expense expense = widget.expenseList[index];
          return ListTile(
           leading: CircleAvatar(
            backgroundColor: Styles.primaryRedColor.withOpacity(0.4),
            child: Text(expense.category.substring(0,1)),
           ),
            title: Text(expense.category,style:TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(expense.createdAt, style: TextStyle(color: Styles.primaryGreenColor),),
            trailing: Text(expense.amount.toStringAsFixed(2),style: TextStyle(color: Styles.primaryRedColor),),
          );
        },
      );
    }
  }
}

