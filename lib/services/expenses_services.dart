import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/epenses_model.dart';

class ExpenseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add expenses data to Firestore
  Future<void> addExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').add(expense.toFirestore());
      print("Expenses data added successfully");
    } catch (e) {
      print("Error adding expenses data: $e");
    }
  }

//get expenses from the firestore firebase with the user id.

  Future<List<Expense>> getExpensesForUser(String userId) async {
    List<Expense> expensList = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      expensList =
          snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();

      print("Expenses data received");
    } catch (e) {
      print('Error getting expense data for user: $e');
    }

    return expensList;
  }

  // Add the method to get the stream of expenses data for a specific user
  Stream<List<Expense>> streamExpensesForUser(String userId) {
    return _firestore
        .collectionGroup('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList());
  }
}
