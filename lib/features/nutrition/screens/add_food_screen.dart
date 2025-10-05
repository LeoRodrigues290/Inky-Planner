
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/food_model.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart'; // Import auth provider
import 'package:myapp/features/nutrition/providers/nutrition_providers.dart';
import 'package:myapp/features/nutrition/screens/create_food_screen.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  final String mealName;
  const AddFoodScreen({super.key, required this.mealName});

  @override
  // ignore: library_private_types_in_public_api
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.length > 2) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  void _showAddFoodDialog(Food food) {
    final quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add ${food.foodName}'),
          content: TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity (${food.servingUnit})'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final quantity = num.tryParse(quantityController.text);
                if (quantity != null) {
                  final repo = ref.read(nutritionRepositoryProvider);
                  final selectedDate = ref.read(selectedDateProvider);
                  final userId = ref.read(firebaseAuthProvider).currentUser!.uid;
                  repo.addFoodToMeal(userId, selectedDate, widget.mealName, food, quantity);
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to dashboard
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(foodSearchProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(title: Text('Add Food to ${widget.mealName}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a food...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (foods) {
                if (foods.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateFoodScreen(initialFoodName: _searchQuery),
                          ),
                        );
                      },
                      child: const Text('Food not found. Create it?'),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return ListTile(
                      title: Text(food.foodName),
                      subtitle: Text('${food.caloriesPer100g} kcal per 100g'),
                      onTap: () => _showAddFoodDialog(food),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
