import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartModel {
  Future<List<charts.Series<UserExpenses, String>>> generateBarChart() async {
    final List<UserExpenses> expensesData = await fetchExpensesDataFromFirestore();

    return [
      charts.Series<UserExpenses, String>(
        id: 'Expenses',
        domainFn: (UserExpenses expenses, _) => expenses.category,
        measureFn: (UserExpenses expenses, _) => expenses.amount,
        data: expensesData,
        colorFn: (UserExpenses expenses, _) => expenses.color,
        labelAccessorFn: (UserExpenses expenses, _) =>
            '\$${expenses.amount.toStringAsFixed(2)}',
      ),
    ];
  }

  Future<List<UserExpenses>> fetchExpensesDataFromFirestore() async {
    // Replace 'your_collection_name' with the actual name of your expenses collection in Firestore
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    return snapshot.docs.map((doc) {
      final String category = doc['categories'];
      final double amount = doc['amount'].toDouble();

      // You can also get the 'color' and 'domain' properties from Firestore if you store them there
      return UserExpenses(category, amount, charts.MaterialPalette.blue.shadeDefault, category);
    }).toList();
  }

 Future<Map<String, double>> generatePieChart() async {
    final List<IncomeData> incomesData = await fetchIncomesDataFromFirestore();

    final Map<String, double> data = {};
    for (var income in incomesData) {
      data[income.source] = income.amount;
    }

    return data;
  }

  Future<List<IncomeData>> fetchIncomesDataFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('expenses').get();

    return snapshot.docs.map((doc) {
      final String category= doc['categories'];
      final double amount = doc['amount'].toDouble();

      return IncomeData(category, amount);
    }).toList();
  }
}

class UserExpenses {
  final String category;
  final double amount;
  final charts.Color color;
  final String domain; // Add the domain property

  UserExpenses(this.category, this.amount, this.color, this.domain);
}

class IncomeData {
  final String source;
  final double amount;

  IncomeData(this.source, this.amount);
}
