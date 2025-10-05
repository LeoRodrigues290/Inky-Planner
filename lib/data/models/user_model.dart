
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from a DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt,
    };
  }
}
