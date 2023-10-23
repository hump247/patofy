import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:charts_common/common.dart';

class Transaction {
  final String item;
  final int? amount;

  Transaction({
    required this.item,
    this.amount,
  });
}

class Budget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pie Chart Example'),
        ),
        body: Center(
          child: PieChartWidget(),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  List<Transaction> transactions = [];


  // Function to fetch data from Firestore
  Future<void> fetchData() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('transaction').get();


    final List<Transaction> data = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> docData = document.data() as Map<String, dynamic>;
      return Transaction(
        item: docData['item'] as String,
        amount: docData['amount'] as int?, // Handle null with nullable type
      );
    }).toList();

    setState(() {
      transactions = data;
      print(transactions);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Center(child: CircularProgressIndicator()) // Show a loading indicator
        : PieChart(transactions);
  }
}

Color getColorFromTitle(String title) {
  final int hashCode = sha1.convert(utf8.encode(title)).hashCode;
  final int colorValue = hashCode & 0xFFFFFF;
  final charts.Color chartColor = charts.Color(r: colorValue & 0xFF, g: (colorValue >> 8) & 0xFF, b: (colorValue >> 16) & 0xFF);
  return chartColor;
}

class PieChart extends StatelessWidget {
  final List<Transaction> data;

  PieChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Transaction, String>> series = [
      charts.Series(
        id: 'Items',
        data: data,
        domainFn: (Transaction transaction, _) => transaction.item,
        measureFn: (Transaction transaction, _) => transaction.amount ?? 0,
        colorFn: (Transaction transaction, _) => getColorFromTitle(transaction.item),
        labelAccessorFn: (Transaction transaction, _) =>
        '${transaction.item}: \$${(transaction.amount ?? 0).toStringAsFixed(2)}',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: charts.PieChart(
        series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 60,
        ),
      ),
    );
  }
}