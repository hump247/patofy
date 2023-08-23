import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';
import 'package:patofy/screens/pages/barchart.dart';
import 'package:patofy/screens/pages/linechart.dart';
import 'package:patofy/screens/pages/piecharts.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key,});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with SingleTickerProviderStateMixin{

   

  late TabController _tabController;



   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this,);
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
    return  DefaultTabController(
       length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.primaryWhiteColor,
          iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
          title: Text("Analysis",style: TextStyle(color: Styles.primaryRedColor),),
          centerTitle: true,
            bottom: TabBar(
            
                isScrollable: false,
                indicatorColor: Styles.primaryRedColor,
                labelColor: Styles.primaryRedColor,
                unselectedLabelColor: Styles.primaryBlackColor,
                tabs: const [
                  Tab(text: 'Pi chart'),
                  Tab(text: 'Column'),
                  //Tab(text: 'Line chart'),
                ]
              
              ),
        ),
        body:  const TabBarView(
              
              children: [ PieChartPage(), BarChartPage(),
              // LineChartPage()
              ],
            ),
      ),
    );
  }
}