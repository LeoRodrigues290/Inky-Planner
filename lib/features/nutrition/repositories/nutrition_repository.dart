
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/daily_log_model.dart';
import 'package:myapp/data/models/food_model.dart';
import 'package:myapp/data/models/logged_food_model.dart';
import 'package:myapp/data/models/meal_model.dart'; // Import Meal model

class NutritionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for the daily log
  Stream<DailyLog?> getDailyLogStream(String userId, DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final docId = '${userId}_$dateString';

    return _firestore.collection('daily_logs').doc(docId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return DailyLog.fromFirestore(snapshot);
      } else {
        // Create a default log if it doesn't exist
        return DailyLog(
          userId: userId,
          logDate: date,
          meals: [
            Meal(mealName: 'Breakfast', foods: []),
            Meal(mealName: 'Lunch', foods: []),
            Meal(mealName: 'Dinner', foods: []),
            Meal(mealName: 'Snacks', foods: []),
          ],
        );
      }
    });
  }

  // Add a food to a meal
  Future<void> addFoodToMeal(String userId, DateTime date, String mealName, Food food, num quantity) async {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final docId = '${userId}_$dateString';
    final docRef = _firestore.collection('daily_logs').doc(docId);

    final loggedFood = LoggedFood(
      foodName: food.foodName,
      quantity: quantity,
      unit: food.servingUnit,
      calories: (food.caloriesPer100g / 100) * quantity,
      protein: (food.proteinPer100g / 100) * quantity,
      carbs: (food.carbsPer100g / 100) * quantity,
      fats: (food.fatsPer100g / 100) * quantity,
    );

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        final newLog = DailyLog(
            userId: userId,
            logDate: date,
            meals: [
              Meal(mealName: 'Breakfast', foods: []),
              Meal(mealName: 'Lunch', foods: []),
              Meal(mealName: 'Dinner', foods: []),
              Meal(mealName: 'Snacks', foods: []),
            ]
        );
        transaction.set(docRef, newLog.toMap());
      }

      final currentLog = DailyLog.fromFirestore(snapshot);
      final updatedMeals = currentLog.meals.map((meal) {
        if (meal.mealName == mealName) {
          meal.foods.add(loggedFood);
        }
        return meal;
      }).toList();

      transaction.update(docRef, {
        'meals': updatedMeals.map((m) => m.toMap()).toList(),
        'totalCalories': FieldValue.increment(loggedFood.calories),
        'totalProtein': FieldValue.increment(loggedFood.protein),
        'totalCarbs': FieldValue.increment(loggedFood.carbs),
        'totalFats': FieldValue.increment(loggedFood.fats),
      });
    });
  }

  // Create a new food in the user's library
  Future<void> createFood(Food food) async {
    await _firestore.collection('foods').add(food.toMap());
  }

  // Search for foods in the user's library
  Future<List<Food>> searchFoods(String userId, String query) async {
    if (query.isEmpty) return [];

    final snapshot = await _firestore
        .collection('foods')
        .where('createdBy', isEqualTo: userId)
        .where('foodName', isGreaterThanOrEqualTo: query)
        .where('foodName', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => Food.fromFirestore(doc)).toList();
  }
}
