import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';

import '../model/income_model.dart';
import '../services/income_services.dart';
import 'add_income_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncomeTab extends StatefulWidget {
final String sortingOption; 
  const IncomeTab({Key? key, required this.sortingOption}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IncomeTabState createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  String actualIncomeAmount = "0.00"; // Initialize with a default value
  List<Income> incomeList = []; // Initialize an empty list to store income data

final String _sortingOption = 'Day';

  @override
  void initState() {
    super.initState();
    fetchIncomeData(); // Fetch income data when the widget is initialized
  }

  void fetchIncomeData() async {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String currentUserId = user.uid;
      List<Income> fetchedIncomeList = await FirestoreService().getIncomeForUser(currentUserId);
      double totalIncomeAmount = 0.0;

      // Calculate the total income amount
      for (Income income in fetchedIncomeList) {
        totalIncomeAmount += income.amount;

       if (_sortingOption == 'Day') {
          // Filter incomes for the current day
          DateTime createdAtDate = DateTime.parse(income.createdAt);
          DateTime now = DateTime.now();
          if (createdAtDate.year == now.year && createdAtDate.month == now.month && createdAtDate.day == now.day) {
            incomeList.add(income);
          }
        }
      }

      // Sort the income data based on the selected sorting option
      fetchedIncomeList = sortIncomeData(fetchedIncomeList, _sortingOption);

    // Update the state with the actual income amount and sorted income data
    setState(() {
      actualIncomeAmount = totalIncomeAmount.toStringAsFixed(2);
      incomeList = fetchedIncomeList;
    });
  }
}

 // Method to sort the income data based on the selected sorting option
  List<Income> sortIncomeData(List<Income> incomeList, String sortingOption) {
    switch (sortingOption) {
      case 'Day':
        break;
      case 'Week':
        // Implement sorting by week
        break;
      case 'Month':
        // Implement sorting by month
        break;
      case 'Year':
        // Implement sorting by year
        break;
      default:
        break;
    }
    return incomeList;
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
                              "Your Income",
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
                                      actualIncomeAmount,
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
              IncomeListWidget(incomeList: incomeList),
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddIncomeWidget()));
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

class IncomeListWidget extends StatelessWidget {
  final List<Income> incomeList;

  const IncomeListWidget({super.key, required this.incomeList});

  @override
  Widget build(BuildContext context) {
    if (incomeList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Styles.primaryRedColor,
        ));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: incomeList.length,
        itemBuilder: (context, index) {
          Income income = incomeList[index];
          return ListTile(
           leading: CircleAvatar(
            backgroundColor: Styles.primaryRedColor.withOpacity(0.4),
            child:Text(income.category.substring(0,1).toUpperCase()
            
            )
           ),
            title: Text(income.category,style:TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(income.createdAt,style:TextStyle(color: Styles.primaryGreenColor)),
            trailing: Text(income.amount.toStringAsFixed(2),style:TextStyle(color:Styles.primaryGreenColor)),
          );
        },
      );
    }
  }
}
