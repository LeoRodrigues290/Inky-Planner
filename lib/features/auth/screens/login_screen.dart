
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';

// Define a type for the auth action function
typedef AuthAction = Future<UserCredential> Function({
  required String email,
  required String password,
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit(AuthAction action) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await action(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navigation will be handled by the AuthWrapper
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed.')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('NutriTrack', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Please enter an email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => (value?.length ?? 0) < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _submit(
                            ref.read(firebaseAuthProvider).signInWithEmailAndPassword),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => _submit(ref
                            .read(firebaseAuthProvider)
                            .createUserWithEmailAndPassword),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
