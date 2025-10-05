
import 'package:myapp/data/models/logged_food_model.dart';

class Meal {
  final String mealName;
  final List<LoggedFood> foods;

  Meal({required this.mealName, required this.foods});

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      mealName: map['mealName'] ?? '',
      foods: (map['foods'] as List<dynamic>? ?? []).map((foodData) => LoggedFood.fromMap(foodData)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'foods': foods.map((food) => food.toMap()).toList(),
    };
  }
}
