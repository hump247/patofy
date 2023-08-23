import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
// ignore: depend_on_referenced_packages

import '../../widgets/expenses.dart';
import '../../widgets/income.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();

  DateTime startDate = DateTime.now().add(const Duration(days: 1));


  late TabController _tabController;

  // Sorting state variable
  String _sortingOption = 'Day'; // Default sort option is Day


  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // dateController1.dispose();
    // dateController2.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Styles.primaryWhiteColor,
        //abb bar design
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.transparent),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ActionChip(
                backgroundColor: _sortingOption == 'Day'
                    ? Styles.primaryBlackColor
                    : Styles.primaryWhiteColor,
                label: Text(
                  'Daily',
                  style: TextStyle(
                    color: _sortingOption == 'Day'
                        ? Styles.primaryWhiteColor
                        : Styles.primaryBlackColor,
                  ),
                ),
                onPressed: () {
                  // Handle sorting by Day
                  setState(() {
                    // Your sorting logic here
                    _sortingOption = 'Day';
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ActionChip(
                backgroundColor: _sortingOption == 'Week'
                    ? Styles.primaryBlackColor
                    : Styles.primaryWhiteColor,
                label: Text(
                  'Weekly',
                  style: TextStyle(
                    color: _sortingOption == 'Week'
                        ? Styles.primaryWhiteColor
                        : Styles.primaryBlackColor,
                  ),
                ),
                onPressed: () {
                  // Handle sorting by Week
                  setState(() {
                    // Your sorting logic here
                    _sortingOption = 'Week';
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ActionChip(
                backgroundColor: _sortingOption == 'Month'
                    ? Styles.primaryBlackColor
                    : Styles.primaryWhiteColor,
                label: Text(
                  'Monthly',
                  style: TextStyle(
                    color: _sortingOption == 'Month'
                        ? Styles.primaryWhiteColor
                        : Styles.primaryBlackColor,
                  ),
                ),
                onPressed: () {
                  // Handle sorting by Month
                  setState(() {
                    // Your sorting logic here
                    _sortingOption = 'Month';
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14.0, left: 4),
              child: ActionChip(
                backgroundColor: _sortingOption == 'Year'
                    ? Styles.primaryBlackColor
                    : Styles.primaryWhiteColor,
                label: Text(
                  'Yearly',
                  style: TextStyle(
                    color: _sortingOption == 'Year'
                        ? Styles.primaryWhiteColor
                        : Styles.primaryBlackColor,
                  ),
                ),
                onPressed: () {
                  // Handle sorting by Year
                  setState(() {
                    _sortingOption = 'Year';
                  });
                },
              ),
            ),
          ],
          bottom: TabBar(
              isScrollable: false,
              indicatorColor: Styles.primaryRedColor,
              labelColor: Styles.primaryRedColor,
              unselectedLabelColor: Styles.primaryBlackColor,
              tabs: const [Tab(text: 'Expenses'), Tab(text: 'Income')]),
        ),
        body: TabBarView(
          children: [
            ExpensesTab(
              sortingOption: _sortingOption,
            ),
            IncomeTab(
              sortingOption: _sortingOption,
            )
          ],
        ),
      ),
    );
  }
}
