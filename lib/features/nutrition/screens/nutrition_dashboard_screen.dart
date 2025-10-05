
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/nutrition/providers/nutrition_providers.dart';
import 'package:myapp/features/nutrition/screens/add_food_screen.dart';
import 'package:myapp/features/nutrition/widgets/macros_summary_card.dart';
import 'package:myapp/features/nutrition/widgets/meal_card.dart';

class NutritionDashboardScreen extends ConsumerWidget {
  const NutritionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(firebaseAuthProvider);
    final dailyLogAsync = ref.watch(dailyLogProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    void selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
      );
      if (picked != null && picked != selectedDate) {
        ref.read(selectedDateProvider.notifier).state = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMd().format(selectedDate)),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: selectDate),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.signOut(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: dailyLogAsync.when(
        data: (dailyLog) {
          if (dailyLog == null) {
            return const Center(child: Text('No log available.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MacrosSummaryCard(dailyLog: dailyLog),
                const SizedBox(height: 24),
                ...dailyLog.meals.map((meal) {
                  return MealCard(
                    meal: meal,
                    onAddFood: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddFoodScreen(mealName: meal.mealName),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
