
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/food_model.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/nutrition/providers/nutrition_providers.dart';

class CreateFoodScreen extends ConsumerStatefulWidget {
  final String initialFoodName;
  const CreateFoodScreen({super.key, this.initialFoodName = ''});

  @override
  // ignore: library_private_types_in_public_api
  _CreateFoodScreenState createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends ConsumerState<CreateFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFoodName);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(firebaseAuthProvider).currentUser!.uid;
      final newFood = Food(
        foodName: _nameController.text,
        caloriesPer100g: num.parse(_caloriesController.text),
        proteinPer100g: num.parse(_proteinController.text),
        carbsPer100g: num.parse(_carbsController.text),
        fatsPer100g: num.parse(_fatsController.text),
        createdBy: userId,
        servingUnit: 'g', // Default serving unit
      );

      final repo = ref.read(nutritionRepositoryProvider);
      repo.createFood(newFood).then((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food created successfully!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating food: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a New Food')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Food Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories per 100g'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Protein per 100g'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: 'Carbs per 100g'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _fatsController,
                decoration: const InputDecoration(labelText: 'Fats per 100g'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
