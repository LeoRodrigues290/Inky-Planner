
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/models/user_profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check if a user profile exists
  Future<bool> doesProfileExist(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists;
  }

  // Get user profile stream
  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _firestore
        .collection('users').doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return UserProfile.fromFirestore(snapshot);
          } else {
            return null;
          }
        });
  }

  // Create or update user profile
  Future<void> saveUserProfile(UserProfile profile) {
    return _firestore
        .collection('users').doc(profile.userId)
        .set(profile.toMap());
  }
}
