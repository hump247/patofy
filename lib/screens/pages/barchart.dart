import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import '../../model/charts_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartPage extends StatefulWidget {
  const BarChartPage({Key? key}) : super(key: key);

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  final ChartModel chartModel = ChartModel();
   String selectedDuration = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                height: MediaQuery.of(context).size.width,
                child: FutureBuilder<List<charts.Series<UserExpenses, String>>>(
                  future: chartModel.generateBarChart(), // Fetch the data using the future function
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Styles.primaryRedColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      final barChartData = snapshot.data!;
                      return Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: charts.BarChart(
                                barChartData,
                                animate: true,
                                // Customize the chart appearance
                                barRendererDecorator: charts.BarLabelDecorator<String>(),
                                domainAxis: const charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    labelRotation: 0,
                                  ),
                                ),
                                primaryMeasureAxis: charts.NumericAxisSpec(
                                  renderSpec: charts.GridlineRendererSpec(
                                    labelStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.gray.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: barChartData.first.data.map((data) {
                              return SizedBox(
                                height: 20,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Color.fromARGB(
                                        data.color.a,
                                        data.color.r,
                                        data.color.g,
                                        data.color.b,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      data.domain,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
