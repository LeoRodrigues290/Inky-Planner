
class LoggedFood {
  final String foodName;
  final num quantity;
  final String unit;
  final num calories;
  final num protein;
  final num carbs;
  final num fats;

  LoggedFood({
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  factory LoggedFood.fromMap(Map<String, dynamic> map) {
    return LoggedFood(
      foodName: map['foodName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unit: map['unit'] ?? 'g',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0,
      carbs: map['carbs'] ?? 0,
      fats: map['fats'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  }
}
