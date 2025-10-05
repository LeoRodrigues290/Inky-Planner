
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/daily_log_model.dart';
import 'package:myapp/data/models/food_model.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/nutrition/repositories/nutrition_repository.dart';

// Provider for the NutritionRepository
final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepository();
});

// Provider to keep track of the selected date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// StreamProvider for the daily log, automatically disposes when not in use
final dailyLogProvider = StreamProvider.autoDispose<DailyLog?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final repository = ref.watch(nutritionRepositoryProvider);

  final userId = authState.asData?.value?.uid;

  if (userId != null) {
    return repository.getDailyLogStream(userId, selectedDate);
  } else {
    return Stream.value(null);
  }
});

// FutureProvider for searching foods, using .family for the search query
final foodSearchProvider = FutureProvider.family.autoDispose<List<Food>, String>((ref, query) async {
   final authState = ref.watch(authStateChangesProvider);
   final repository = ref.watch(nutritionRepositoryProvider);
   final userId = authState.asData?.value?.uid;

   if (userId != null && query.isNotEmpty) {
     return repository.searchFoods(userId, query);
   }
   return [];
});
