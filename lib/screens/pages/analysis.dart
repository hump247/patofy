import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Charts extends StatefulWidget {
  final double dailyExpenses;
  final double weeklyExpenses;
  final double monthlyExpenses;

  Charts({
    required this.dailyExpenses,
    required this.weeklyExpenses,
    required this.monthlyExpenses,
  });

  @override
  _BudgetOverviewPageState createState() => _BudgetOverviewPageState(
    dailyExpenses: dailyExpenses,
    weeklyExpenses: weeklyExpenses,
    monthlyExpenses: monthlyExpenses,
  );
}

class _BudgetOverviewPageState extends State<Charts> {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM d, y').format(DateTime.now());
  String formattedWeek = DateFormat('w').format(DateTime.now());

  double dailyExpenses;
  double weeklyExpenses;
  double monthlyExpenses;

  _BudgetOverviewPageState({
    required this.dailyExpenses,
    required this.weeklyExpenses,
    required this.monthlyExpenses,
  }) {
    this.dailyExpenses = dailyExpenses;
    this.weeklyExpenses = weeklyExpenses;
    this.monthlyExpenses = monthlyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BudgetCard(
            title: 'Daily',
            date: formattedDate,
            expenses: dailyExpenses,
            budget: 1500.0, // Replace with actual daily budget
          ),
          BudgetCard(
            title: 'Weekly',
            date: 'Week 38, 2023',
            expenses: weeklyExpenses,
            budget: 7000.0, // Replace with actual weekly budget
          ),
          BudgetCard(
            title: 'Monthly',
            date: 'September 2023',
            expenses: monthlyExpenses,
            budget: 2500.0, // Replace with actual monthly budget
          ),
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final String title;
  final String date;
  final double expenses;
  final double budget;

  BudgetCard({
    required this.title,
    required this.date,
    required this.expenses,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (expenses / budget) * 100;

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              date,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Expenses',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '\$$expenses',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                CircularProgressBar(progress: progress),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressBar extends StatelessWidget {
  final double progress;

  CircularProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 70.0,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 8.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Center(
            child: Text(
              '${progress.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
