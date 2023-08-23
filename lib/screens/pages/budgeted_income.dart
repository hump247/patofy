import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../widgets/budget_expenses.dart';
import '../../widgets/budget_income.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key, });

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> with SingleTickerProviderStateMixin{
  TextEditingController dateController1 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();

DateTime startDate = DateTime.now().add(const Duration(days: 1));





  late TabController _tabController;



   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this,);
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
            title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:14.0),
            child: Text(
            "Create Budget",
            style: TextStyle(
              color: Styles.primaryRedColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
        ],
      ),
            centerTitle: false,
            backgroundColor: Styles.primaryWhiteColor,
            iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Styles.primaryRedColor,
              labelColor: Styles.primaryRedColor,
              unselectedLabelColor: Styles.primaryBlackColor,
              tabs: const [
                Tab(text: 'Income Budget'),
                Tab(text: 'Expense Budget')
              ]
            
            ),
          ),
          body: const TabBarView(
            
            children: [BudgetedIncomeTab(), BudgetedExpensesTab()],
          ),
          ),
    );
        
  }
}