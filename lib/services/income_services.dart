import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/income_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add income data to Firestore
  Future<void> addIncome(Income income) async {
    try {
      await _firestore.collection('incomes').add(income.toFirestore());
    // ignore: empty_catches
    } catch (e) {
    }
  }


//get income from the firestore firebase with the user id.

  Future<List<Income>> getIncomeForUser(String userId) async {
    List<Income> incomeList = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('incomes')
          .where('userId', isEqualTo: userId)
          .get();

      incomeList = snapshot.docs.map((doc) => Income.fromFirestore(doc)).toList();

    // ignore: empty_catches
    } catch (e) {
    }

    return incomeList;
  }

   // Add the method to get the stream of income data for a specific user
  Stream<List<Income>> streamIncomeForUser(String userId) {
    return _firestore
        .collectionGroup('incomes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Income.fromFirestore(doc)).toList());
  }



  //method to add expensess
}