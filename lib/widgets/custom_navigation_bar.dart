
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const CustomBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedIconTheme: IconThemeData(color: Styles.primaryRedColor),
      unselectedIconTheme: IconThemeData(color: Styles.primaryBlackColor),
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(color: Styles.primaryRedColor),
      showUnselectedLabels: true,
      unselectedLabelStyle: TextStyle(color: Styles.primaryBlackColor),
      onTap: onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.select_all),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_document),
          label: 'budget',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart
          ),
          label: 'Add Expense',
        ),
      ],
    );
  }
}