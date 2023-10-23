import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<Chart> {
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _calculateIncomeExpenseBalance();
  }

  void _calculateIncomeExpenseBalance() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('transactions').get();

      if (querySnapshot != null) {
        for (final QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
          final Map<String, dynamic>? data = document.data();
          bool isIncome = data?['isIncome'] ?? false;

          if (isIncome) {
            totalIncome += data?['amount'] ?? 0.0;
          } else {
            totalExpense += data?['amount'] ?? 0.0;
          }
        }

        setState(() {});
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget buildExpensePieChart() {
    final List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        color: const Color(0xFF5FD0FF),
        value: totalIncome,
        title: 'income',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: const Color(0xFFFF5A5A),
        value: totalExpense,
        title: 'Expense',
        radius: 60,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];

    return PieChart(
      PieChartData(
        sections: pieChartData,
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 0,
        sectionsSpace: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 20),
            buildExpensePieChart(),
          ],
        ),
      ),
    );
  }
}
