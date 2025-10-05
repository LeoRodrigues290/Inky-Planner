
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/models/meal_model.dart';

class DailyLog {
  final String? id;
  final String userId;
  final DateTime logDate;
  final num totalCalories;
  final num totalProtein;
  final num totalCarbs;
  final num totalFats;
  final List<Meal> meals;

  DailyLog({
    this.id,
    required this.userId,
    required this.logDate,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFats = 0,
    required this.meals,
  });

 factory DailyLog.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DailyLog(
      id: doc.id,
      userId: data['userId'] ?? '',
      logDate: (data['logDate'] as Timestamp).toDate(),
      totalCalories: data['totalCalories'] ?? 0,
      totalProtein: data['totalProtein'] ?? 0,
      totalCarbs: data['totalCarbs'] ?? 0,
      totalFats: data['totalFats'] ?? 0,
      meals: (data['meals'] as List<dynamic>? ?? []).map((mealData) => Meal.fromMap(mealData)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'logDate': Timestamp.fromDate(logDate),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }
}
