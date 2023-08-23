import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../model/charts_model.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({Key? key}) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  String selectedDuration = '';
  final ChartModel chartModel = ChartModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            label: const Text('Daily'),
                            onPressed: () {
                              setState(() {
                                selectedDuration = 'Daily';
                              });
                              // fetchDataBasedOnDuration('Daily');
                            },
                            backgroundColor: selectedDuration == 'Daily'
                                ? Styles.primaryBlackColor
                                : null,
                            labelStyle: TextStyle(
                              color: selectedDuration == 'Daily'
                                  ? Styles.primaryWhiteColor
                                  : Styles.primaryBlackColor,
                            ),
                            
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ActionChip(
                          label: const Text('Weekly'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = 'Weekly';
                            });
                            // fetchDataBasedOnDuration('Weekly');
                          },
                          backgroundColor: selectedDuration == 'Weekly'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == 'Weekly'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ActionChip(
                          label: const Text('Monthly'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = 'Monthly';
                            });
                            // fetchDataBasedOnDuration('Monthly');
                          },
                          backgroundColor: selectedDuration == 'Monthly'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == 'Monthly'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ActionChip(
                          label: const Text('Yearly'),
                          onPressed: () {
                            setState(() {
                              selectedDuration = 'Yearly';
                            });
                            // fetchDataBasedOnDuration('Yearly');
                          },
                          backgroundColor: selectedDuration == 'Yearly'
                              ? Styles.primaryBlackColor
                              : null,
                          labelStyle: TextStyle(
                            color: selectedDuration == 'Yearly'
                                ? Styles.primaryWhiteColor
                                : Styles.primaryBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                // height: MediaQuery.of(context).size.height * 0.9,
                child: FutureBuilder<Map<String, double>>(
                  future: chartModel.generatePieChart(), // Fetch the data using the future function
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:CircularProgressIndicator(
                          color: Styles.primaryRedColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final pieChartData = snapshot.data!;
                      return PieChart(
                        dataMap: pieChartData,
                        animationDuration: const Duration(milliseconds: 500),
                        chartLegendSpacing: 32.0,
                        chartRadius: null,
                        colorList: const [
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                           Colors.yellow,
                           
                        ],
                        legendOptions: const LegendOptions(
                          showLegendsInRow: true,
                          legendPosition: LegendPosition.bottom,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
