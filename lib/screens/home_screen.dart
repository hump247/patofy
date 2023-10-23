import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patofy/screens/pages/analysis.dart';
import 'package:patofy/screens/pages/budgeted_income.dart';
import 'package:patofy/home_page.dart';
import 'package:patofy/screens/pages/settings_page.dart';

import '../Enter_budget.dart';
import '../constants/colors.dart';
import '../widgets/custom_navigation_bar.dart';

import 'package:intl/intl.dart';

import '../widgets/drawer.dart';
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

TransactionSummary transactionSummary = TransactionSummary();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double dailyExpense = 0.0;
  double weeklyExpense = 0.0;
  double monthlyExpense = 0.0;
  String income = '';
  String expense = '';
  String balance = '';
  TimeRange _selectedTimeRange = TimeRange.daily;
  String? _selectedDate;
  TransactionSummary transactionSummary = TransactionSummary();

  int _currentIndex = 1;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      monthlyExpense = transactionSummary.monthlyExpense;
    }
  }

  Future<void> _fetchTransactionsAndCalculate(String startDate, String endDate) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('transactions')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryWhiteColor,
      appBar: AppBar(
        backgroundColor: Styles.primaryWhiteColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Styles.primaryRedColor,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Styles.primaryWhiteColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png', // Replace with the path to your logo image
                height: 30, // Set the desired height of the logo image
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "patofy",
              style: TextStyle(
                  color: Styles.primaryRedColor, fontWeight: FontWeight.w700),
            )
          ],
        ),
        // actions: <Widget>[
        //   PopupMenuButton(
        //     elevation: 4,
        //     shadowColor: Styles.primaryRedColor,
        //     color: Styles.primaryWhiteColor,
        //     itemBuilder: (BuildContext context) {
        //       return [
        //         PopupMenuItem(child: Text("Choose Chart",textAlign:TextAlign.center,style: TextStyle(color: Styles.primaryBlackColor,fontWeight: FontWeight.w800,fontSize: 18),)),
        //          PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const PieChartPage()));
        //             },
        //             child: Row(
                      
        //               children: [
        //                 Icon(Icons.pie_chart,color: Styles.primaryRedColor,),
        //                const SizedBox(width: 5,),
        //                 const Text("Pie",),
        //               ],
        //             ),
        //           )
        //           ),
        //            PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const BarChartPage()));
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(Icons.bar_chart,color: Styles.primaryRedColor,),
        //                 const SizedBox(width: 5,),
        //                 const Text("Column",),
        //               ],
        //             ),
        //           )
        //           ),
        //           PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const LineChartPage()));
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(Icons.table_chart,color: Styles.primaryRedColor,),
        //                 const SizedBox(width: 5,),
        //                 const Text("Line Chart",),
        //               ],
        //             ),
        //           )
        //           ),
        //           ];
        //     },
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Styles.primaryRedColor,
        //     ),
        //   ),
        // ],
      ),
      drawer:const DrawerWidget(),
       body: Center(
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      
    );
  }
  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        // Settings screen
        return const SettingPage();
      case 1:
        // Home screen
        return const HomePage();
      case 2:
        // Add screen
        return  Budget();
      case 3:
        // Add Expense screen
        return  Charts(dailyExpenses: dailyExpense, weeklyExpenses: weeklyExpense, monthlyExpenses: monthlyExpense,);
      default:
        return const Text('Error occured');
    }
  }

}




