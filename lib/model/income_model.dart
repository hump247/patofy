import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  String id;
  String details;
  String category;
  double amount;
  String createdAt;
  String userId;

  Income({
    required this.id,
    required this.details,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.userId,
  });

  // Create an Income object from a Firestore document
  factory Income.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Income(
      id: doc.id,
      details: data['details'] ?? '',
       category: data['categories'] ?? '',
      amount: data['amount'] ?? 0.0,
      createdAt: data['createdAt'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert the Income object to a map to be stored in Firestore
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
