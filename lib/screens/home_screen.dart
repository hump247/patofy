import 'package:flutter/material.dart';
import 'package:patofy/screens/pages/analysis.dart';
import 'package:patofy/screens/pages/budgeted_income.dart';
import 'package:patofy/screens/pages/home_page.dart';
import 'package:patofy/screens/pages/settings_page.dart';

import '../constants/colors.dart';
import '../widgets/custom_navigation_bar.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryWhiteColor,
      appBar: AppBar(
        backgroundColor: Styles.primaryWhiteColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Styles.primaryRedColor,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Styles.primaryWhiteColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png', // Replace with the path to your logo image
                height: 30, // Set the desired height of the logo image
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "patofy",
              style: TextStyle(
                  color: Styles.primaryRedColor, fontWeight: FontWeight.w700),
            )
          ],
        ),
        // actions: <Widget>[
        //   PopupMenuButton(
        //     elevation: 4,
        //     shadowColor: Styles.primaryRedColor,
        //     color: Styles.primaryWhiteColor,
        //     itemBuilder: (BuildContext context) {
        //       return [
        //         PopupMenuItem(child: Text("Choose Chart",textAlign:TextAlign.center,style: TextStyle(color: Styles.primaryBlackColor,fontWeight: FontWeight.w800,fontSize: 18),)),
        //          PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const PieChartPage()));
        //             },
        //             child: Row(
                      
        //               children: [
        //                 Icon(Icons.pie_chart,color: Styles.primaryRedColor,),
        //                const SizedBox(width: 5,),
        //                 const Text("Pie",),
        //               ],
        //             ),
        //           )
        //           ),
        //            PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const BarChartPage()));
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(Icons.bar_chart,color: Styles.primaryRedColor,),
        //                 const SizedBox(width: 5,),
        //                 const Text("Column",),
        //               ],
        //             ),
        //           )
        //           ),
        //           PopupMenuItem(
        //           child: InkWell(
        //             onTap: (){
        //               Navigator.push(context, MaterialPageRoute(builder: (_)=>const LineChartPage()));
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(Icons.table_chart,color: Styles.primaryRedColor,),
        //                 const SizedBox(width: 5,),
        //                 const Text("Line Chart",),
        //               ],
        //             ),
        //           )
        //           ),
        //           ];
        //     },
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Styles.primaryRedColor,
        //     ),
        //   ),
        // ],
      ),
      drawer:const DrawerWidget(),
       body: Center(
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
      
      
    );
  }
  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        // Settings screen
        return const SettingPage();
      case 1:
        // Home screen
        return const HomePage();
      case 2:
        // Add screen
        return const BudgetPage();
      case 3:
        // Add Expense screen
        return const AnalysisPage();
      default:
        return const Text('Error occured');
    }
  }

}




