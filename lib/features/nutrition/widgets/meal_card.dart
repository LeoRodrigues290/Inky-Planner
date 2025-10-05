
import 'package:flutter/material.dart';
import 'package:myapp/data/models/meal_model.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onAddFood;

  const MealCard({super.key, required this.meal, required this.onAddFood});

  @override
  Widget build(BuildContext context) {
    final totalCalories = meal.foods.fold(0.0, (sum, food) => sum + food.calories);
    final totalProtein = meal.foods.fold(0.0, (sum, food) => sum + food.protein);
    final totalCarbs = meal.foods.fold(0.0, (sum, food) => sum + food.carbs);
    final totalFats = meal.foods.fold(0.0, (sum, food) => sum + food.fats);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(meal.mealName, style: Theme.of(context).textTheme.titleLarge),
            Text('${totalCalories.toStringAsFixed(0)} kcal'),
          ],
        ),
        subtitle: Text('P: ${totalProtein.toStringAsFixed(0)}g | C: ${totalCarbs.toStringAsFixed(0)}g | F: ${totalFats.toStringAsFixed(0)}g'),
        children: [
          ...meal.foods.map((food) {
            return ListTile(
              title: Text(food.foodName),
              subtitle: Text('${food.quantity.toStringAsFixed(0)}${food.unit}'),
              trailing: Text('${food.calories.toStringAsFixed(0)} kcal'),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Food'),
              onPressed: onAddFood,
            ),
          ),
        ],
      ),
    );
  }
}
