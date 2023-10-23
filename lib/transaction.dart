import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String transactionTime; // New property for transaction time

  MyTransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.transactionTime, // Updated constructor to include time
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Column( // Wrap the content in a Column to display name, time, and money vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[500]),
                        child: Center(
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        transactionName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    (expenseOrIncome == 'expense' ? '-' : '+') + '\$' + money,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: expenseOrIncome == 'expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8), // Add some spacing
              Text(
                'Date: ${transactionTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
