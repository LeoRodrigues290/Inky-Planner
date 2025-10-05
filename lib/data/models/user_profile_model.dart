
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String userId;
  final String name;
  final String avatarIcon;
  final num targetCalories;
  final num targetProtein;
  final num targetCarbs;
  final num targetFats;

  UserProfile({
    required this.userId,
    required this.name,
    this.avatarIcon = 'default_avatar',
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'avatarIcon': avatarIcon,
      'targetCalories': targetCalories,
      'targetProtein': targetProtein,
      'targetCarbs': targetCarbs,
      'targetFats': targetFats,
    };
  }

  // Create from a Firestore document
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      avatarIcon: data['avatarIcon'] ?? 'default_avatar',
      targetCalories: data['targetCalories'] ?? 0,
      targetProtein: data['targetProtein'] ?? 0,
      targetCarbs: data['targetCarbs'] ?? 0,
      targetFats: data['targetFats'] ?? 0,
    );
  }
}
