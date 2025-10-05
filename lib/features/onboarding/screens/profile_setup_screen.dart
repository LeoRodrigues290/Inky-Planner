
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/user_profile_model.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/profile/providers/profile_providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userId = ref.read(firebaseAuthProvider).currentUser!.uid;
      final profile = UserProfile(
        userId: userId,
        name: _nameController.text,
        targetCalories: num.parse(_caloriesController.text),
        targetProtein: num.parse(_proteinController.text),
        targetCarbs: num.parse(_carbsController.text),
        targetFats: num.parse(_fatsController.text),
      );

      final repo = ref.read(profileRepositoryProvider);
      repo.saveUserProfile(profile).then((_) {
        // The AuthWrapper will automatically navigate to MainScreen
        // because the profileExistsProvider will now return true.
      }).catchError((error) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tell us about yourself', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),
              Text('Your Daily Goals', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Target Calories (kcal)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Target Protein (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: 'Target Carbs (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _fatsController,
                decoration: const InputDecoration(labelText: 'Target Fats (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save and Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
