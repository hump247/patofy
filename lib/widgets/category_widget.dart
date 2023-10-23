import 'package:flutter/material.dart';
import 'package:patofy/constants/colors.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categories = [
   Category(name: 'Clothes', icon: Icons.shopping_bag),
    Category(name: 'Food & Beverage', icon: Icons.restaurant),
    Category(name: 'Entertainment', icon: Icons.movie),
    Category(name: 'Household', icon: Icons.home),
    Category(name: 'Transport', icon: Icons.directions_car),
    Category(name: 'Gift', icon: Icons.card_giftcard),
    Category(name: 'Health', icon: Icons.local_hospital),
    Category(name: 'Communication', icon: Icons.phone),
    Category(name: 'Pet', icon: Icons.pets),
    Category(name: 'Insurance', icon: Icons.security),
    Category(name: 'Essential Bill', icon: Icons.attach_money),
    Category(name: 'Debt', icon: Icons.money_off),
    Category(name: 'Children', icon: Icons.child_care),
    Category(name: 'Personal Development', icon: Icons.lightbulb),
  ];

  List<Category> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.primaryRedColor,
        iconTheme: IconThemeData(color: Styles.primaryWhiteColor),
        title: Text(
          "Select Expenses Categories",
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items in each row
                childAspectRatio: 1.0, // Aspect ratio of each grid item
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(categories[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.primaryRedColor,
        onPressed: () {
          // Pass the selected categories back to the previous screen (AddIncomeWidget)
          Navigator.pop(context, selectedCategories);
        },
        child: Text(
          "Add",
          style: TextStyle(color: Styles.primaryWhiteColor),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    bool isSelected = selectedCategories.contains(category);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(category);
          } else {
            selectedCategories.add(category);
          }
        });
      },
      child: Container(
        color: isSelected ? Styles.primaryRedColor : Styles.primaryWhiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? Styles.primaryWhiteColor : Styles.primaryRedColor,
            ),
            const SizedBox(height: 8.0),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? Styles.primaryWhiteColor : Styles.primaryRedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}
