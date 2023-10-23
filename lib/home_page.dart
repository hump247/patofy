import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Loading-circle.dart';
import 'Top_card.dart';
import 'plus_button.dart';
import 'transaction.dart';

class TransactionSummary {
  double dailyIncome;
  double dailyExpense;
  double weeklyIncome;
  double weeklyExpense;
  double monthlyIncome;
  double monthlyExpense;

  TransactionSummary({
    this.dailyIncome = 0,
    this.dailyExpense = 0,
    this.weeklyIncome = 0,
    this.weeklyExpense = 0,
    this.monthlyIncome = 0,
    this.monthlyExpense = 0,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum TimeRange { daily, weekly, monthly, chooseDate }

class _HomePageState extends State<HomePage> {
  double dailyExpense = 0.0;
  double weeklyExpense = 0.0;
  double monthlyExpense = 0.0;

  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  String income = '';
  String expense = '';
  String balance = '';
  TimeRange _selectedTimeRange = TimeRange.daily;
  String? _selectedDate;
  TransactionSummary transactionSummary = TransactionSummary(); // Transaction summary instance

  void _enterTransaction() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DateTime now = DateTime.now();
    final createdAt = DateFormat('yyyy-MM-dd').format(now);

    try {
      await firestore.collection('transaction').add({
        'item': _textcontrollerITEM.text,
        'amount': int.parse(_textcontrollerAMOUNT.text),
        'isIncome': _isIncome,
        'createdAt': createdAt,
      });

      _textcontrollerITEM.clear();
      _textcontrollerAMOUNT.clear();

      // Calculate and update daily values in real-time
      _fetchTransactionsAndCalculate(createdAt, createdAt);

      setState(() {});
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save the transaction.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _newTransaction() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('N E W  T R A N S A C T I O N'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Expense'),
                        Switch(
                          value: _isIncome,
                          onChanged: (newValue) {
                            setState(() {
                              _isIncome = newValue;
                            });
                          },
                        ),
                        Text('Income'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Amount?',
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Enter an amount';
                                }
                                return null;
                              },
                              controller: _textcontrollerAMOUNT,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'For what?',
                            ),
                            controller: _textcontrollerITEM,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.grey[600],
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  color: Colors.grey[600],
                  child: Text('Enter', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _enterTransaction();

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _fetchTransactionsAndCalculate(String startDate, String endDate) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('transaction')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .get();

      _calculateIncomeExpenseBalance(querySnapshot);

      // If weekly or monthly is selected, update weekly and monthly values
      if (_selectedTimeRange == TimeRange.weekly || _selectedTimeRange == TimeRange.monthly) {
        _updateWeeklyAndMonthlyValues();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch transactions from Firestore: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _calculateIncomeExpenseBalance(QuerySnapshot<Map<String, dynamic>>? querySnapshot) {
    double totalIncome = 0;
    double totalExpense = 0;

    if (querySnapshot != null) {
      for (final QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        final Map<String, dynamic>? data = document.data();
        bool isIncome = data?['isIncome'] ?? false;

        if (isIncome) {
          totalIncome += data?['amount'] ?? 0.0;
        } else {
          totalExpense += data?['amount'] ?? 0.0;
        }
      }
    }

    setState(() {
      income = totalIncome.toStringAsFixed(2);
      expense = totalExpense.toStringAsFixed(2);
      balance = (totalIncome - totalExpense).toStringAsFixed(2);

      // Update the transaction summary
      transactionSummary.dailyIncome = totalIncome;
      transactionSummary.dailyExpense = totalExpense;
      setState(() {
        dailyExpense = totalExpense;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch data for the current day by default
    final DateTime now = DateTime.now();
    final String today = DateFormat('yyyy-MM-dd').format(now);
    _fetchTransactionsAndCalculate(today, today);
  }

  void _updateWeeklyAndMonthlyValues() {
    final DateTime now = DateTime.now();

    if (_selectedTimeRange == TimeRange.weekly) {
      // Calculate weekly values
      final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
      final String startDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
      final String endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);

      // Query Firestore with the new date format
      _fetchTransactionsAndCalculate(startDate, endDate);

      // Update the transaction summary
      transactionSummary.weeklyIncome = transactionSummary.dailyIncome;
      transactionSummary.weeklyExpense = transactionSummary.dailyExpense;

      transactionSummary.weeklyIncome = transactionSummary.dailyIncome;
      weeklyExpense = transactionSummary.weeklyExpense;

    } else if (_selectedTimeRange == TimeRange.monthly) {
      // Calculate monthly values
      final DateTime startOfMonth = DateTime(now.year, now.month, 1);
      final DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
      final String startDate = DateFormat('yyyy-MM-dd').format(startOfMonth);
  final String endDate = DateFormat('yyyy-MM-dd').format(endOfMonth);

  // Query Firestore with the new date format
  _fetchTransactionsAndCalculate(startDate, endDate);

  // Update the transaction summary
  transactionSummary.monthlyIncome = transactionSummary.dailyIncome;
  transactionSummary.monthlyExpense = transactionSummary.dailyExpense;

  transactionSummary.monthlyIncome = transactionSummary.dailyIncome;
  monthlyExpense = transactionSummary.dailyExpense;
}
}

  Future<void> _showDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      setState(() {
        _selectedDate = formattedDate;
        _selectedTimeRange = TimeRange.chooseDate;
      });

      // Fetch data for the selected date
      _fetchTransactionsAndCalculate(formattedDate, formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TopNeuCard(
              balance: balance,
              income: income,
              expense: expense,
            ),
            DropdownButton<TimeRange>(
              value: _selectedTimeRange,
              items: [
                DropdownMenuItem<TimeRange>(
                  value: TimeRange.daily,
                  child: Text('Daily'),
                ),
                DropdownMenuItem<TimeRange>(
                  value: TimeRange.weekly,
                  child: Text('Weekly'),
                ),
                DropdownMenuItem<TimeRange>(
                  value: TimeRange.monthly,
                  child: Text('Monthly'),
                ),
                DropdownMenuItem<TimeRange>(
                  value: TimeRange.chooseDate,
                  child: Text('Choose Date'),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  _selectedTimeRange = newValue!;
                });

                if (_selectedTimeRange == TimeRange.chooseDate) {
                  _showDatePicker();
                } else {
                  final DateTime now = DateTime.now();
                  final String today = DateFormat('yyyy-MM-dd').format(now);
                  _fetchTransactionsAndCalculate(today, today);
                }
              },
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('transaction').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingCircle();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final documents = snapshot.data?.docs ?? [];

                      // Filter transactions based on selected time range
                      final filteredTransactions = documents.where((document) {
                        final Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                        final String? createdAt = data?['createdAt'] as String?;

                        if (createdAt != null) {
                          if (_selectedTimeRange == TimeRange.daily) {
                            final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
                            return createdAt == now;
                          } else if (_selectedTimeRange == TimeRange.weekly) {
                            // Adjust the condition for weekly based on your logic
                            // For example, you might want to consider the whole week, starting from Sunday
                            return true;
                          } else if (_selectedTimeRange == TimeRange.monthly) {
                            // Adjust the condition for monthly based on your logic
                            return true;
                          } else if (_selectedTimeRange == TimeRange.chooseDate) {
                            // Display transactions for the selected date
                            return createdAt == _selectedDate;
                          }
                        }

                        return false;
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          // Render filteredTransactions[index]
                          final document = filteredTransactions[index];
                          final data = document.data() as Map<String, dynamic>;

                          return Dismissible(
                            key: Key(document.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              FirebaseFirestore.instance.collection('transaction').doc(document.id).delete();
                              // Recalculate values when a transaction is deleted
                              final DateTime now = DateTime.now();
                              final String today = DateFormat('yyyy-MM-dd').format(now);
                              _fetchTransactionsAndCalculate(today, today);
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: MyTransaction(
                              transactionName: data['item'],
                              money: data['amount'].toString(),
                              expenseOrIncome: data['isIncome'] ? 'income' : 'expense',
                              transactionTime: data['createdAt'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            PlusButton(
              function: _newTransaction,
            ),
          ],
        ),
      ),
    );
  }
}


