// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../model/epenses_model.dart';
// import '../model/income_model.dart';

// class CalculateBudget{

// //fetch all incomes and expenses from the firebase firestore collections
// List<Expense> expenses = [];
// List<Income> incomes = [];

// double totalWeeklyIncome = 0;
// double totalWeeklyEpense =0;

// double totalMonthlyIncome=0;
// double totalMonthlyExpense=0;

// double totalYearlyIncome =0;
// double totalYearlyExpense =0;

//   DateTime? parseDate(String dateString) {
//     try {
//       return DateTime.parse(dateString);
//     } catch (e) {
//       // Return null if the date string is not in the correct format
//       return null;
//     }
//   }


// Future<void> fetchExpenseData(String userId) async{
//   final expenseSnapshot = await FirebaseFirestore.instance
//   .collection('expenses')
//   .where('userId' , isEqualTo: userId)
//   .get();
//   expenses = expenseSnapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
// }

// Future<void> fetchIncomeData(String userId) async{
//   final incomeSpashot = await FirebaseFirestore.instance
//   .collection('incomes')
//   .where('userId', isEqualTo: userId)
//   .get();

//   incomes = incomeSpashot.docs.map((doc) => Income.fromFirestore(doc)).toList();
// }


//   //handle weeekly calculated budget logic 
//    Future<void> calculateWeekBudget(proposedBudgetAmount) async{

//     final currentDate = DateTime.now();

//       //calculate total income

//        // Calculate total weekly income
//     totalWeeklyIncome = incomes
//         .where((income) {
//           final date = parseDate(income.createdAt);
//           return date != null && date.isAfter(currentDate.subtract(const Duration(days: 30)));
//         })
//         .map((income) => income.amount)
//         .fold(0, (sum, amount) => sum + amount);

//         //calculate total weekly expense

//         totalWeeklyEpense = expenses
//         .where((expense) {
//           final date = parseDate(expense.createdAt);
//           return date != null && date.isAfter(currentDate.subtract(const Duration(days: 30)));
//         })
//         .map((expense) => expense.amount)
//         .fold(0, (sum, amount) => sum + amount);
        

//          void compareWeeklyBudget(double totalIncome, double totalExpense ){
//           if(totalIncome > totalExpense){

//             print("Goood range");

//           }else{
//             print("Your expense are greate");
//           }
//         }
//         compareWeeklyBudget(totalWeeklyIncome, totalWeeklyEpense);
//    }

//    void generateProposedBudget( double availableIncome){

//     //calculate the difference betweeen total income and expense
//     double shortFall = totalWeeklyEpense - totalWeeklyIncome;

//     double dailyFall = shortFall / 7 ;

//     double proposeBudget = availableIncome - dailyFall ;

//     print("Your budget for next week should be $proposeBudget");
//    }

//    //handle monthly calculated budget logic her

//    Future<void> calculateMonthBudget() async{

//    }

//    //handle yearly calcultated budget logic

//    Future<void> calculateYearlBudget() async{

//    }

// }