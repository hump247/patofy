import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/home_screen.dart';

class BudgetedExpensesTab extends StatefulWidget {
  const BudgetedExpensesTab({Key? key}) : super(key: key);

  @override
  _BudgetedExpensesTabState createState() => _BudgetedExpensesTabState();
}

class _BudgetedExpensesTabState extends State<BudgetedExpensesTab> {
  String selectedDuration = '';
  List<TableRow> tableRows = [];
  Map<String, double> expensesByCategory = {};
  Map<String, double> incomesByCategory = {}; // Add incomesByCategory

  void fetchDataBasedOnDuration(String duration) async {
    try {
      // Fetch expenses data
      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      expensesByCategory = {};
      for (var doc in expenseSnapshot.docs) {
        double amount = doc['amount'] ?? 0.0;
        String category = doc['category'] ?? 'Unknown';
        DateTime createdAt = doc['createdAt'].toDate();
        if (isWithinDuration(createdAt, duration)) {
          if (expensesByCategory.containsKey(category)) {
            expensesByCategory[category] = amount;
          } else {
            expensesByCategory[category] = amount;
          }
        }
      }

      // Fetch incomes data
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      incomesByCategory = {};
      for (var doc in incomeSnapshot.docs) {
        double amount = doc['amount'] ?? 0.0;
        String category = doc['category'] ?? 'Unknown';
        DateTime createdAt = doc['createdAt'].toDate();
        if (isWithinDuration(createdAt, duration)) {
          if (incomesByCategory.containsKey(category)) {
            incomesByCategory[category] = amount;
          } else {
            incomesByCategory[category] = amount;
          }
        }
      }

      // Generate suggested budget and update tableRows
      setState(() {
        tableRows = generateTableRows();
      });

      // Display a Snackbar to inform the user that data has been fetched.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Wait while we prepare your $duration expense budget"),
      ));
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error fetching data. Please try again later."),
      ));

      
    }
  }
  
  void addBudgetToFirestore() async {
    try {
      // Get the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Construct the Firestore collection path for the new "budgets" collection
        String collectionPath = 'users/$userId/budgets'; // Change 'budgets' to the appropriate collection name

          // Create a new Firestore collection "budgets" and add data
        for (var entry in expensesByCategory.entries) {
          String category = entry.key;
          double suggestedBudget = entry.value;

          DateTime createdAt = DateTime.now();

          await FirebaseFirestore.instance.collection(collectionPath).add({
            'category': category,
            'suggestedBudget': suggestedBudget,
            'createdAt': createdAt,
            'createdBy': userId,
          });
        }

        print("addedd ");
      }
    } catch (error) {
      print('Error adding budget to Firestore: $error');
    }
  }

  bool isWithinDuration(DateTime date, String duration) {
    DateTime currentDate = DateTime.now();
    if (duration == '1 Month') {
      DateTime oneMonthAgo = currentDate.subtract(Duration(days: 30));
      return date.isAfter(oneMonthAgo);
    } else if (duration == '3 Months') {
      DateTime threeMonthsAgo = currentDate.subtract(Duration(days: 90));
      return date.isAfter(threeMonthsAgo);
    } else if (duration == '6 Months') {
      DateTime sixMonthsAgo = currentDate.subtract(Duration(days: 180));
      return date.isAfter(sixMonthsAgo);
    } else if (duration == '12 Months') {
      DateTime oneYearAgo = currentDate.subtract(Duration(days: 365));
      return date.isAfter(oneYearAgo);
    }
    return false;
  }

  List<TableRow> generateTableRows() {
    List<TableRow> suggestedBudgetRows = [];

    // Loop through each category and calculate the suggested budget
    expensesByCategory.forEach((category, expenseAmount) {
      if (incomesByCategory.containsKey(category)) {
        double incomeAmount = incomesByCategory[category]!;

        // Calculate the suggested budget by subtracting expenses from incomes
        double suggestedBudget = incomeAmount - expenseAmount;

        suggestedBudgetRows.add(
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(category),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(suggestedBudget.toStringAsFixed(2)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(''),
              ),
            ],
          ),
        );
      }
    });

    return suggestedBudgetRows;
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
                'Fill in the box below with the expense budget',
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
                    //three months duration
                     Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        child: ActionChip(
                          label: const Text('3 Month'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = '3 Month';
                            });
                            fetchDataBasedOnDuration('3 Month');
                          },
                          backgroundColor: selectedDuration == '3 Month'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == '3 Month'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                    ),

                    //six months duration
                     Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        child: ActionChip(
                          label: const Text('6 Month'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = '6 Month';
                            });
                            fetchDataBasedOnDuration('6 Month');
                          },
                          backgroundColor: selectedDuration == '6 Month'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == '6 Month'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                    ),

                    //twelve months duration
                     Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        child: ActionChip(
                          label: const Text('12 Month'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = '12 Month';
                            });
                            fetchDataBasedOnDuration('12 Month');
                          },
                          backgroundColor: selectedDuration == '12 Month'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == '12 Month'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                    ),
                    // Add other ActionChips for different durations
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
                              'Suggested Budget',
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
                            'Total Suggested Budget',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: addBudgetToFirestore,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Styles.primaryRedColor,
                  ),
                  child: Center(
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        color: Styles.primaryWhiteColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
