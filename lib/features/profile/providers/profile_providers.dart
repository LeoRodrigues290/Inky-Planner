
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/user_profile_model.dart';
import 'package:myapp/features/auth/providers/auth_providers.dart';
import 'package:myapp/features/profile/repositories/profile_repository.dart';

// Provider for the repository itself
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// StreamProvider to get the user's profile data in real-time
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final repo = ref.watch(profileRepositoryProvider);

  final userId = authState.asData?.value?.uid;
  if (userId != null) {
    return repo.getUserProfileStream(userId);
  }
  return Stream.value(null);
});

// FutureProvider to check if a profile exists. Used in the AuthWrapper.
final profileExistsProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  final repo = ref.watch(profileRepositoryProvider);

  final userId = authState.asData?.value?.uid;
  if (userId != null) {
    return await repo.doesProfileExist(userId);
  }
  return false;
});
