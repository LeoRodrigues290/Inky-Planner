
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/screens/main_screen.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/auth/screens/login_screen.dart';
import 'package:myapp/features/onboarding/screens/profile_setup_screen.dart';
import 'package:myapp/features/profile/providers/profile_providers.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        // User is logged in, now check if their profile is set up.
        final profileExists = ref.watch(profileExistsProvider);

        return profileExists.when(
          data: (exists) {
            if (exists) {
              return const MainScreen();
            } else {
              return const ProfileSetupScreen();
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => Scaffold(
            body: Center(child: Text('Error checking profile: $err')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Auth Error: $err')),
      ),
    );
  }
}
