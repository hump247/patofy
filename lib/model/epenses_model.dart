import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  String id;
  String details;
  String category;
  double amount;
  String createdAt;
  String userId;

  Expense({
    required this.id,
    required this.details,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.userId,
  });

  // Create an Expense object from a Firestore document
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      details: data['details'] ?? '',
       category: data['categories'] ?? '',
      amount: data['amount'] ?? 0.0,
      createdAt: data['createdAt'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert the Expense object to a map to be stored in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'details': details,
      'categories': category,
      'amount': amount,
      'createdAt': createdAt,
      'userId': userId,
    };
  }
}
