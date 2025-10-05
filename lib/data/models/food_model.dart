
import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String? id;
  final String foodName;
  final num caloriesPer100g;
  final num proteinPer100g;
  final num carbsPer100g;
  final num fatsPer100g;
  final String servingUnit;
  final String createdBy;

  Food({
    this.id,
    required this.foodName,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatsPer100g,
    this.servingUnit = 'g',
    required this.createdBy,
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      foodName: data['foodName'] ?? '',
      caloriesPer100g: data['caloriesPer100g'] ?? 0,
      proteinPer100g: data['proteinPer100g'] ?? 0,
      carbsPer100g: data['carbsPer100g'] ?? 0,
      fatsPer100g: data['fatsPer100g'] ?? 0,
      servingUnit: data['servingUnit'] ?? 'g',
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'caloriesPer100g': caloriesPer100g,
      'proteinPer100g': proteinPer100g,
      'carbsPer100g': carbsPer100g,
      'fatsPer100g': fatsPer100g,
      'servingUnit': servingUnit,
      'createdBy': createdBy,
    };
  }
}
